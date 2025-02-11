CREATE DATABASE SHOP
GO
USE SHOP

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerID, FirstName, LastName, Email) 
VALUES (1, N'Rustam', N'Farzaliyev', 'asd@gmail.com');

UPDATE Customers SET Email = 'dfgdfg@hotmail.com' WHERE CustomerID = 1;

DELETE FROM Customers WHERE CustomerID = 5;

SELECT * FROM Customers ORDER BY LastName;

INSERT INTO Customers (CustomerID, FirstName, LastName, Email) VALUES 
(2, N'Huseyn', N'Ismayilov', 'huseyn@gmail.com'),
(3, N'Ramin', N'Mamedov', 'ramin@gmail.com');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) 
VALUES (1, 1, '2025-01-15', 250.00);

UPDATE Orders SET TotalAmount = 300.00 WHERE OrderID = 1;

DELETE FROM Orders WHERE OrderID = 3;

SELECT * FROM Orders WHERE CustomerID = 1;

SELECT * FROM Orders WHERE YEAR(OrderDate) = 2025;

INSERT INTO Products (ProductID, ProductName, Price) 
VALUES (1, N'PersonalPC', 900.00);

UPDATE Products SET Price = 1100.00 WHERE ProductID = 1;

DELETE FROM Products WHERE ProductID = 4;

SELECT * FROM Products WHERE Price > 100;

SELECT * FROM Products WHERE Price <= 50;


INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) 
VALUES (1, 1, 1, 2, 1800.00);

UPDATE OrderDetails SET Quantity = 3 WHERE OrderDetailID = 1;


DELETE FROM OrderDetails WHERE OrderDetailID = 2;

SELECT * FROM OrderDetails WHERE OrderID = 1;


SELECT * FROM OrderDetails WHERE ProductID = 1;

SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate, o.TotalAmount 
FROM Orders o 
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT c.FirstName, c.LastName, p.ProductName, od.Quantity 
FROM OrderDetails od 
INNER JOIN Orders o ON od.OrderID = o.OrderID 
INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
INNER JOIN Products p ON od.ProductID = p.ProductID;

SELECT o.*, c.* 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

SELECT o.OrderID, p.ProductName 
FROM Orders o 
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID 
INNER JOIN Products p ON od.ProductID = p.ProductID;

SELECT o.*, c.* 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

SELECT p.ProductName, o.OrderID 
FROM Products p 
RIGHT JOIN OrderDetails od ON p.ProductID = od.ProductID 
RIGHT JOIN Orders o ON od.OrderID = o.OrderID;

SELECT o.OrderID, p.ProductName 
FROM Orders o 
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID 
INNER JOIN Products p ON od.ProductID = p.ProductID;

SELECT c.FirstName, c.LastName, o.OrderID, p.ProductName, od.Price 
FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID 
INNER JOIN Products p ON od.ProductID = p.ProductID;

SELECT FirstName, LastName 
FROM Customers 
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE TotalAmount > 500);

SELECT ProductName FROM Products 
WHERE ProductID IN (SELECT ProductID FROM OrderDetails WHERE Quantity > 10);

SELECT CustomerID, (SELECT SUM(TotalAmount) FROM Orders WHERE Orders.CustomerID = c.CustomerID) AS TotalSpent 
FROM Customers c;

SELECT * FROM Products 
WHERE Price > (SELECT AVG(Price) FROM Products);

SELECT c.FirstName, c.LastName, o.OrderID, p.ProductName, od.Quantity, od.Price 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID;

SELECT c.FirstName, c.LastName, o.OrderID, p.ProductName, od.Quantity, od.Price 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID = p.ProductID;

SELECT c.FirstName, c.LastName, SUM(od.Quantity * od.Price) AS TotalSpent 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
GROUP BY c.CustomerID;

SELECT OrderID 
FROM Orders 
WHERE OrderID IN (SELECT OrderID FROM OrderDetails GROUP BY OrderID HAVING SUM(Quantity * Price) > 1000);

SELECT FirstName, LastName 
FROM Customers 
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders));

SELECT CustomerID, COUNT(OrderID)
FROM Orders 
GROUP BY CustomerID;

SELECT ProductID, SUM(Quantity) 
FROM OrderDetails 
GROUP BY ProductID HAVING SUM(Quantity) > 3;

SELECT o.OrderID, c.FirstName, c.LastName, SUM(od.Quantity) AS TotalProducts 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
GROUP BY o.OrderID, c.FirstName, c.LastName;