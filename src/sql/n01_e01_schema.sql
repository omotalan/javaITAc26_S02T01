-- DROP DATABASE IF EXISTS optician_db;
-- CREATE DATABASE optician_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE optician_db;

-- 1. Suppliers (Proveïdors)
CREATE TABLE suppliers (
                           supplier_id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           street VARCHAR(100) NOT NULL,
                           street_number VARCHAR(20) NOT NULL,
                           floor VARCHAR(20),
                           door VARCHAR(20),
                           city VARCHAR(60) NOT NULL,
                           postal_code VARCHAR(20) NOT NULL,
                           country VARCHAR(60) NOT NULL,
                           phone VARCHAR(25) NOT NULL,
                           fax VARCHAR(25),
                           nif VARCHAR(20) NOT NULL UNIQUE -- NIF
);

-- 2. Brands (Marques)
CREATE TABLE brands (
                        brand_id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(80) NOT NULL UNIQUE,
                        supplier_id INT NOT NULL,
                        CONSTRAINT fk_brand_supplier
                            FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
                                ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. Glasses (Ulleres)
CREATE TABLE glasses (
                         glasses_id INT AUTO_INCREMENT PRIMARY KEY,
                         brand_id INT NOT NULL,
                         left_lens_prescription DECIMAL(4, 2) NOT NULL,
                         right_lens_prescription DECIMAL(4, 2) NOT NULL,
                         frame_type ENUM('flotant', 'pasta', 'metàl·lica') NOT NULL,
                         frame_color VARCHAR(40) NOT NULL,
                         left_lens_color VARCHAR(40) NOT NULL,
                         right_lens_color VARCHAR(40) NOT NULL,
                         price DECIMAL(8, 2) NOT NULL,
                         CONSTRAINT fk_glasses_brand
                             FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
                                 ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 4. Customers (Clients/es)
CREATE TABLE customers (
                           customer_id INT AUTO_INCREMENT PRIMARY KEY,
                           first_name VARCHAR(100) NOT NULL,
                           last_name VARCHAR(100) NOT NULL,
                           postal_address VARCHAR(200) NOT NULL,
                           phone VARCHAR(25) NOT NULL,
                           email VARCHAR(100) NOT NULL UNIQUE,
                           registration_date DATE NOT NULL DEFAULT (CURRENT_DATE),
                           referred_by_id INT NULL,             -- auto-referencia
                           CONSTRAINT fk_customer_referral
                               FOREIGN KEY (referred_by_id) REFERENCES customers(customer_id)
                                   ON UPDATE CASCADE ON DELETE SET NULL
);

-- 5. Employees (Empleats/des)
CREATE TABLE employees (
                           employee_id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(100) NOT NULL
);

-- 6. Sales (Vendes)
CREATE TABLE sales (
                       sale_id INT AUTO_INCREMENT PRIMARY KEY,
                       glasses_id INT NOT NULL,
                       customer_id INT NOT NULL,
                       employee_id INT NOT NULL,
                       sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       CONSTRAINT fk_sale_glasses
                           FOREIGN KEY (glasses_id) REFERENCES glasses(glasses_id)
                               ON UPDATE CASCADE ON DELETE RESTRICT,
                       CONSTRAINT fk_sale_customer
                           FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
                               ON UPDATE CASCADE ON DELETE RESTRICT,
                       CONSTRAINT fk_sale_employee
                           FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
                               ON UPDATE CASCADE ON DELETE RESTRICT
);
