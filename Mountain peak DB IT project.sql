-- Create categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);

-- Create suppliers table
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    lead_time_days INTEGER NOT NULL
);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id),
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    price NUMERIC(10, 2) NOT NULL,
    cost NUMERIC(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL
);

-- Create stores table
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    size_sqft INTEGER NOT NULL,
    opening_date DATE NOT NULL
);

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES stores(store_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    manager_id INTEGER REFERENCES employees(employee_id)
);

-- Create customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE NOT NULL,
    loyalty_tier VARCHAR(20) NOT NULL
);

-- Create sales table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES stores(store_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    customer_id INTEGER REFERENCES customers(customer_id),
    sale_date TIMESTAMP NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL
);

-- Create sale_items table
CREATE TABLE sale_items (
    sale_item_id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(sale_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    price_sold NUMERIC(10, 2) NOT NULL
);

-- Create product_reviews table
CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    customer_id INTEGER REFERENCES customers(customer_id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5) NOT NULL,
    review_date DATE NOT NULL,
    review_text TEXT
);



-- Insert data into categories
INSERT INTO categories (category_id, category_name, department) VALUES
(1, 'Hiking Boots', 'Footwear'),
(2, 'Tents', 'Camping'),
(3, 'Backpacks', 'Gear'),
(4, 'Jackets', 'Clothing'),
(5, 'Sleeping Bags', 'Camping'),
(6, 'Water Bottles', 'Accessories'),
(7, 'Hiking Poles', 'Gear'),
(8, 'Camp Stoves', 'Camping'),
(9, 'GPS Devices', 'Electronics'),
(10, 'Empty Category', 'Test Department'); -- Category with no products (childless parent)

-- Insert data into suppliers
INSERT INTO suppliers (supplier_id, supplier_name, country, lead_time_days) VALUES
(1, 'OutdoorGear Inc.', 'USA', 5),
(2, 'Summit Supplies', 'Canada', 10),
(3, 'Alpine Equipment', 'Switzerland', 15),
(4, 'Wilderness Outfitters', 'USA', 7),
(5, 'Pacific Adventure Gear', 'Japan', 20),
(6, 'Nordic Outdoors', 'Sweden', 12),
(7, 'Rocky Mountain Supply', 'Canada', 8),
(8, 'Desert Trek Gear', 'Australia', 25),
(9, 'Forest Path Co.', 'USA', 6),
(10, 'Empty Supplier', 'Unknown', 30); -- Supplier with no products (childless parent)

-- Insert data into products
INSERT INTO products (product_id, product_name, category_id, supplier_id, price, cost, stock_quantity) VALUES
(1, 'TrailMaster Hiking Boot', 1, 1, 149.99, 70.00, 45),
(2, 'Expedition 3-Person Tent', 2, 3, 299.99, 150.00, 20),
(3, 'Wilderness 65L Backpack', 3, 2, 189.99, 90.00, 30),
(4, 'Alpine Waterproof Jacket', 4, 5, 199.99, 85.00, 40),
(5, 'Summit Sleeping Bag', 5, 6, 129.99, 60.00, 25),
(6, 'EcoTrek Water Bottle', 6, 9, 24.99, 5.00, 100),
(7, 'TrailSupport Hiking Poles', 7, 7, 79.99, 30.00, 35),
(8, 'Campfire Portable Stove', 8, 4, 149.99, 70.00, 15),
(9, 'NavPro GPS Device', 9, 8, 249.99, 120.00, 10),
(10, 'Trailblazer Hiking Boot', 1, 2, 159.99, 75.00, 0), -- Out of stock product
(11, 'Mountain Explorer Jacket', 4, 3, 229.99, 100.00, 22),
(12, 'Pathfinder 55L Backpack', 3, 1, 169.99, 80.00, 18),
(13, 'Everest Tent 4-Person', 2, 6, 349.99, 180.00, 8),
(14, 'Basecamp Sleeping Bag', 5, 7, 119.99, 55.00, 32),
(15, 'Adventure Water Bottle', 6, 4, 29.99, 6.00, 75),
(16, 'Orphan Product', NULL, NULL, 99.99, 40.00, 5); -- Product with no category and no supplier (orphan)

