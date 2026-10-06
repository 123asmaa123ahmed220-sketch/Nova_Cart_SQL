CREATE DATABASE NovaCart;

USE NovaCart;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    HomeAddress VARCHAR(200),
    JoinDate DATE NOT NULL
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    SellingPrice DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
);

CREATE TABLE [Order] (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE OrderItem (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (OrderID, ProductID),

    FOREIGN KEY (OrderID)
        REFERENCES [Order](OrderID),

    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);
SELECT *
FROM OrderItem;

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL,

    FOREIGN KEY (OrderID)
        REFERENCES [Order](OrderID),

    CHECK (PaymentMethod IN ('Credit Card', 'PayPal', 'COD'))
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL,
    Comment VARCHAR(500),
    ReviewDate DATE NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),

    CHECK (Rating BETWEEN 1 AND 5)
);

USE NovaCart;

INSERT INTO Customer
    (CustomerID, FullName, Email, PhoneNumber, HomeAddress, JoinDate)
VALUES
    (1, 'Ahmed Hassan', 'ahmed.hassan@email.com', '01012345678', 'Cairo', '2025-01-15'),
    (2, 'Mariam Ali', 'mariam.ali@email.com', '01123456789', 'Giza', '2025-02-20'),
    (3, 'Omar Mohamed', 'omar.mohamed@email.com', '01234567890', 'Alexandria', '2025-03-10'),
    (4, 'Sara Mahmoud', 'sara.mahmoud@email.com', '01098765432', 'Cairo', '2025-03-25'),
    (5, 'Youssef Adel', 'youssef.adel@email.com', '01198765432', 'Mansoura', '2025-04-05'),
    (6, 'Nour Ahmed', 'nour.ahmed@email.com', '01298765432', 'Giza', '2025-04-18'),
    (7, 'Mohamed Samir', 'mohamed.samir@email.com', '01055556666', 'Cairo', '2025-05-02'),
    (8, 'Salma Ibrahim', 'salma.ibrahim@email.com', '01166667777', 'Tanta', '2025-05-15'),
    (9, 'Karim Mostafa', 'karim.mostafa@email.com', '01277778888', 'Alexandria', '2025-06-01'),
    (10, 'Hana Emad', 'hana.emad@email.com', '01088889999', 'Cairo', '2025-06-20');

SELECT *
FROM Customer;

INSERT INTO Category
    (CategoryID, CategoryName)
VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Home & Kitchen'),
    (4, 'Beauty'),
    (5, 'Sports');

SELECT *
FROM Category;

INSERT INTO Product
    (ProductID, ProductName, CategoryID, SellingPrice, StockQuantity)
VALUES
    (1, 'Wireless Headphones', 1, 1200.00, 50),
    (2, 'Smart Watch', 1, 2500.00, 30),
    (3, 'USB-C Charger', 1, 450.00, 80),
    (4, 'Cotton T-Shirt', 2, 350.00, 100),
    (5, 'Denim Jeans', 2, 900.00, 60),
    (6, 'Running Shoes', 5, 1800.00, 40),
    (7, 'Electric Kettle', 3, 750.00, 35),
    (8, 'Non-Stick Pan', 3, 650.00, 45),
    (9, 'Face Moisturizer', 4, 500.00, 70),
    (10, 'Hair Dryer', 4, 1100.00, 25),
    (11, 'Yoga Mat', 5, 600.00, 55),
    (12, 'Bluetooth Speaker', 1, 1500.00, 20);

    INSERT INTO [Order]
    (OrderID, CustomerID, OrderDate, Status)
VALUES
    (1, 1, '2025-06-25', 'Delivered'),
    (2, 2, '2025-06-26', 'Shipped'),
    (3, 3, '2025-06-27', 'Delivered'),
    (4, 1, '2025-06-28', 'Pending'),
    (5, 4, '2025-06-29', 'Delivered'),
    (6, 5, '2025-07-01', 'Cancelled'),
    (7, 6, '2025-07-02', 'Shipped'),
    (8, 7, '2025-07-03', 'Delivered'),
    (9, 8, '2025-07-04', 'Pending'),
    (10, 9, '2025-07-05', 'Delivered'),
    (11, 10, '2025-07-06', 'Shipped'),
    (12, 3, '2025-07-07', 'Delivered');

    INSERT INTO OrderItem
    (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 1, 1, 1200.00),
    (1, 3, 2, 450.00),

    (2, 2, 1, 2500.00),
    (2, 4, 2, 350.00),

    (3, 6, 1, 1800.00),
    (3, 11, 2, 600.00),

    (4, 12, 1, 1500.00),

    (5, 7, 1, 750.00),
    (5, 8, 2, 650.00),

    (6, 5, 1, 900.00),

    (7, 9, 2, 500.00),
    (7, 10, 1, 1100.00),

    (8, 1, 1, 1200.00),
    (8, 6, 1, 1800.00),

    (9, 4, 3, 350.00),

    (10, 2, 1, 2500.00),
    (10, 12, 1, 1500.00),

    (11, 8, 1, 650.00),

    (12, 3, 2, 450.00),
    (12, 11, 1, 600.00);

    INSERT INTO Payment
    (PaymentID, OrderID, PaymentDate, PaymentAmount, PaymentMethod)
