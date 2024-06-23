-- Inserting a new customer
INSERT INTO customer_info (id, first_name, last_name)
VALUES (500, 'John', 'Doe');
-- Retrieve customer information
SELECT * FROM customer_info WHERE id = 500;

-- Inserting customer address
INSERT INTO customer_address (house_no, street, city, state, postal_code, customer_id)
VALUES (123, 'Main St', 'Cityville', 'Stateville', '12345', 500);
-- Retrieve customer address
SELECT * FROM customer_address WHERE customer_id = 500;

-- Inserting customer contact
INSERT INTO customer_contact (phone_no, customer_id)
VALUES (1234567890, 500);
-- Retrieve customer contact
SELECT * FROM customer_contact WHERE customer_id = 500;

-- Inserting a new order
INSERT INTO orders (id, customer_id, order_date, type, total_price)
VALUES (2500, 1, '2023-01-01', 'Delivery', 50.00);

-- Retrieve order
SELECT * FROM orders WHERE id = 2500;

-- Inserting order items
INSERT INTO order_item (id, order_id, item_id, quantity)
VALUES (4000, 2500, 1, 2);

-- Retrieve order items
SELECT * FROM order_item WHERE id = 4000;

-- Deleting a customer along with related data
DELETE FROM customer_info WHERE id = 500;

SELECT * FROM customer_info WHERE id = 500;

-- Deleting an order along with related data
DELETE FROM orders WHERE id = 2500;

SELECT * FROM orders WHERE id = 2500;
------
SELECT * FROM menu where id =1;

-- Updating menu item information
UPDATE menu SET price = 15 WHERE id = 1;

SELECT * FROM menu where id =1;

-------
SELECT * FROM review where id =1;

-- Updating review information
UPDATE review SET rating = 4 WHERE id = 1;

SELECT * FROM review where id =1;

----Identify top-spending customers along with their order details.(JOIN and ORDER BY)
SELECT c.first_name, c.last_name, o.order_date, SUM(o.total_price) AS total_order_amount
FROM customer_info c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.first_name, c.last_name, o.order_date
ORDER BY total_order_amount DESC;

----Identify loyal customers who have placed multiple orders (Group By with Having)
SELECT c.first_name, c.last_name, COUNT(o.id) AS order_count
FROM customer c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(o.id) > 2;

----Find popular menu items with high average ratings (Subquery with IN)
SELECT name, (SELECT AVG(rating) FROM review WHERE item_id = menu.id) AS average_rating
FROM menu
WHERE id IN (SELECT DISTINCT item_id FROM review);

----Identify customers who actively place orders (Subquery with EXISTS)
SELECT first_name, last_name
FROM customer c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);

----Obtain a comprehensive view of customer orders and the associated menu items (join multiple tables)
SELECT c.first_name, c.last_name, o.order_date, m.name AS menu_item
FROM customer c
JOIN orders o ON c.id = o.customer_id
JOIN order_item oi ON o.id = oi.order_id
JOIN menu m ON oi.item_id = m.id;

----Find the menu items with the highest and lowest average ratings (UNION)
WITH highest_rated_menu AS (
    SELECT menu.id, name, AVG(review.rating) as average_rating
    FROM menu
    LEFT JOIN review ON menu.id = review.item_id
    GROUP BY menu.id, name
    ORDER BY average_rating DESC, menu.id
    LIMIT 1
),
lowest_rated_menu AS (
    SELECT menu.id, name, AVG(review.rating) as average_rating
    FROM menu
    LEFT JOIN review ON menu.id = review.item_id
    GROUP BY menu.id, name
    ORDER BY average_rating ASC, menu.id
    LIMIT 1
)

SELECT * FROM highest_rated_menu
UNION
SELECT * FROM lowest_rated_menu;

----Calculate the total sales for each menu category (SUM)
SELECT menu.category, SUM(orders.total_price) as total_sales
FROM menu
JOIN order_item ON menu.id = order_item.item_id
JOIN orders ON order_item.order_id = orders.id
GROUP BY menu.category;

----Average Quantity of Items Ordered per Order (AVG)
SELECT orders.id, AVG(order_item.quantity) AS average_quantity
FROM orders
JOIN order_item ON orders.id = order_item.order_id
GROUP BY orders.id
ORDER BY average_quantity DESC;

----Menu Items with the Highest and Lowest Number of Reviews(RANK)
WITH ranked_menu_reviews AS (
    SELECT menu.id, menu.name, COUNT(review.id) AS num_reviews,
           RANK() OVER (ORDER BY COUNT(review.id) DESC) AS rank_high,
           RANK() OVER (ORDER BY COUNT(review.id) ASC) AS rank_low
    FROM menu
    LEFT JOIN review ON menu.id = review.item_id
    GROUP BY menu.id, menu.name
)

SELECT id, name, num_reviews, 'High' AS ranking
FROM ranked_menu_reviews
WHERE rank_high = 1

UNION

SELECT id, name, num_reviews, 'Low' AS ranking
FROM ranked_menu_reviews
WHERE rank_low = 1;

---- Analysis of queries(1)
EXPLAIN ANALYZE 
SELECT orders.id, AVG(order_item.quantity) AS average_quantity
FROM orders
JOIN order_item ON orders.id = order_item.order_id
GROUP BY orders.id
ORDER BY average_quantity DESC;

----create indexes
-- Index for orders.id
CREATE INDEX IF NOT EXISTS idx_orders_id ON public.orders (id);

-- Index for order_item.order_id
CREATE INDEX IF NOT EXISTS idx_order_item_order_id ON public.order_item (order_id);

---- Analysis of queries(2)
EXPLAIN ANALYZE 
SELECT menu.category, SUM(orders.total_price) as total_sales
FROM menu
JOIN order_item ON menu.id = order_item.item_id
JOIN orders ON order_item.order_id = orders.id
GROUP BY menu.category;

----create indexes
-- Index for menu.id
CREATE INDEX IF NOT EXISTS idx_menu_id ON public.menu (id);

-- Index for order_item.item_id
CREATE INDEX IF NOT EXISTS idx_order_item_item_id ON public.order_item (item_id);

-- Index for orders.id
CREATE INDEX IF NOT EXISTS idx_orders_id ON public.orders (id);

-- Index for menu.category
CREATE INDEX IF NOT EXISTS idx_menu_category ON public.menu (category);