-- Insert data into stores
INSERT INTO stores (store_id, store_name, region, size_sqft, opening_date) VALUES
(1, 'Mountain Peak Denver', 'West', 5000, '2015-03-15'),
(2, 'Mountain Peak Seattle', 'West', 4500, '2016-05-20'),
(3, 'Mountain Peak Boston', 'East', 4800, '2017-07-10'),
(4, 'Mountain Peak Miami', 'South', 4200, '2018-02-25'),
(5, 'Mountain Peak Chicago', 'Midwest', 5500, '2018-09-12'),
(6, 'Mountain Peak Portland', 'West', 4300, '2019-04-05'),
(7, 'Mountain Peak Austin', 'South', 4700, '2020-01-18'),
(8, 'Mountain Peak Nashville', 'South', 4100, '2021-08-30'),
(9, 'Mountain Peak Minneapolis', 'Midwest', 4900, '2022-06-15'),
(10, 'Empty Store', 'North', 3000, '2023-01-01'); -- Store with no employees and no sales (childless parent)

-- Insert data into employees (note: manager_id will be updated after all employees are inserted)
INSERT INTO employees (employee_id, store_id, first_name, last_name, position, hire_date, salary, manager_id) VALUES
(1, 1, 'John', 'Smith', 'Store Manager', '2015-03-15', 75000.00, NULL),
(2, 1, 'Emily', 'Johnson', 'Assistant Manager', '2015-04-20', 55000.00, NULL),
(3, 1, 'Michael', 'Brown', 'Sales Associate', '2015-05-10', 35000.00, NULL),
(4, 1, 'Jessica', 'Davis', 'Sales Associate', '2016-03-05', 35000.00, NULL),
(5, 2, 'David', 'Wilson', 'Store Manager', '2016-05-20', 72000.00, NULL),
(6, 2, 'Sarah', 'Miller', 'Assistant Manager', '2016-06-15', 53000.00, NULL),
(7, 2, 'Robert', 'Taylor', 'Sales Associate', '2016-07-10', 34000.00, NULL),
(8, 3, 'Jennifer', 'Anderson', 'Store Manager', '2017-07-10', 73000.00, NULL),
(9, 3, 'Daniel', 'Thomas', 'Assistant Manager', '2017-08-05', 54000.00, NULL),
(10, 3, 'Laura', 'Jackson', 'Sales Associate', '2017-09-20', 34500.00, NULL),
(11, 4, 'William', 'White', 'Store Manager', '2018-02-25', 71000.00, NULL),
(12, 4, 'Elizabeth', 'Harris', 'Assistant Manager', '2018-03-15', 52000.00, NULL),
(13, 5, 'James', 'Martin', 'Store Manager', '2018-09-12', 74000.00, NULL),
(14, 5, 'Patricia', 'Thompson', 'Assistant Manager', '2018-10-05', 54500.00, NULL),
(15, 5, 'Richard', 'Garcia', 'Sales Associate', '2018-11-15', 35500.00, NULL),
(16, NULL, 'Orphan', 'Employee', 'Unassigned', '2022-12-01', 40000.00, NULL); -- Employee not assigned to any store (orphan)

-- Update manager_id to create hierarchy
UPDATE employees SET manager_id = 1 WHERE employee_id IN (2, 3, 4);
UPDATE employees SET manager_id = 5 WHERE employee_id IN (6, 7);
UPDATE employees SET manager_id = 8 WHERE employee_id IN (9, 10);
UPDATE employees SET manager_id = 11 WHERE employee_id = 12;
UPDATE employees SET manager_id = 13 WHERE employee_id IN (14, 15);

-- Insert data into customers
INSERT INTO customers (customer_id, first_name, last_name, email, join_date, loyalty_tier) VALUES
(1, 'Alex', 'Roberts', 'alex.roberts@email.com', '2018-04-10', 'Gold'),
(2, 'Olivia', 'Clark', 'olivia.clark@email.com', '2018-07-22', 'Silver'),
(3, 'Benjamin', 'Lewis', 'benjamin.lewis@email.com', '2019-01-15', 'Bronze'),
(4, 'Sophia', 'Walker', 'sophia.walker@email.com', '2019-05-30', 'Gold'),
(5, 'Ethan', 'Hall', 'ethan.hall@email.com', '2020-02-12', 'Silver'),
(6, 'Emma', 'Young', 'emma.young@email.com', '2020-06-25', 'Bronze'),
(7, 'Jacob', 'Allen', 'jacob.allen@email.com', '2020-11-08', 'Gold'),
(8, 'Ava', 'King', 'ava.king@email.com', '2021-03-17', 'Silver'),
(9, 'Matthew', 'Wright', 'matthew.wright@email.com', '2021-09-02', 'Bronze'),
(10, 'Charlotte', 'Scott', 'charlotte.scott@email.com', '2022-01-20', 'None'),
(11, 'Non-purchasing', 'Customer', 'nonpurchasing@email.com', '2023-05-15', 'None'); -- Customer with no purchases (childless parent)

