create database shopkart;
use shopkart;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  gender VARCHAR(10),
  city VARCHAR(50),
  signup_date DATE
);

CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category_id INT,
  price DECIMAL(10,2),
  cost DECIMAL(10,2),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  city VARCHAR(50),
  order_status VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Step 3 insert data --

INSERT INTO customers VALUES
(1,'Rahul Sharma','Male','Delhi','2022-01-10'),
(2,'Priya Mehta','Female','Mumbai','2021-05-20'),
(3,'Amit Patel','Male','Ahmedabad','2023-02-14'),
(4,'Sneha Reddy','Female','Hyderabad','2022-11-01'),
(5,'Karan Verma','Male','Delhi','2020-08-18'),
(6,'Neha Nair','Female','Chennai','2021-09-09'),
(7,'Rohit Gupta','Male','Pune','2023-03-12'),
(8,'Anjali Singh','Female','Bangalore','2022-06-25');

INSERT INTO categories VALUES
(1,'Electronics'),
(2,'Fashion'),
(3,'Home Appliances');

INSERT INTO products VALUES
(101,'Laptop',1,80000,65000),
(102,'Mobile',1,30000,22000),
(103,'Headphones',1,2000,1200),
(104,'T-Shirt',2,800,300),
(105,'Jeans',2,2000,900),
(106,'Microwave',3,7000,5000),
(107,'Refrigerator',3,30000,24000),
(108,'Air Conditioner',3,45000,35000);

INSERT INTO orders VALUES
(1001,1,'2024-01-10','Delhi','Delivered'),
(1002,2,'2024-01-11','Mumbai','Delivered'),
(1003,3,'2024-01-12','Ahmedabad','Cancelled'),
(1004,4,'2024-01-13','Hyderabad','Delivered'),
(1005,5,'2024-01-15','Delhi','Delivered'),
(1006,6,'2024-01-16','Chennai','Pending'),
(1007,1,'2024-02-02','Delhi','Delivered'),
(1008,7,'2024-02-05','Pune','Delivered'),
(1009,8,'2024-02-08','Bangalore','Delivered'),
(1010,2,'2024-02-10','Mumbai','Cancelled');

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,103,2),
(3,1002,102,1),
(4,1003,104,3),
(5,1004,106,1),
(6,1005,105,2),
(7,1005,104,1),
(8,1006,102,1),
(9,1007,108,1),
(10,1008,103,3),
(11,1009,107,1),
(12,1010,104,2);

-- Step 4 Questions--

select * from customers where city ='Delhi';
select * from orders order by order_date desc limit 5;

select * from products order by price desc limit 3;

-- Level 2 --
-- total orders --
select count(*) as total_orders from orders;

-- Q5 Quantity sold per product --
select  product_id , sum(quantity) as total_quantity 
from order_items 
group by product_id;

-- Q6 Cities with More Than 2 Orders --
select city , count(*) as total_orders
from orders
group by city 
having count(*) > 2;

-- Level 3 - joins queries--
-- Q7 Customer Name with Order ID --
SELECT c.customer_name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Q8 Product Name in Each Order --
SELECT o.order_id, p.product_name
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Q9 Total Quantity Per Customer --
SELECT c.customer_name, SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name;

-- Level 4 Profit Analysis --
-- Q10 Profit Per Product --
SELECT product_name, (price - cost) AS profit_per_unit
FROM products;

-- Q11 Category-wise Total Profit --
SELECT c.category_name,
SUM((p.price - p.cost) * oi.quantity) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- LEVEL 5 — CUSTOMER ANALYSIS --
-- Q12 Customers with More Than 1 Order --
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- Q13 Customers Above Average Purchase Quantity --
SELECT c.customer_name, SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
HAVING SUM(oi.quantity) >
(
    SELECT AVG(quantity) FROM order_items
);

-- LEVEL 6 — BUSINESS INSIGHTS -- 
-- Q14 City with Highest Revenue --
SELECT o.city,
SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.city
ORDER BY revenue DESC;

-- Q15 Most Profitable Product --
SELECT p.product_name,
SUM((p.price - p.cost) * oi.quantity) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;

-- Q16 Monthly Order Trend --
SELECT MONTH(order_date) AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY MONTH(order_date);

-- FINAL CAPSTONE (VERY IMPORTANT) -- 
-- top 3 customers--
SELECT c.customer_name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 3;

-- Revenue Per City -- 
SELECT o.city, SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.city;

-- Profit Per Category -- 
SELECT c.category_name,
SUM((p.price - p.cost) * oi.quantity) AS profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Repeat Customer Count --
SELECT COUNT(*) FROM
(
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
) AS repeat_customers;

-- Cancelled Order % --
SELECT 
(COUNT(CASE WHEN order_status='Cancelled' THEN 1 END)*100.0 / COUNT(*)) 
AS cancel_percentage
FROM orders;