VALUES
    (1, 1, '2025-06-25', 2100.00, 'Credit Card'),
    (2, 2, '2025-06-26', 3200.00, 'PayPal'),
    (3, 3, '2025-06-27', 3000.00, 'Credit Card'),
    (4, 4, '2025-06-28', 1500.00, 'COD'),
    (5, 5, '2025-06-29', 2050.00, 'Credit Card'),
    (6, 6, '2025-07-01', 900.00, 'PayPal'),
    (7, 7, '2025-07-02', 2100.00, 'Credit Card'),
    (8, 8, '2025-07-03', 3000.00, 'COD'),
    (9, 9, '2025-07-04', 1050.00, 'PayPal'),
    (10, 10, '2025-07-05', 4000.00, 'Credit Card'),
    (11, 11, '2025-07-06', 650.00, 'COD'),
    (12, 12, '2025-07-07', 1500.00, 'Credit Card');

    INSERT INTO Review
    (ReviewID, CustomerID, Rating, Comment, ReviewDate)
VALUES
    (1, 1, 5, 'Excellent shopping experience.', '2025-06-30'),
    (2, 2, 4, 'Good products and fast delivery.', '2025-07-02'),
    (3, 3, 5, 'Very satisfied with my order.', '2025-07-03'),
    (4, 4, 4, 'Good quality and service.', '2025-07-04'),
    (5, 5, 3, 'The product was acceptable.', '2025-07-05'),
    (6, 6, 5, 'Great experience.', '2025-07-06'),
    (7, 7, 4, 'The order arrived on time.', '2025-07-07'),
    (8, 8, 5, 'Excellent service.', '2025-07-08');

    SELECT COUNT(*) AS TotalCustomers
FROM Customer;

USE NovaCart;

SELECT 'Customer' AS TableName, COUNT(*) AS TotalRows FROM Customer
UNION ALL
SELECT 'Category', COUNT(*) FROM Category
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'Order', COUNT(*) FROM [Order]
UNION ALL
SELECT 'OrderItem', COUNT(*) FROM OrderItem
UNION ALL
SELECT 'Payment', COUNT(*) FROM Payment
UNION ALL
SELECT 'Review', COUNT(*) FROM Review;

USE NovaCart;

INSERT INTO Category (CategoryID, CategoryName)
VALUES
(6, 'Books'),
(7, 'Toys'),
(8, 'Groceries'),
(9, 'Accessories'),
(10, 'Office Supplies');

USE NovaCart;

-- 1. Customer with more than one order
SELECT CustomerID, COUNT(*) AS OrderCount
FROM [Order]
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- 2. Customer with no orders
SELECT c.CustomerID, c.FullName
FROM Customer c
LEFT JOIN [Order] o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;


-- 3. Order containing more than one product
SELECT OrderID, COUNT(*) AS ProductCount
FROM OrderItem
GROUP BY OrderID
HAVING COUNT(*) > 1;


-- 4. Product appearing in more than one order
SELECT ProductID, COUNT(*) AS OrderCount
FROM OrderItem
GROUP BY ProductID
HAVING COUNT(*) > 1;


-- 5. Product never ordered
SELECT p.ProductID, p.ProductName
FROM Product p
LEFT JOIN OrderItem oi
    ON p.ProductID = oi.ProductID
WHERE oi.ProductID IS NULL;


-- 6. Product never reviewed
-- Review currently has no ProductID in our design,
-- so this specific rule cannot be checked with the current schema.


-- 7. Different order statuses
SELECT Status, COUNT(*) AS OrderCount
FROM [Order]
GROUP BY Status;


-- 8. All supported payment methods
SELECT PaymentMethod, COUNT(*) AS PaymentCount
FROM Payment
GROUP BY PaymentMethod;


-- 9. Different review ratings
SELECT Rating, COUNT(*) AS ReviewCount
FROM Review
GROUP BY Rating;


-- 10. Customer with more than one review
SELECT CustomerID, COUNT(*) AS ReviewCount
FROM Review
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- 11. Date range
SELECT 
    MIN(OrderDate) AS EarliestOrder,
    MAX(OrderDate) AS LatestOrder
FROM [Order];


-- 12. Payment amount range
SELECT 
    MIN(PaymentAmount) AS MinimumPayment,
    MAX(PaymentAmount) AS MaximumPayment
FROM Payment;