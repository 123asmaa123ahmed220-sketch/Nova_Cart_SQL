import pyodbc
from faker import Faker
import random
from datetime import date, timedelta

# ==========================================
# 1. Setup
# ==========================================

fake = Faker()

connection = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=NovaCart;"
    "Trusted_Connection=yes;"
)

cursor = connection.cursor()

print("Connected to NovaCart successfully!")


# ==========================================
# 2. Add Products
# ==========================================

product_names = {
    1: [
        'Wireless Mouse', 'Keyboard', 'USB Cable',
        'Power Bank', 'Laptop Stand', 'Webcam',
        'Smartphone Case', 'Earbuds', 'Gaming Mouse',
        'Bluetooth Keyboard'
    ],

    2: [
        'Hoodie', 'Jeans Jacket', 'Casual Shirt',
        'Sports T-Shirt', 'Cotton Pants', 'Sweatshirt',
        'Summer Dress', 'Cap', 'Polo Shirt', 'Winter Jacket'
    ],

    3: [
        'Coffee Maker', 'Blender', 'Toaster',
        'Dinner Set', 'Storage Box', 'Kitchen Scale',
        'Water Bottle', 'Food Container', 'Microwave',
        'Kitchen Organizer'
    ],

    4: [
        'Face Wash', 'Shampoo', 'Body Lotion',
        'Lip Balm', 'Sunscreen', 'Hair Serum',
        'Perfume', 'Hand Cream', 'Face Mask', 'Hair Oil'
    ],

    5: [
        'Football', 'Tennis Racket', 'Dumbbells',
        'Skipping Rope', 'Sports Bag', 'Basketball',
        'Resistance Band', 'Gym Gloves', 'Yoga Ball', 'Training Shoes'
    ]
}

# Check current maximum ProductID
cursor.execute("SELECT ISNULL(MAX(ProductID), 0) FROM Product")
max_product_id = cursor.fetchone()[0]

# We want 50 products
current_products = max_product_id

for product_id in range(current_products + 1, 51):

    category_id = random.randint(1, 5)

    product_name = random.choice(product_names[category_id])

    selling_price = round(random.uniform(100, 5000), 2)

    stock_quantity = random.randint(10, 100)

    cursor.execute("""
        INSERT INTO Product
        (ProductID, ProductName, CategoryID, SellingPrice, StockQuantity)
        VALUES (?, ?, ?, ?, ?)
    """,
    product_id,
    product_name,
    category_id,
    selling_price,
    stock_quantity
    )

connection.commit()

print("Products completed.")


# ==========================================
# 3. Get existing Customers and Products
# ==========================================

cursor.execute("SELECT CustomerID FROM Customer")
customer_ids = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT ProductID, SellingPrice FROM Product")
products = cursor.fetchall()

print(f"Customers available: {len(customer_ids)}")
print(f"Products available: {len(products)}")


# ==========================================
# 4. Add Orders
# ==========================================

cursor.execute("SELECT ISNULL(MAX(OrderID), 0) FROM [Order]")
max_order_id = cursor.fetchone()[0]

# We want 200 orders
for order_id in range(max_order_id + 1, 201):

    customer_id = random.choice(customer_ids)

    order_date = fake.date_between(
        start_date='-1y',
        end_date='today'
    )

    status = random.choice([
        'Pending',
        'Shipped',
        'Delivered',
        'Cancelled'
    ])

    cursor.execute("""
        INSERT INTO [Order]
        (OrderID, CustomerID, OrderDate, Status)
        VALUES (?, ?, ?, ?)
    """,
    order_id,
    customer_id,
    order_date,
    status
    )

connection.commit()

print("Orders completed.")


# ==========================================
# 5. Add OrderItems
# ==========================================

cursor.execute("SELECT OrderID FROM [Order]")
order_ids = [row[0] for row in cursor.fetchall()]

# Dictionary for product prices
product_prices = {
    product_id: price
    for product_id, price in products
}

cursor.execute("SELECT OrderID, ProductID FROM OrderItem")
existing_order_items = {
    (row[0], row[1])
    for row in cursor.fetchall()
}

for order_id in order_ids:

    # Each order contains 1 to 4 products
    number_of_products = random.randint(1, 4)

    selected_products = random.sample(
        list(product_prices.keys()),
        number_of_products
    )

    for product_id in selected_products:

        # Skip if this Order/Product combination already exists
        if (order_id, product_id) in existing_order_items:
            continue

        quantity = random.randint(1, 5)

        # Usually purchase price is current price,
        # but sometimes it differs to simulate price changes
        current_price = product_prices[product_id]

        price_change = random.choice([
            0,
            0,
            0,
            -50,
            -100,
            50,
            100
        ])

        unit_price = max(
            50,
            round(current_price + price_change, 2)
        )

        cursor.execute("""
            INSERT INTO OrderItem
            (OrderID, ProductID, Quantity, UnitPrice)
            VALUES (?, ?, ?, ?)
        """,
        order_id,
        product_id,
        quantity,
        unit_price
        )

        existing_order_items.add((order_id, product_id))

connection.commit()

print("OrderItems completed.")


# ==========================================
# 6. Add Payments
# ==========================================

cursor.execute("SELECT OrderID FROM Payment")
paid_orders = {row[0] for row in cursor.fetchall()}

cursor.execute("""
    SELECT
        O.OrderID,
        SUM(OI.Quantity * OI.UnitPrice) AS TotalAmount
    FROM [Order] O
    JOIN OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY O.OrderID
""")

order_totals = cursor.fetchall()

for order_id, total_amount in order_totals:

    if order_id in paid_orders:
        continue

    payment_date = fake.date_between(
        start_date='-1y',
        end_date='today'
    )

    payment_method = random.choice([
        'Credit Card',
        'PayPal',
        'COD'
    ])

    cursor.execute("""
        INSERT INTO Payment
        (PaymentID, OrderID, PaymentDate, PaymentAmount, PaymentMethod)
        VALUES (?, ?, ?, ?, ?)
    """,
    order_id,
    order_id,
    payment_date,
    round(total_amount, 2),
    payment_method
    )

connection.commit()

print("Payments completed.")


# ==========================================
# 7. Add Reviews
# ==========================================

cursor.execute("SELECT ISNULL(MAX(ReviewID), 0) FROM Review")
max_review_id = cursor.fetchone()[0]

cursor.execute("SELECT CustomerID FROM Customer")
all_customers = [row[0] for row in cursor.fetchall()]

review_comments = [
    'Excellent experience.',
    'Very good service.',
    'Good product quality.',
    'Fast delivery.',
    'I am satisfied with my order.',
    'The service was good.',
    'Nice shopping experience.',
    'The product was acceptable.',
    'Very satisfied.',
    'Good quality and reasonable price.'
]

# Add approximately 100 reviews
for review_id in range(max_review_id + 1, 101):

    customer_id = random.choice(all_customers)

    rating = random.randint(1, 5)

    comment = random.choice(review_comments)

    review_date = fake.date_between(
        start_date='-1y',
        end_date='today'
    )

    cursor.execute("""
        INSERT INTO Review
        (ReviewID, CustomerID, Rating, Comment, ReviewDate)
        VALUES (?, ?, ?, ?, ?)
    """,
    review_id,
    customer_id,
    rating,
    comment,
    review_date
    )

connection.commit()

print("Reviews completed.")


# ==========================================
# 8. Close connection
# ==========================================

cursor.close()
connection.close()

print("----------------------------------")
print("NovaCart dataset completed!")
print("----------------------------------")