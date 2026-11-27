-- USE optician_db;

-- Insert Suppliers
INSERT INTO suppliers (name, street, street_number, floor, door, city, postal_code, country, phone, fax, nif) VALUES
             ('Luxottica Iberia', 'Carrer de Balmes', '150', '3', '2', 'Barcelona', '08008', 'Spain', '+34 932 001 122', '+34 932 001 123', 'B12345678'),
             ('Safilo Group', 'Avinguda Diagonal', '440', '5', '1', 'Barcelona', '08037', 'Spain', '+34 934 556 677', NULL, 'B87654321');

-- Insert Brands
INSERT INTO brands (name, supplier_id) VALUES
                                           ('Ray-Ban', 1),
                                           ('Oakley', 1),
                                           ('Carrera', 2);

-- Insert Glasses
INSERT INTO glasses (brand_id, left_lens_prescription, right_lens_prescription, frame_type, frame_color, left_lens_color, right_lens_color, price) VALUES
                                                                                                                                                        (1, -1.25, -1.50, 'metàl·lica', 'Gold', 'Green', 'Green', 145.00),
                                                                                                                                                        (2, 0.00, 0.00, 'pasta', 'Matte Black', 'Polarized Blue', 'Polarized Blue', 180.50),
                                                                                                                                                        (3, -2.75, -2.50, 'flotant', 'Silver', 'Transparent', 'Transparent', 210.00);


-- Insert Customers (Laura is referred by Marc)
INSERT INTO customers (first_name, last_name, postal_address, phone, email, registration_date, referred_by_id) VALUES
                                                                                                   ('Marc',  'Vila', 'Carrer Gran de Gràcia 45, Barcelona', '600111222', 'marc.vila@example.com', '2026-01-15', NULL),
                                                                                                   ('Laura', 'Puig', 'Rambla de Catalunya 80, Barcelona', '600333444', 'laura.puig@example.com', '2026-03-10', 1);


-- Insert Employees
INSERT INTO employees (name) VALUES
                                 ('Anna Ferrer'),
                                 ('Jordi Soler');

-- Insert Sales
INSERT INTO sales (glasses_id, customer_id, employee_id, sale_date) VALUES
                                                                        (1, 1, 1, '2026-01-15 11:30:00'),
                                                                        (2, 2, 1, '2026-03-10 17:15:00'),
                                                                        (3, 1, 2, '2026-05-20 10:00:00');

-- ==========================================
-- Sample queries
-- ==========================================

-- 1. List total purchases/invoices for a specific customer
SELECT (c.first_name || ' ' || c.last_name) AS customer, b.name AS brand, g.price, s.sale_date
FROM sales s
         JOIN customers c ON s.customer_id = c.customer_id
         JOIN glasses g ON s.glasses_id = g.glasses_id
         JOIN brands b ON g.brand_id = b.brand_id
WHERE c.customer_id = 1;

-- 2. List different glasses models sold by an employee during a specific year
SELECT DISTINCT e.name AS employee, b.name AS brand, g.frame_type, g.frame_color
FROM sales s
         JOIN employees e ON s.employee_id = e.employee_id
         JOIN glasses g ON s.glasses_id = g.glasses_id
         JOIN brands b ON g.brand_id = b.brand_id
WHERE e.employee_id = 1 AND YEAR(s.sale_date) = 2026;

-- 3. List suppliers that have supplied glasses successfully sold by the optician
SELECT DISTINCT sup.name AS supplier, sup.nif
FROM sales s
         JOIN glasses g ON s.glasses_id = g.glasses_id
         JOIN brands b ON g.brand_id = b.brand_id
         JOIN suppliers sup ON b.supplier_id = sup.supplier_id;

-- ==========================================
-- Constraint tests
-- ==========================================

INSERT INTO brands (name, supplier_id) VALUES ('FakeBrand', 999); -- FK: brands.supplier_id → suppliers.supplier_id (will FAIL)

INSERT INTO glasses (brand_id, left_lens_prescription, right_lens_prescription, frame_type, frame_color, left_lens_color, right_lens_color, price) VALUES (999, -1.00, -2.00, 'metàl·lica', 'Gold', 'Clear', 'Clear', 100.00); -- FK: glasses.brand_id → brands.brand_id (will FAIL)

INSERT INTO customers (first_name, last_name, postal_address, phone, email, registration_date, referred_by_id) VALUES ('Test', 'User', 'Test St', '123456789', 'test@example.com', '2026-06-01', 999); -- FK: customers.referred_by_id → customers.customer_id (will FAIL)