-- Insert data into sales
INSERT INTO sales (sale_id, store_id, employee_id, customer_id, sale_date, total_amount) VALUES
(1, 1, 3, 1, '2023-01-05 10:23:45', 479.97),
(2, 1, 4, 2, '2023-01-10 14:30:22', 329.98),
(3, 2, 7, 3, '2023-01-15 11:45:30', 254.98),
(4, 3, 10, 4, '2023-01-20 15:10:55', 549.97),
(5, 4, 12, 5, '2023-02-02 09:20:15', 199.99),
(6, 5, 15, 6, '2023-02-10 13:05:40', 374.98),
(7, 1, 3, 7, '2023-02-15 16:45:10', 174.98),
(8, 2, 7, 8, '2023-02-25 10:30:25', 599.98),
(9, 3, 10, 9, '2023-03-05 12:15:35', 129.99),
(10, 4, 12, 1, '2023-03-15 14:25:50', 229.99),
(11, 5, 14, 2, '2023-03-20 17:40:05', 399.98),
(12, 1, 2, 3, '2023-04-01 09:55:20', 249.99),
(13, 2, 6, 4, '2023-04-10 11:30:45', 349.98),
(14, 3, 9, 5, '2023-04-20 15:20:30', 154.98),
(15, 4, 11, 6, '2023-05-01 13:10:15', 499.99),
(16, 5, 13, 7, '2023-05-10 16:35:40', 279.98),
(17, 1, 4, 8, '2023-05-15 10:45:55', 389.97),
(18, 2, 5, 9, '2023-05-20 14:15:25', 179.99),
(19, 3, 8, 10, '2023-05-25 17:30:10', 399.98),
(20, 6, NULL, 1, '2023-06-01 11:20:35', 299.99); -- Sale at store 6 with no employee (orphan for employee)

-- Insert data into sale_items
INSERT INTO sale_items (sale_item_id, sale_id, product_id, quantity, price_sold) VALUES
(1, 1, 1, 1, 149.99),
(2, 1, 3, 1, 189.99),
(3, 1, 6, 1, 24.99),
(4, 2, 4, 1, 199.99),
(5, 2, 7, 1, 79.99),
(6, 3, 5, 1, 129.99),
(7, 3, 6, 5, 24.99),
(8, 4, 2, 1, 299.99),
(9, 4, 9, 1, 249.99),
(10, 5, 4, 1, 199.99),
(11, 6, 8, 1, 149.99),
(12, 6, 12, 1, 169.99),
(13, 7, 7, 1, 79.99),
(14, 7, 15, 1, 29.99),
(15, 8, 2, 1, 299.99),
(16, 8, 13, 1, 349.99),
(17, 9, 5, 1, 129.99),
(18, 10, 11, 1, 229.99),
(19, 11, 13, 1, 349.99),
(20, 11, 6, 2, 24.99),
(21, 12, 9, 1, 249.99),
(22, 13, 10, 1, 159.99),
(23, 13, 14, 1, 119.99),
(24, 14, 6, 1, 24.99),
(25, 14, 15, 1, 29.99),
(26, 15, 2, 1, 299.99),
(27, 15, 9, 1, 249.99),
(28, 16, 11, 1, 229.99),
(29, 17, 1, 1, 149.99),
(30, 17, 3, 1, 189.99),
(31, 17, 6, 2, 24.99),
(32, 18, 7, 1, 79.99),
(33, 19, 4, 1, 199.99),
(34, 19, 8, 1, 149.99),
(35, 20, 2, 1, 299.99),
(36, NULL, 16, 1, 99.99); -- Orphan sale_item not connected to any sale

