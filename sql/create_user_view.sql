-- Made by Joao Paulo Clarindo - 09/12/2025

-- Drop TABLE
DROP TABLE IF EXISTS user_analytics;


-- Create a new table for analytics
CREATE TABLE IF NOT EXISTS user_analytics (
	user_id INTEGER PRIMARY KEY,
	total_carts INTEGER,
	total_products INTEGER,
	avg_products_per_cart REAL,
	distinct_categories INTEGER,
	most_expensive_product REAL,
	total_value REAL
);


INSERT INTO user_analytics (user_id, total_carts, total_products, avg_products_per_cart, distinct_categories, most_expensive_product, total_value)
SELECT 
    u.user_id,    
    -- Number of user shopping carts
    COUNT(DISTINCT c.cart_id) AS total_carts,    
    -- Number of distinct products in all shopping carts (per user)
    COUNT(DISTINCT ci.product_id) AS total_products,    
    -- Average quantity of products per cart, rounded.
    COALESCE(ROUND(
        CAST(COUNT(ci.product_id) AS REAL) / NULLIF(COUNT(DISTINCT c.cart_id), 0), 2
    ), 0) AS avg_products_per_cart,    
    -- Number of different product categories purchased
    COUNT(DISTINCT p.category) AS distinct_categories,    
    -- Price of the user's most expensive product
    COALESCE(MAX(p.price), 0) AS most_expensive_product,    
    -- Sum of the product prices (assuming one unit per product)
    COALESCE(SUM(p.price), 0) AS total_value
FROM
    users u
    LEFT OUTER JOIN carts c ON u.user_id = c.user_id
    LEFT OUTER JOIN cart_items ci ON c.cart_id = ci.cart_id
    LEFT OUTER JOIN products p ON ci.product_id = p.product_id
GROUP BY 
    u.user_id;