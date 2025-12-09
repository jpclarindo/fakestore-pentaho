-- Creating dimension tables
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY UNIQUE,
	first_name TEXT,
	last_name TEXT,
	email TEXT,
	username TEXT,
	city TEXT,
	street TEXT,
	zipcode TEXT,
	lat REAL,
	long REAL
);

CREATE TABLE IF NOT EXISTS products (
	product_id INTEGER PRIMARY KEY,
	title TEXT,
	description TEXT,
	category TEXT,
	price REAL
);


-- Creating fact tables
CREATE TABLE IF NOT EXISTS carts (
	cart_id INTEGER PRIMARY KEY,
	user_id INTEGER,
	FOREIGN KEY (user_id) REFERENCES users (user_id)
);
 

CREATE TABLE IF NOT EXISTS cart_items (
	cart_id INTEGER,
	product_id INTEGER,
	quantity INTEGER,
	FOREIGN KEY (cart_id) REFERENCES carts (cart_id),
	FOREIGN KEY (product_id) REFERENCES products (product_id),
	PRIMARY KEY (cart_id, product_id)
);