-- Insert data into product_reviews
INSERT INTO product_reviews (review_id, product_id, customer_id, rating, review_date, review_text) VALUES
(1, 1, 1, 5, '2023-01-10', 'Best hiking boots I have ever owned!'),
(2, 2, 4, 4, '2023-01-25', 'Great tent, easy to set up, spacious.'),
(3, 3, 2, 3, '2023-01-15', 'Decent backpack but could use more pockets.'),
(4, 4, 5, 5, '2023-02-05', 'Excellent jacket, kept me dry during heavy rain.'),
(5, 5, 3, 4, '2023-02-20', 'Warm and comfortable sleeping bag.'),
(6, 6, 8, 5, '2023-03-01', 'Love this water bottle, keeps drinks cold for hours.'),
(7, 7, 6, 2, '2023-03-25', 'Hiking poles bent after a few uses.'),
(8, 8, 9, 4, '2023-04-05', 'Great portable stove, heats up quickly.'),
(9, 9, 7, 5, '2023-04-15', 'Excellent GPS device, very accurate.'),
(10, 10, 10, 3, '2023-04-30', 'Comfortable but not very durable.'),
(11, 11, 1, 4, '2023-05-05', 'Good quality jacket, fits well.'),
(12, 12, 2, 5, '2023-05-15', 'Perfect size backpack for weekend trips.'),
(13, 13, 3, 4, '2023-05-25', 'Spacious tent, but a bit heavy to carry.'),
(14, 14, 4, 3, '2023-06-05', 'Decent sleeping bag for the price.'),
(15, 15, 5, 5, '2023-06-15', 'Great water bottle design, no leaks!'),
(16, 1, 6, 4, '2023-06-20', 'Very comfortable boots, good ankle support.'),
(17, 2, 7, 5, '2023-06-25', 'Used this tent in heavy rain, stayed completely dry.'),
(18, 3, 8, 2, '2023-06-30', 'Shoulder strap broke after a few months.'),
(19, 4, 9, 4, '2023-07-05', 'Great jacket for cold weather hiking.'),
(20, 5, 10, 5, '2023-07-10', 'Extremely comfortable sleeping bag for camping.'),
(21, NULL, 1, 1, '2023-07-15', 'Product was missing parts!'); -- Orphan review for a product that doesn't exist



--Inventory Manage pfgment
-- 1. Which products have less than 20 items in stock? Sort the results by stock quantity in ascending order.
SELECT
     Product_id, product_name, stock_quantity
FROM
    products
WHERE 
     stock_quantity < 20
ORDER BY 
       stock_quantity ASC;

--2. What products are currently out of stock (stock_quantity = 0)?
SELECT 
     product_id, product_name, stock_quantity
FROM 
   products
WHERE
    stock_quantity=0;
	
--3. Calculate the profit margin percentage for each product. Which products have the highest profit margins?
SELECT 
     product_id,product_name,
	 price,cost,Round(((price - cost)/price)*100,2)
	 AS profit_margin_pct
FROM 
   products
ORDER BY 
       profit_margin_pct DESC;
	   
--4. Find all products that have no assigned category or supplier.
SELECT 
     product_id, product_name,
	 category_id, supplier_id
FROM 
   products
WHERE 
    category_id IS NULL AND supplier_id is NULL; 
	
--5. List all products along with their category name and supplier name. Include products that don't have a category or supplier assigned.
SELECT p.product_id,
       p.product_name,
	   c.category_name,
	   s.supplier_name
FROM
    products p
LEFT JOIN 
         categories c on p.category_id= c.category_id
LEFT JOIN 
        suppliers s on p.supplier_id= s.supplier_id
ORDER BY 
       p.product_id;


--Sales Analysis
--6. What is the total sales amount for each store? Show the store name, region, and total sales.
SELECT st.store_id,
       st.store_name,
	   st.region,
	   COALESCE(SUM(s.total_amount),0)AS total_sales
FROM
   stores st
LEFT JOIN
        sales s ON st.store_id=s.store_id
GROUP BY
       st.store_id,
	   st.store_name,
	   st.region
ORDER BY
       total_sales DESC;

--7. Calculate the total sales amount for each month of 2023, along with the count of transactions for that month.
SELECT DATE_TRUNC('month', sale_date) AS month,
       COUNT(sale_id) AS transaction_count,
	   SUM(total_amount) AS total_sales
FROM
   sales
