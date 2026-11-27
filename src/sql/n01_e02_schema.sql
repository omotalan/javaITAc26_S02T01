-- DROP DATABASE IF EXISTS pizzeria_db;
-- CREATE DATABASE pizzeria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE pizzeria_db;

-- 1. Provinces
CREATE TABLE provinces (
                           province_id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(80) NOT NULL UNIQUE
);

-- 2. Cities / Localities (1 Province has many Cities)
CREATE TABLE cities (
                        city_id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(80) NOT NULL,
                        province_id INT NOT NULL,
                        CONSTRAINT fk_city_province
                            FOREIGN KEY (province_id) REFERENCES provinces(province_id)
                                ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. Customers
CREATE TABLE customers (
                           customer_id INT AUTO_INCREMENT PRIMARY KEY,
                           first_name VARCHAR(60) NOT NULL,
                           last_name VARCHAR(100) NOT NULL,
                           address VARCHAR(200) NOT NULL,
                           postal_code VARCHAR(20) NOT NULL,
                           city_id INT NOT NULL,
                           province_id INT NOT NULL,
                           phone VARCHAR(25) NOT NULL,
                           CONSTRAINT fk_customer_city
                               FOREIGN KEY (city_id) REFERENCES cities(city_id)
                                   ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. Stores
CREATE TABLE stores (
                        store_id INT AUTO_INCREMENT PRIMARY KEY,
                        address VARCHAR(200) NOT NULL,
                        postal_code VARCHAR(20) NOT NULL,
                        city_id INT NOT NULL,
                        CONSTRAINT fk_store_city
                            FOREIGN KEY (city_id) REFERENCES cities(city_id)
                                ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 5. Employees
CREATE TABLE employees (
                           employee_id INT AUTO_INCREMENT PRIMARY KEY,
                           first_name VARCHAR(60) NOT NULL,
                           last_name VARCHAR(100) NOT NULL,
                           nif VARCHAR(20) NOT NULL UNIQUE,
                           phone VARCHAR(25) NOT NULL,
                           role ENUM('cuiner', 'repartidor') NOT NULL,
                           store_id INT NOT NULL,
                           CONSTRAINT fk_employee_store
                               FOREIGN KEY (store_id) REFERENCES stores(store_id)
                                   ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 6. Pizza Categories
CREATE TABLE pizza_categories (
                                  category_id INT AUTO_INCREMENT PRIMARY KEY,
                                  name VARCHAR(80) NOT NULL UNIQUE
);

-- 7. Products (pizzes, hamburgueses i begudes)
CREATE TABLE products (
                          product_id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          description TEXT,
                          image_url VARCHAR(255),
                          price DECIMAL(8, 2) NOT NULL,
                          product_type ENUM('pizza', 'burger', 'drink') NOT NULL,
                          pizza_category_id INT NULL, -- Only applies when product_type = 'pizza'
                          CONSTRAINT fk_product_pizza_category
                              FOREIGN KEY (pizza_category_id) REFERENCES pizza_categories(category_id)
                                  ON UPDATE CASCADE ON DELETE SET NULL
);

-- 8. Orders
CREATE TABLE orders (
                        order_id INT AUTO_INCREMENT PRIMARY KEY,
                        order_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        delivery_type ENUM('domicili', 'botiga') NOT NULL,
                        total_price DECIMAL(10, 2) NOT NULL,
                        customer_id INT NOT NULL,
                        store_id INT NOT NULL,
                        delivery_employee_id INT NULL, -- NULL if pickup
                        delivered_at DATETIME NULL,    -- NULL if pickup
                        CONSTRAINT fk_order_customer
                            FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
                                ON UPDATE CASCADE ON DELETE RESTRICT,
                        CONSTRAINT fk_order_store
                            FOREIGN KEY (store_id) REFERENCES stores(store_id)
                                ON UPDATE CASCADE ON DELETE RESTRICT,
                        CONSTRAINT fk_order_delivery_employee
                            FOREIGN KEY (delivery_employee_id) REFERENCES employees(employee_id)
                                ON UPDATE CASCADE ON DELETE SET NULL
);

-- 9. Order Items
CREATE TABLE order_items (
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL CHECK (quantity > 0),
                             PRIMARY KEY (order_id, product_id),
                             CONSTRAINT fk_item_order
                                 FOREIGN KEY (order_id) REFERENCES orders(order_id)
                                     ON UPDATE CASCADE ON DELETE CASCADE,
                             CONSTRAINT fk_item_product
                                 FOREIGN KEY (product_id) REFERENCES products(product_id)
                                     ON UPDATE CASCADE ON DELETE RESTRICT
);
