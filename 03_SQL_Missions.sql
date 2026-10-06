SELECT *
FROM Customer;

SELECT ProductName, CategoryID, SellingPrice
FROM Product;


SELECT *
FROM Product
WHERE SellingPrice > 5000;

SELECT MAX(SellingPrice) AS MaxPrice
FROM Product;

UPDATE Product
SET SellingPrice = 5500
WHERE ProductID = 50;


SELECT *
FROM Customer
ORDER BY JoinDate DESC;

SELECT COUNT(*) AS TotalCustomers
FROM Customer;

SELECT AVG(SellingPrice) AS AveragePrice
FROM Product;

SELECT 
    MAX(SellingPrice) AS MaxPrice,
    MIN(SellingPrice) AS MinPrice
FROM Product;

SELECT SUM(StockQuantity) AS TotalStock
FROM Product;

SELECT SUM(PaymentAmount) AS TotalPayments
FROM Payment;

SELECT Status, COUNT(*) AS OrderCount
FROM [Order]
GROUP BY Status;

SELECT PaymentMethod, SUM(PaymentAmount) AS TotalAmount
FROM Payment
GROUP BY PaymentMethod;

SELECT 
    OrderID,
    SUM(Quantity * UnitPrice) AS TotalOrderAmount
FROM OrderItem
GROUP BY OrderID;

SELECT 
    OrderID,
    SUM(Quantity * UnitPrice) AS TotalOrderAmount
FROM OrderItem
GROUP BY OrderID
HAVING SUM(Quantity * UnitPrice) > 5000;

SELECT 
    o.OrderID,
    c.FullName,
    o.OrderDate,
    o.Status
FROM [Order] o
JOIN Customer c
    ON o.CustomerID = c.CustomerID;

SELECT
    o.OrderID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice
FROM [Order] o
JOIN OrderItem oi
    ON o.OrderID = oi.OrderID
JOIN Product p
    ON oi.ProductID = p.ProductID;

SELECT
    c.CustomerID,
    c.FullName,
    SUM(p.PaymentAmount) AS TotalSpent
FROM Customer c
JOIN [Order] o
    ON c.CustomerID = o.CustomerID
JOIN Payment p
    ON o.OrderID = p.OrderID
GROUP BY
    c.CustomerID,
    c.FullName;

SELECT
    c.CustomerID,
    c.FullName,
    SUM(p.PaymentAmount) AS TotalSpent
FROM Customer c
JOIN [Order] o
    ON c.CustomerID = o.CustomerID
JOIN Payment p
    ON o.OrderID = p.OrderID
GROUP BY c.CustomerID, c.FullName;

***************************
SELECT *
FROM Customer c
WHERE EXISTS (
    SELECT 1
    FROM [Order] o
    WHERE o.CustomerID = c.CustomerID
);

SELECT *
FROM Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderItem oi
    WHERE oi.ProductID = p.ProductID
);

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(o.OrderID) AS OrderCount
FROM Customer c
LEFT JOIN [Order] o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FullName;

SELECT
    c.CustomerID,
    c.FullName,
    COUNT(o.OrderID) AS OrderCount
FROM Customer c
JOIN [Order] o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FullName
HAVING COUNT(o.OrderID) > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount
        FROM [Order]
        GROUP BY CustomerID
    ) AS CustomerOrders
);

SELECT
    ProductID,
    ProductName,
    SellingPrice
FROM Product
WHERE SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Product
);

SELECT
    c.CustomerID,
    c.FullName,
    SUM(p.PaymentAmount) AS TotalSpent
FROM Customer c
JOIN [Order] o
    ON c.CustomerID = o.CustomerID
JOIN Payment p
    ON o.OrderID = p.OrderID
GROUP BY
    c.CustomerID,
    c.FullName
HAVING SUM(p.PaymentAmount) > (
    SELECT AVG(TotalSpent)
    FROM (
        SELECT
            o.CustomerID,
            SUM(p.PaymentAmount) AS TotalSpent
        FROM [Order] o
        JOIN Payment p
            ON o.OrderID = p.OrderID
        GROUP BY o.CustomerID
    ) AS CustomerSpending
);


WITH MonthlyRevenue AS (
    SELECT
        YEAR(PaymentDate) AS PaymentYear,
        MONTH(PaymentDate) AS PaymentMonth,
        SUM(PaymentAmount) AS TotalRevenue
    FROM Payment
    GROUP BY
        YEAR(PaymentDate),
        MONTH(PaymentDate)
)
SELECT
    PaymentYear,
    PaymentMonth,
    TotalRevenue
FROM MonthlyRevenue
ORDER BY
    PaymentYear,
    PaymentMonth;

WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        c.FullName,
        SUM(p.PaymentAmount) AS TotalSpent
    FROM Customer c
    JOIN [Order] o
        ON c.CustomerID = o.CustomerID
    JOIN Payment p
        ON o.OrderID = p.OrderID
    GROUP BY
        c.CustomerID,
        c.FullName
)
SELECT
    CustomerID,
    FullName,
    TotalSpent
FROM CustomerSpending
WHERE TotalSpent > 10000
ORDER BY TotalSpent DESC;


SELECT
    c.CustomerID,
    c.FullName,
    SUM(p.PaymentAmount) AS TotalSpent,
    RANK() OVER (
        ORDER BY SUM(p.PaymentAmount) DESC
    ) AS SpendingRank
FROM Customer c
JOIN [Order] o
    ON c.CustomerID = o.CustomerID
JOIN Payment p
    ON o.OrderID = p.OrderID
GROUP BY
    c.CustomerID,
    c.FullName
ORDER BY SpendingRank;


SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.Quantity) DESC
    ) AS SalesRank
FROM Product p
JOIN OrderItem oi
    ON p.ProductID = oi.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY SalesRank;

SELECT
    PaymentID,
    PaymentDate,
    PaymentAmount,
    LAG(PaymentAmount) OVER (
        ORDER BY PaymentDate, PaymentID
    ) AS PreviousPaymentAmount
FROM Payment
ORDER BY PaymentDate, PaymentID;

SELECT
    PaymentID,
    PaymentDate,
    PaymentAmount,
    SUM(PaymentAmount) OVER (
        ORDER BY PaymentDate, PaymentID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Payment
ORDER BY PaymentDate, PaymentID;


CREATE VIEW vw_revenue_by_month AS
SELECT
    YEAR(PaymentDate) AS PaymentYear,
    MONTH(PaymentDate) AS PaymentMonth,
    SUM(PaymentAmount) AS TotalRevenue
FROM Payment
GROUP BY
    YEAR(PaymentDate),
    MONTH(PaymentDate);


SELECT *
FROM vw_revenue_by_month
ORDER BY PaymentYear, PaymentMonth;


CREATE VIEW vw_best_selling_products AS
SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM Product p
JOIN OrderItem oi
    ON p.ProductID = oi.ProductID
GROUP BY
    p.ProductID,
    p.ProductName;

SELECT *
FROM vw_best_selling_products
ORDER BY TotalQuantitySold DESC;


CREATE VIEW vw_customer_summary AS
SELECT
    c.CustomerID,
    c.FullName,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    COALESCE(SUM(p.PaymentAmount), 0) AS TotalSpent
FROM Customer c
LEFT JOIN [Order] o
    ON c.CustomerID = o.CustomerID
LEFT JOIN Payment p
    ON o.OrderID = p.OrderID
GROUP BY
    c.CustomerID,
    c.FullName;

SELECT *
FROM vw_customer_summary
ORDER BY CustomerID;