WHERE
    sale_date>= '2023-01-01' AND sale_date< '2024-01-01'
GROUP BY 
       DATE_TRUNC('month', sale_date)
ORDER BY 
       month;
	   
--8. Which product categories generate the most revenue? Rank categories by total sales amount.
SELECT c.category_id,
       c.category_name,
	   COALESCE(SUM(si.quantity * si.price_sold),0) AS total_revenue,
	   RANK() OVER (ORDER BY COALESCE(SUM(si.quantity * si.price_sold), 0)DESC)AS revenue_rank
FROM
    categories c
LEFT JOIN 
        products p on c.category_id= p.category_id
LEFT JOIN 
        sale_items si on p.product_id= si.product_id
GROUP BY
       c.category_id, c.category_name
ORDER BY 
       revenue_rank;
	   
--9. Identify the top 5 most frequently purchased products along with their total quantity sold.
SELECT p.product_id,
       p.product_name,
	   SUM(si.quantity) AS total_quantity_sold
FROM
    sale_items si
JOIN 
   products p on si.product_id= p.product_id
GROUP BY
       p.product_id, p.product_name
ORDER BY 
       total_quantity_sold DESC;

--10. For each customer, list their name, email, number of purchases, and the date of their most recent purchase.
SELECT c.customer_id,
       c.first_name ||' '|| c.last_name AS customer_name,
	   c.email,
	   COUNT(s.sale_id) AS total_purchases,
	   MAX(s.sale_date) AS most_recent_purchase
FROM
    customers c
LEFT JOIN 
        sales s on c.customer_id= s.customer_id
GROUP BY
       c.customer_id, customer_name, c.email
ORDER BY 
       c.customer_id;

--Customer Insights
--11. Calculate the total amount spent by each customer. Sort by total spend in descending order.
SELECT c.customer_id,
       c.first_name ||' '|| c.last_name AS customer_name,
	   COALESCE(SUM(s.total_amount),0) AS total_spent
FROM
   customers c
LEFT JOIN 
        sales s on c.customer_id= s.customer_id
GROUP BY
       c.customer_id, customer_name
ORDER BY 
       total_spent DESC;

--12. Find the average rating given by customers in each loyalty tier. Does loyalty tier correlate with how customers rate products?
SELECT c.loyalty_tier,
       ROUND(AVG(pr.rating),2)AS average_rating,
	   COUNT(pr.review_id) AS total_reviews
FROM
   customers c
JOIN 
   product_reviews pr on c.customer_id= pr.customer_id
GROUP BY
       c.loyalty_tier
ORDER BY 
       average_rating DESC;
	   
--13. Identify customers who have made purchases but have never left a product review.
SELECT DISTINCT c.customer_id,
                c.first_name ||' '|| c.last_name AS customer_name,
	            c.email
FROM
   customers c
JOIN 
   sales s on c.customer_id= s.customer_id
LEFT JOIN
        product_reviews pr on c.customer_id= pr.customer_id
WHERE 
    pr.review_id IS NULL;

--14. Which customers have increased their spending in the second quarter of 2023 compared to the first quarter?
WITH 
   q1_spend AS (
    SELECT 
	      customer_id, SUM(total_amount) AS q1_total
    FROM 
	   sales
    WHERE 
	    sale_date >= '2023-01-01' AND sale_date < '2023-04-01'
    GROUP BY 
	       customer_id
),
q2_spend AS (
    SELECT 
	     customer_id, SUM(total_amount) AS q2_total
    FROM 
	   sales
    WHERE
	    sale_date >= '2023-04-01' AND sale_date < '2023-07-01'
    GROUP BY 
	       customer_id
)
SELECT c.customer_id, 
       c.first_name || ' ' || c.last_name AS customer_name,
       COALESCE(q1.q1_total, 0) AS q1_spending,
       COALESCE(q2.q2_total, 0) AS q2_spending,
       (COALESCE(q2.q2_total, 0) - COALESCE(q1.q1_total, 0)) AS spend_increase
FROM 
   customers c
JOIN 
   q2_spend q2 ON c.customer_id = q2.customer_id
LEFT JOIN 
        q1_spend q1 ON c.customer_id = q1.customer_id
WHERE COALESCE
             (q2.q2_total, 0) > COALESCE(q1.q1_total, 0)
ORDER BY 
       spend_increase DESC;

