-- USE pizzeria_db;

-- Insert Provinces
INSERT IGNORE INTO provinces (name) VALUES
                             ('Barcelona'),
                             ('Girona');

-- Insert Cities
INSERT INTO cities (name, province_id) VALUES
                                          ('Barcelona', 1),
                                          ('Badalona', 1),
                                          ('Girona', 2);


-- Insert Customers
INSERT INTO customers (first_name, last_name, address, postal_code, city_id, province_id, phone) VALUES
                                                                                                   ('Marc',  'Vila',  'Carrer Gran de Gràcia 45', '08012', 1, 1, '600111222'),
                                                                                                   ('Laura', 'Puig',  'Rambla de Catalunya 80',   '08007', 1, 1, '600333444'),
                                                                                                   ('Nil',   'Roca',  'Carrer de la Força 12',    '17004', 3, 2, '600555666');

-- Insert Stores
INSERT INTO stores (address, postal_code, city_id) VALUES
                                                     ('Carrer de Balmes 150', '08008', 1),
                                                     ('Avinguda Diagonal 440', '08037', 1),
                                                     ('Carrer Nou 7',          '17001', 3);

-- Insert Employees
INSERT IGNORE INTO employees (first_name, last_name, nif, phone, role, store_id) VALUES
                                                                              ('Anna',  'Ferrer', '12345678A', '932001122', 'cuiner',      1),
                                                                              ('Jordi', 'Soler',  '87654321B', '934556677', 'repartidor',  1),
                                                                              ('Ona',   'Rius',   '11223344C', '972100200', 'cuiner',      3),
                                                                              ('Pau',   'Mas',    '55667788D', '972100201', 'repartidor',  3);

-- Insert Pizza Categories
INSERT IGNORE INTO pizza_categories (name) VALUES
                                       ('Tradicional'),
                                       ('Especial'),
                                       ('Vegana');

-- Insert Products (pizzes, hamburgueses i begudes)
INSERT INTO products (name, description, image_url, price, product_type, pizza_category_id) VALUES
                                                                                               ('Margherita', 'Tomàquet, mozzarella i alfàbrega', 'https://example.com/margherita.jpg', 8.50,  'pizza',  1),
                                                                                               ('Quattro Stagioni', 'Pernil dolç, xampinyons, olives i pebrot', 'https://example.com/4stag.jpg', 11.00, 'pizza', 2),
                                                                                               ('Vegana del Huerto', 'Verdures ecològiques i tofu', 'https://example.com/vegana.jpg', 10.00, 'pizza', 3),
                                                                                               ('Hamburguesa Clàssica', 'Vedella, formatge i verdures', 'https://example.com/burger.jpg', 9.00, 'burger', NULL),
                                                                                               ('Aigua Mineral', 'Ampolla 50cl', 'https://example.com/water.jpg', 1.50, 'drink', NULL),
                                                                                               ('Coca-Cola', 'Llauna 33cl', 'https://example.com/coke.jpg', 2.00, 'drink', NULL);


-- Insert Orders
INSERT INTO orders (order_datetime, delivery_type, total_price, customer_id, store_id, delivery_employee_id, delivered_at) VALUES
                                                                                                                          ('2026-01-15 11:30:00', 'botiga',    8.50,  1, 1, NULL, NULL),
                                                                                                                          ('2026-03-10 17:15:00', 'domicili',  22.50, 2, 1, 2,    '2026-03-10 18:00:00'),
                                                                                                                          ('2026-05-20 10:00:00', 'domicili',  15.00, 3, 3, 4,    '2026-05-20 10:45:00'),
                                                                                                                          ('2026-05-21 20:30:00', 'botiga',    12.50, 1, 1, NULL, NULL);


-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                           (1, 1, 1),
                                                           (2, 2, 1),
                                                           (2, 5, 2),
                                                           (3, 3, 1),
                                                           (3, 6, 2),
                                                           (4, 1, 1),
                                                           (4, 4, 1);

-- ==========================================
-- Sample queries
-- ==========================================

-- 1. List total orders/invoices for a specific customer
SELECT (c.first_name || ' ' || c.last_name) AS customer, o.order_datetime, o.delivery_type, o.total_price
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 1;

-- 2. List different products sold by a store during a specific year
SELECT DISTINCT s.store_id, p.name AS product, p.product_type, oi.quantity
FROM orders o
         JOIN stores s ON o.store_id = s.store_id
         JOIN order_items oi ON o.order_id = oi.order_id
         JOIN products p ON oi.product_id = p.product_id
WHERE s.store_id = 1 AND YEAR(o.order_datetime) = 2026;

-- 3. List pizza categories that have pizzas successfully ordered by the pizzeria
SELECT DISTINCT pc.name AS category, pc.category_id
FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id
         JOIN products p ON oi.product_id = p.product_id
         JOIN pizza_categories pc ON p.pizza_category_id = pc.category_id;

-- ==========================================
-- Constraint tests
-- ==========================================

INSERT INTO cities (name, province_id) VALUES ('InvalidCity', 999); -- FK: cities.province_id → provinces.province_id (will FAIL)

INSERT INTO products (name, description, image_url, price, product_type, pizza_category_id) VALUES ('TestPizza', 'desc', 'url', 5.00, 'pizza', 999); -- FK: products.pizza_category_id → pizza_categories.category_id (will FAIL for product_type=pizza)

INSERT INTO orders (order_datetime, delivery_type, total_price, customer_id, store_id, delivery_employee_id, delivered_at) VALUES ('2026-06-01', 'botiga', 10.00, 999, 1, NULL, NULL); -- FK: orders.customer_id → customers.customer_id (will FAIL)
