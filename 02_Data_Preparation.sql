USE NovaCart;

SELECT COUNT(*) AS ProductsNeverOrdered
FROM Product
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM OrderItem
);

SELECT ProductID, ProductName
FROM Product
WHERE ProductID = 50;

SELECT *
FROM OrderItem
WHERE ProductID = 50;

SELECT 
    OrderID,
    COUNT(*) AS ProductCount
FROM OrderItem
WHERE OrderID IN (
    SELECT OrderID
    FROM OrderItem
    WHERE ProductID = 50
)
GROUP BY OrderID
ORDER BY ProductCount;

DELETE FROM OrderItem
WHERE ProductID = 50;

SELECT COUNT(*) AS ProductsNeverOrdered
FROM Product
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM OrderItem
);

SELECT COUNT(*) AS ProductsNeverOrdered
FROM Product
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM OrderItem
);

SELECT Status, COUNT(*) AS OrderCount
FROM [Order]
GROUP BY Status;

SELECT PaymentMethod, COUNT(*) AS PaymentCount
FROM Payment
GROUP BY PaymentMethod;

SELECT Rating, COUNT(*) AS ReviewCount
FROM Review
GROUP BY Rating
ORDER BY Rating;

SELECT CustomerID, COUNT(*) AS ReviewCount
FROM Review
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT 
    MIN(OrderDate) AS EarliestOrder,
    MAX(OrderDate) AS LatestOrder
FROM [Order];

SELECT 
    MIN(PaymentAmount) AS MinimumPayment,
    MAX(PaymentAmount) AS MaximumPayment
FROM Payment;