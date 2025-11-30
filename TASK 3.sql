
-- CREATING TABLE 
CREATE TABLE Customers (
    CUSTOMER_ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    PHONE VARCHAR(15),
    ADDRESS VARCHAR(255)
);

CREATE TABLE Products (
    PRODUCT_ID INT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10, 2) NOT NULL CHECK (PRICE >= 0),
    STOCK INT NOT NULL CHECK (STOCK >= 0)
);

CREATE TABLE Orders (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    ORDER_DATE DATE NOT NULL,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);

  
DESC Customers;
DESC Products;
DESC Orders;
  
  
 INSERT INTO Customers VALUES
(101, 'Aarav Sharma', 'aarav.s@shop.com', '9876543210', 'Mumbai'),
(102, 'Diya Verma', 'diya.v@shop.com', '9876543211', 'Delhi'),
(103, 'Rohan Patel', 'rohan.p@shop.com', '9876543212', 'Bangalore'),
(104, 'Zoya Khan', 'zoya.k@shop.com', '9876543213', 'Chennai'),
(105, 'Vikram Singh', 'vikram.s@shop.com', '9876543214', 'Hyderabad'),
(106, 'Priya Das', 'priya.d@shop.com', '9876543215', 'Kolkata'),
(107, 'Kabir Reddy', 'kabir.r@shop.com', '9876543216', 'Pune'),
(108, 'Neha Gupta', 'neha.g@shop.com', '9876543217', 'Ahmedabad'),
(109, 'Sameer Jain', 'sameer.j@shop.com', '9876543218', 'Jaipur'),
(110, 'Leena Rao', 'leena.r@shop.com', '9876543219', 'Lucknow');

SELECT * FROM Customers;

INSERT INTO Products VALUES
(201, 'Smartwatch X', 'Electronics', 499.00, 15),
(202, 'Leather Wallet', 'Accessories', 35.00, 50),
(203, 'High-End Laptop', 'Electronics', 1800.00, 0),
(204, 'Organic Coffee Beans', 'Food & Drink', 15.00, 120),
(205, 'Fiction Novel', 'Books', 12.00, 30),
(206, 'Dumbbells Set', 'Fitness', 150.00, 5),
(207, 'Bluetooth Speaker', 'Electronics', 89.00, 25),
(208, 'Running Shoes', 'Apparel', 90.00, 40),
(209, 'Noise-Cancelling Headphones', 'Electronics', 250.00, 0),
(210, 'Yoga Mat', 'Fitness', 25.00, 75);

SELECT * FROM Products;

INSERT INTO Orders VALUES
(3001, 101, 201, 1, '2025-05-01'),
(3002, 102, 204, 5, '2025-11-25'),
(3003, 103, 205, 2, '2025-11-28'),
(3004, 101, 207, 1, '2025-11-27'),
(3005, 102, 202, 1, '2025-11-20'),
(3006, 104, 206, 1, '2025-10-15'),
(3007, 105, 208, 2, '2025-11-10'),
(3008, 101, 204, 3, '2025-11-18'),
(3009, 103, 210, 1, '2025-11-12'),
(3010, 106, 201, 1, '2025-11-22'),
(3011, 102, 206, 1, '2025-11-15'),
(3012, 107, 202, 2, '2025-11-29'),
(3013, 105, 207, 1, '2025-11-26'),
(3014, 109, 208, 1, '2025-10-05'),
(3015, 110, 201, 1, '2025-11-01');

SELECT * FROM Orders;




SELECT
    C.NAME,
    O.ORDER_ID,
    P.PRODUCT_NAME,
    O.QUANTITY,
    O.ORDER_DATE
FROM
    Orders O
JOIN
    Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID
WHERE
    C.CUSTOMER_ID = 101
ORDER BY
    O.ORDER_DATE DESC;
    
    

SELECT
    PRODUCT_NAME,
    CATEGORY,
    PRICE
FROM
    Products
WHERE
    STOCK = 0;
    
    
    
    
SELECT
    P.PRODUCT_NAME,
    P.CATEGORY,
    SUM(O.QUANTITY * P.PRICE) AS TotalRevenue
FROM
    Orders O
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
    P.PRODUCT_NAME, P.CATEGORY
ORDER BY
    TotalRevenue DESC;
    
    
    
    
SELECT
    C.NAME,
    C.EMAIL,
    ROUND(SUM(O.QUANTITY * P.PRICE), 2) AS TotalPurchaseAmount
FROM
    Orders O
JOIN
    Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
    C.CUSTOMER_ID, C.NAME, C.EMAIL
ORDER BY
    TotalPurchaseAmount DESC
LIMIT 5;




SELECT
    C.NAME,
    COUNT(DISTINCT P.CATEGORY) AS DistinctCategories
FROM
    Orders O
JOIN
    Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
    C.CUSTOMER_ID, C.NAME
HAVING
    COUNT(DISTINCT P.CATEGORY) >= 2
ORDER BY
    DistinctCategories DESC;
    
    
    
  
   
  -- Analytics:
   
   
SELECT
    DATE_FORMAT(O.ORDER_DATE, '%Y-%m') AS SalesMonth,
    ROUND(SUM(O.QUANTITY * P.PRICE), 2) AS TotalMonthlyRevenue
FROM
    Orders O
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
    SalesMonth
ORDER BY
    TotalMonthlyRevenue DESC
LIMIT 1;



SELECT
    P.PRODUCT_NAME,
    P.CATEGORY
FROM
    Products P
LEFT JOIN
    Orders O ON P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY
    P.PRODUCT_ID, P.PRODUCT_NAME, P.CATEGORY
HAVING
    MAX(O.ORDER_DATE) < DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
    OR MAX(O.ORDER_DATE) IS NULL;
    
    
SELECT
    C.CUSTOMER_ID,
    C.NAME,
    C.EMAIL
FROM
    Customers C
LEFT JOIN
    Orders O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE
    O.ORDER_ID IS NULL;



SELECT
    ROUND(AVG(O.QUANTITY * P.PRICE), 2) AS AverageOrderValue
FROM
    Orders O
JOIN
    Products P ON O.PRODUCT_ID = P.PRODUCT_ID; 
    