--15. What are the favorite product categories for Gold tier customers based on their purchase history?
SELECT cat.category_id, 
       cat.category_name, 
       SUM(si.quantity) AS total_items_purchased
FROM 
   customers c
JOIN 
   sales s ON c.customer_id = s.customer_id
JOIN 
   sale_items si ON s.sale_id = si.sale_id
JOIN 
   products p ON si.product_id = p.product_id
JOIN 
   categories cat ON p.category_id = cat.category_id
WHERE 
    c.loyalty_tier = 'Gold'
GROUP BY 
       cat.category_id, cat.category_name
ORDER BY 
       total_items_purchased DESC;

--Employee Performance
--16. Calculate the total sales amount and number of transactions for each employee. Who are the top-performing sales associates?
SELECT e.employee_id, 
       e.first_name || ' ' || e.last_name AS employee_name, 
       e.position,
       COUNT(s.sale_id) AS transaction_count,
       COALESCE(SUM(s.total_amount), 0) AS total_sales
FROM 
   employees e
LEFT JOIN 
        sales s ON e.employee_id = s.employee_id
GROUP BY 
       e.employee_id, employee_name, e.position
ORDER BY 
       total_sales DESC;

--17. Find the average transaction value for each employee. Who generates the highest average sale amount?
SELECT e.employee_id, 
       e.first_name || ' ' || e.last_name AS employee_name,
       COUNT(s.sale_id) AS transaction_count,
       ROUND(AVG(s.total_amount), 2) AS avg_transaction_value
FROM 
   employees e
JOIN 
   sales s ON e.employee_id = s.employee_id
GROUP BY 
       e.employee_id, employee_name
ORDER BY 
       avg_transaction_value DESC;

--18. Create a report showing each store's name, manager's name, number of employees, and total sales amount.
WITH store_managers AS (
    SELECT store_id, first_name || ' ' || last_name AS manager_name
    FROM employees
    WHERE position = 'Store Manager'
),
employee_counts AS (
    SELECT store_id, COUNT(employee_id) AS num_employees
    FROM employees
    WHERE store_id IS NOT NULL
    GROUP BY store_id
),
store_sales AS (
    SELECT store_id, SUM(total_amount) AS total_sales
    FROM sales
    GROUP BY store_id
)
SELECT st.store_id, 
       st.store_name,
       COALESCE(sm.manager_name, 'No Manager Assigned') AS manager_name,
       COALESCE(ec.num_employees, 0) AS total_employees,
       COALESCE(ss.total_sales, 0) AS total_sales
FROM 
   stores st
LEFT JOIN 
        store_managers sm ON st.store_id = sm.store_id
LEFT JOIN 
        employee_counts ec ON st.store_id = ec.store_id
LEFT JOIN 
        store_sales ss ON st.store_id = ss.store_id
ORDER BY 
       st.store_id;

--19. Identify stores where the average employee salary is higher than the company-wide average.
WITH company_avg AS (
    SELECT AVG(salary) AS avg_company_salary FROM employees
)
SELECT st.store_id, 
       st.store_name,
       ROUND(AVG(e.salary), 2) AS store_avg_salary,
       ROUND((SELECT avg_company_salary FROM company_avg), 2) AS company_avg_salary
FROM 
   stores st
JOIN 
   employees e ON st.store_id = e.store_id
GROUP BY 
       st.store_id, st.store_name
HAVING AVG
        (e.salary) > (SELECT avg_company_salary FROM company_avg)
ORDER BY 
       store_avg_salary DESC;

/*20. Create a product performance matrix that categorizes products into four groups based on their sales volume and profit margin:
Stars: High sales, high margin
Volume Drivers: High sales, low margin
Opportunities: Low sales, high margin
Problems: Low sales, low margin
*/
WITH product_metrics AS (
    SELECT p.product_id, 
           p.product_name,
           COALESCE(SUM(si.quantity), 0) AS total_quantity_sold,
           ROUND(((p.price - p.cost) / p.price) * 100, 2) AS profit_margin_pct
    FROM 
	   products p
    LEFT JOIN 
	        sale_items si ON p.product_id = si.product_id
    GROUP BY
	       p.product_id, p.product_name, p.price, p.cost
),
benchmarks AS (
    SELECT 
	     AVG(total_quantity_sold) AS avg_quantity,
         AVG(profit_margin_pct) AS avg_margin
    FROM 
	   product_metrics
)
SELECT pm.product_id, 
       pm.product_name, 
       pm.total_quantity_sold, 
       pm.profit_margin_pct,
       CASE
           WHEN pm.total_quantity_sold >= b.avg_quantity AND pm.profit_margin_pct >= b.avg_margin THEN 'Star'
           WHEN pm.total_quantity_sold >= b.avg_quantity AND pm.profit_margin_pct < b.avg_margin THEN 'Volume Driver'
           WHEN pm.total_quantity_sold < b.avg_quantity AND pm.profit_margin_pct >= b.avg_margin THEN 'Opportunity'
           ELSE 'Problem'
       END AS matrix_category
