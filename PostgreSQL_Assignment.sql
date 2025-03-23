-- DATABASE SETUP

CREATE DATABASE bookstore_db;

---------- TABLE CREATIONS ----------

--  "books" TABLE
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL CHECK (price >= 0),
    stock INT CHECK (stock >= 0),
    published_year INT
);

-- "customers" TABLE
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- "orders" TABLE
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    book_id INT REFERENCES books(id),
    quantity INT CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



---------- INSERT DATA ----------

-- INSERT DATA INTO "books" 
INSERT INTO books (title, author, price, stock, published_year)
VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

SELECT * FROM books;

-- INSERT DATA INTO "customers" 
INSERT INTO customers (name, email, joined_date)
VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20');

SELECT * FROM customers;


-- INSERT DATA INTO "orders"
INSERT INTO orders (customer_id, book_id, quantity, order_date)
VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');

SELECT * FROM orders;


---------- QUERIES ----------
-- QUERY 1 STARTS --
    -- FIND BOOKS THAT ARE OUT OF STOCK.
    SELECT title FROM books
        WHERE stock = 0;
-- QUERY 1 ENDS --

-- QUERY 2 STARTS --
    -- RETRIEVE THE MOST EXPENSIVE BOOK IN THE STORE.
    SELECT * FROM books
        ORDER BY price DESC
        LIMIT 1;
-- QUERY 2 ENDS --

-- QUERY 3 STARTS --
    -- FIND THE TOTAL NUMBER OF ORDERS PLACED BY EACH CUSTOMER.
    SELECT c.name, COUNT(o.id) AS total_orders FROM customers c
        JOIN orders o ON c.id = o.customer_id
        GROUP BY c.name;
-- QUERY 3 ENDS --

-- QUERY 4 STARTS --
    -- CALCULATE THE TOTAL REVENUE GENERATED FROM BOOK SALES.
        SELECT SUM(b.price * o.quantity) AS total_revenue FROM orders o
            JOIN books b ON o.book_id = b.id;
-- QUERY 4 ENDS --

-- QUERY 5 STARTS --
    -- LIST ALL CUSTOMERS WHO HAVE PLACED MORE THAN ONE ORDER.
    SELECT c.name, COUNT(o.id) AS orders_count FROM customers c
        JOIN orders o ON c.id = o.customer_id GROUP BY c.id, c.name
        HAVING COUNT(o.id) > 1;
-- QUERY 5 ENDS ---

-- QUERY 6 STARTS --
    -- FIND THE AVERAGE PRICE OF BOOKS IN THE STORE.
    SELECT ROUND(AVG(price), 2) AS avg_book_price FROM books;
-- QUERY 6 ENDS ---

-- QUERY 7 STARTS --
    -- INCREASE THE PRICE OF ALL BOOKS PUBLISHED BEFORE 2000 BY 10%.
    UPDATE books
        SET price = price * 1.10 
        WHERE published_year < 2000;
-- QUERY 7 ENDS ---

-- QUERY 8 STARTS --
    -- DELETE CUSTOMERS WHO HAVEN'T PLACED ANY ORDERS.
    DELETE FROM customers
        WHERE id NOT IN 
            (SELECT DISTINCT customer_id FROM orders);
-- QUERY 8 ENDS ---


-- DROPPED AND CREATED AGAIN AFTER DELETE COMMAND
    -- DROP TABLE books;
    -- DROP TABLE customers;
    -- DROP TABLE orders;