FROM 
   product_metrics pm, benchmarks b
ORDER BY 
       pm.product_id;

--Advanced Analysis
--21. Generate a management hierarchy report showing the structure from store managers down to sales associates for each store.
WITH RECURSIVE employee_hierarchy AS (
    -- Anchor: Store Managers (manager_id IS NULL)
    SELECT employee_id, 
           store_id, 
           first_name || ' ' || last_name AS employee_name,
           position, 
           manager_id, 
           1 AS level,
           CAST(first_name || ' ' || last_name AS VARCHAR(255)) AS hierarchy_path
    FROM 
	   employees
    WHERE 
	    manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, 
           e.store_id, 
           e.first_name || ' ' || e.last_name AS employee_name,
           e.position, 
           e.manager_id, 
           eh.level + 1,
           CAST(eh.hierarchy_path || ' -> ' || e.first_name || ' ' || e.last_name AS VARCHAR(255))
    FROM 
	   employees e
    JOIN 
	   employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT st.store_name, 
       eh.employee_id, 
       eh.employee_name, 
       eh.position,
       eh.level, 
       eh.hierarchy_path
FROM 
   employee_hierarchy eh
LEFT JOIN 
        stores st ON eh.store_id = st.store_id
ORDER BY 
       st.store_id NULLS LAST, eh.hierarchy_path;

--22. Create a comprehensive customer analysis that shows the purchasing patterns of customers in different loyalty tiers, including average transaction value, most purchased categories, and number of products reviewed.
WITH customer_stats AS (
    SELECT c.customer_id, 
           c.loyalty_tier,
           COUNT(DISTINCT s.sale_id) AS total_orders,
           COALESCE(SUM(s.total_amount), 0) AS total_spend,
           COUNT(DISTINCT pr.review_id) AS total_reviews
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    LEFT JOIN product_reviews pr ON c.customer_id = pr.customer_id
    GROUP BY c.customer_id, c.loyalty_tier
),
tier_summary AS (
    SELECT loyalty_tier,
           COUNT(customer_id) AS customer_count,
           SUM(total_orders) AS tier_orders,
           SUM(total_spend) AS tier_spend,
           SUM(total_reviews) AS tier_reviews,
           ROUND(AVG(total_spend / NULLIF(total_orders, 0)), 2) AS avg_transaction_value
    FROM customer_stats
    GROUP BY loyalty_tier
),
tier_top_category AS (
    SELECT tier_cat.loyalty_tier, tier_cat.category_name
    FROM (
        SELECT c.loyalty_tier, 
               cat.category_name,
               ROW_NUMBER() OVER (PARTITION BY c.loyalty_tier ORDER BY SUM(si.quantity) DESC) AS rank
        FROM customers c
        JOIN sales s ON c.customer_id = s.customer_id
        JOIN sale_items si ON s.sale_id = si.sale_id
        JOIN products p ON si.product_id = p.product_id
        JOIN categories cat ON p.category_id = cat.category_id
        GROUP BY c.loyalty_tier, cat.category_name
    ) tier_cat
    WHERE tier_cat.rank = 1
)
SELECT ts.loyalty_tier, 
       ts.customer_count, 
       ts.tier_orders, 
       ts.tier_spend,
       ts.avg_transaction_value,
       COALESCE(ttc.category_name, 'None') AS most_purchased_category,
       ts.tier_reviews
FROM 
   tier_summary ts
LEFT JOIN 
        tier_top_category ttc ON ts.loyalty_tier = ttc.loyalty_tier
ORDER BY 
       ts.tier_spend DESC;
