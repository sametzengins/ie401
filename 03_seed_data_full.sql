-- 03_seed_data_full.sql
USE auto_parts_ecommerce;


-- Re-runnable: clear existing data so INSERTs don't fail on re-run
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE cart_items;
TRUNCATE TABLE order_items;
TRUNCATE TABLE payments;
TRUNCATE TABLE reviews;
TRUNCATE TABLE wishlists;
TRUNCATE TABLE archive_orders;
TRUNCATE TABLE orders;
TRUNCATE TABLE carts;
TRUNCATE TABLE addresses;
TRUNCATE TABLE part_images;
TRUNCATE TABLE compatibility;
TRUNCATE TABLE parts;
TRUNCATE TABLE part_categories;
TRUNCATE TABLE vehicle_models;
TRUNCATE TABLE vehicle_brands;
TRUNCATE TABLE sellers;
TRUNCATE TABLE customer_vehicles;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- Safety: disable FK checks during bulk load (re-enable after)
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- 1) MASTER DATA
-- =========================

-- Vehicle brands
INSERT INTO vehicle_brands (brand_id, brand_name, country_of_origin, founded_year) VALUES
(1, 'Toyota', 'Japan', 1937),
(2, 'BMW', 'Germany', 1916),
(3, 'Ford', 'USA', 1903),
(4, 'Fiat', 'Italy', 1899),
(5, 'Volkswagen', 'Germany', 1937),
(6, 'Renault', 'France', 1899)
AS new
ON DUPLICATE KEY UPDATE brand_name=new.brand_name;

-- Vehicle models
INSERT INTO vehicle_models (model_id, brand_id, model_name, generation, production_years, body_type) VALUES
(1, 1, 'Corolla', 'E210', '2018-2023', 'Sedan'),
(2, 1, 'Yaris', 'XP210', '2020-Present', 'Hatchback'),
(3, 2, '3 Series', 'G20', '2018-2023', 'Sedan'),
(4, 2, '5 Series', 'G30', '2017-2023', 'Sedan'),
(5, 3, 'Focus', 'MK4', '2018-2023', 'Hatchback'),
(6, 4, 'Egea', 'Type 356', '2015-Present', 'Sedan'),
(7, 5, 'Golf', 'MK8', '2019-Present', 'Hatchback'),
(8, 5, 'Passat', 'B8', '2014-2023', 'Sedan'),
(9, 6, 'Clio', 'V', '2019-Present', 'Hatchback'),
(10, 6, 'Megane', 'IV', '2016-2024', 'Sedan')
AS new
ON DUPLICATE KEY UPDATE model_name=new.model_name;

-- Part categories
INSERT INTO part_categories (category_id, category_name, parent_category_id, description) VALUES
(1, 'Motor Parçaları', NULL, 'Motor aksamı'),
(2, 'Fren Sistemi', NULL, 'Fren mekanizmaları'),
(3, 'Elektrik', NULL, 'Aydınlatma ve ateşleme'),
(4, 'Fren Balatası', 2, 'Ön ve arka balatalar'),
(5, 'Fren Diski', 2, 'Diskler'),
(6, 'Filtreler', 1, 'Yağ, hava, polen filtreleri'),
(7, 'Aydınlatma', 3, 'Far ve stop lambaları')
AS new
ON DUPLICATE KEY UPDATE category_name=new.category_name;

-- =========================
-- 2) USERS & SELLERS
-- =========================

-- Users
INSERT INTO users (user_id, email, password_hash, first_name, last_name, phone, user_type, account_status, registration_date) VALUES
(1, 'burak.arslan1@mail.com', 'hash_1xyz', 'Burak', 'Arslan', '0535-137-3880', 'seller', 'verified', '2022-04-27'),
(2, 'zeynep.demir2@mail.com', 'hash_2xyz', 'Zeynep', 'Demir', '0551-650-3079', 'seller', 'verified', '2023-03-28'),
(3, 'ayşe.şahin3@mail.com', 'hash_3xyz', 'Ayşe', 'Şahin', '0538-454-5899', 'seller', 'verified', '2022-11-21'),
(4, 'mehmet.öztürk4@mail.com', 'hash_4xyz', 'Mehmet', 'Öztürk', '0550-322-9120', 'seller', 'verified', '2022-05-22'),
(5, 'can.yıldız5@mail.com', 'hash_5xyz', 'Can', 'Yıldız', '0545-871-5471', 'seller', 'verified', '2023-11-24'),

(6, 'zeynep.doğan6@mail.com', 'hash_6xyz', 'Zeynep', 'Doğan', '0540-428-9223', 'customer', 'active', '2023-09-03'),
(7, 'mehmet.doğan7@mail.com', 'hash_7xyz', 'Mehmet', 'Doğan', '0535-979-8892', 'customer', 'active', '2023-05-27'),
(8, 'elif.kaya8@mail.com', 'hash_8xyz', 'Elif', 'Kaya', '0545-254-7036', 'customer', 'active', '2023-01-21'),
(9, 'deniz.yıldız9@mail.com', 'hash_9xyz', 'Deniz', 'Yıldız', '0554-601-5293', 'customer', 'active', '2023-06-02'),
(10, 'deniz.yılmaz10@mail.com', 'hash_10xyz', 'Deniz', 'Yılmaz', '0544-217-7968', 'customer', 'active', '2023-04-11'),
(11, 'elif.doğan11@mail.com', 'hash_11xyz', 'Elif', 'Doğan', '0531-757-4091', 'customer', 'active', '2023-05-26'),
(12, 'ayşe.aydın12@mail.com', 'hash_12xyz', 'Ayşe', 'Aydın', '0533-548-4497', 'customer', 'active', '2023-08-26'),
(13, 'ahmet.yıldız13@mail.com', 'hash_13xyz', 'Ahmet', 'Yıldız', '0530-971-5564', 'customer', 'active', '2022-05-08'),
(14, 'elif.aydın14@mail.com', 'hash_14xyz', 'Elif', 'Aydın', '0537-349-3850', 'customer', 'active', '2022-07-09'),
(15, 'deniz.yıldız15@mail.com', 'hash_15xyz', 'Deniz', 'Yıldız', '0541-507-9193', 'customer', 'active', '2023-10-26'),
(16, 'ece.demir16@mail.com', 'hash_16xyz', 'Ece', 'Demir', '0547-709-5054', 'customer', 'active', '2023-06-09'),
(17, 'burak.şahin17@mail.com', 'hash_17xyz', 'Burak', 'Şahin', '0549-505-8571', 'customer', 'active', '2022-06-03'),
(18, 'ayşe.öztürk18@mail.com', 'hash_18xyz', 'Ayşe', 'Öztürk', '0541-619-4334', 'customer', 'active', '2023-02-16'),
(19, 'mehmet.aydın19@mail.com', 'hash_19xyz', 'Mehmet', 'Aydın', '0535-602-3472', 'customer', 'active', '2023-06-21'),
(20, 'burak.öztürk20@mail.com', 'hash_20xyz', 'Burak', 'Öztürk', '0536-779-3122', 'customer', 'active', '2022-06-09'),

(21, 'admin@vinmarket.local', 'hash_admin', 'Admin', 'User', '+905550000000', 'admin', 'verified', '2024-01-01')
AS new
ON DUPLICATE KEY UPDATE email=new.email;

-- Sellers
INSERT INTO sellers (seller_id, user_id, store_name, tax_number, specialization, rating_avg, seller_status) VALUES
(1, 1, 'BoschCarParts TR', 'TR1234567890', 'Motor', 4.60, 'verified'),
(2, 2, 'AutoFren Market', 'TR2234567890', 'Fren', 4.30, 'verified'),
(3, 3, 'ElektrikPro', 'TR3234567890', 'Elektrik', 4.10, 'verified'),
(4, 4, 'OEM Filter House', 'TR4234567890', 'Filtre', 4.50, 'verified'),
(5, 5, 'PremiumLights', 'TR5234567890', 'Aydınlatma', 4.20, 'verified')
AS new
ON DUPLICATE KEY UPDATE store_name=new.store_name;

-- =========================
-- 3) CUSTOMER VEHICLES & ADDRESSES
-- =========================

INSERT INTO customer_vehicles (vehicle_id, user_id, make, model, year, engine_type, license_plate, is_default) VALUES
(1, 6, 'Toyota', 'Corolla', 2022, '1.6 Petrol', '34ABC001', TRUE),
(2, 7, 'BMW', '3 Series', 2020, '2.0 Petrol', '34ABC002', TRUE),
(3, 8, 'Volkswagen', 'Golf', 2021, '1.5 TSI', '34ABC003', TRUE),
(4, 9, 'Renault', 'Clio', 2021, '1.0 TCe', '34ABC004', TRUE),
(5, 10, 'Fiat', 'Egea', 2019, '1.3 Diesel', '34ABC005', TRUE),
(6, 11, 'Ford', 'Focus', 2020, '1.5 EcoBlue', '34ABC006', TRUE),
(7, 12, 'BMW', '5 Series', 2022, '2.0 Diesel', '34ABC007', TRUE)
AS new
ON DUPLICATE KEY UPDATE license_plate=new.license_plate;

INSERT INTO addresses (address_id, user_id, address_type, city, district, open_address, is_default) VALUES
(1, 6, 'shipping', 'İstanbul', 'Kadıköy', 'Rasimpaşa Mah. No:10', TRUE),
(2, 6, 'billing',  'İstanbul', 'Kadıköy', 'Rasimpaşa Mah. No:10', TRUE),
(3, 7, 'shipping', 'İstanbul', 'Beşiktaş', 'Levent Mah. No:22', TRUE),
(4, 8, 'shipping', 'Ankara', 'Çankaya', 'Kızılay Cad. No:5', TRUE),
(5, 9, 'shipping', 'İzmir', 'Konak', 'Alsancak Mah. No:7', TRUE),
(6, 10,'shipping', 'Bursa', 'Nilüfer', 'FSM Bulvarı No:18', TRUE)
AS new
ON DUPLICATE KEY UPDATE open_address=new.open_address;

-- =========================
-- 4) PARTS, COMPATIBILITY, IMAGES
-- =========================

-- Parts (keep stock high enough so triggers won't create negative stock when order_items insert runs)
INSERT INTO parts (part_id, seller_id, category_id, part_name, part_number, unit_price, stock_quantity, part_status) VALUES
(1, 4, 6, 'Toyota Corolla Oil Filter', 'TOY-OIL-001', 180.00, 200, 'active'),
(2, 4, 6, 'BMW 3 Series Oil Filter', 'BMW-OIL-003', 300.00, 150, 'active'),
(3, 2, 4, 'Front Brake Pads - Corolla', 'TOY-BPAD-010', 650.00, 120, 'active'),
(4, 2, 5, 'Brake Disc Set - Corolla', 'TOY-BDSK-020', 1200.00, 60, 'active'),
(5, 3, 7, 'LED Headlight Bulb H7', 'ELE-H7-LED', 350.00, 500, 'active'),
(6, 5, 7, 'BMW 5 Series Tail Light (Right)', 'BMW-TL-505', 4200.00, 25, 'active'),
(7, 1, 1, 'Spark Plug Set (4 pcs)', 'SPK-SET-004', 520.00, 180, 'active'),
(8, 1, 1, 'Engine Air Intake Hose', 'ENG-HOSE-110', 780.00, 40, 'active'),
(9, 2, 4, 'Rear Brake Pads - Golf', 'VW-BPAD-030', 590.00, 90, 'active'),
(10,2, 5, 'Front Brake Disc - Golf', 'VW-BDSK-040', 980.00, 70, 'active'),
(11,4, 6, 'Cabin Filter - Clio', 'REN-CAB-050', 220.00, 130, 'active'),
(12,3, 3, 'Ignition Coil - Focus', 'FRD-IGN-060', 890.00, 55, 'active')
AS new
ON DUPLICATE KEY UPDATE part_name=new.part_name;

-- Compatibility
INSERT INTO compatibility (compatibility_id, part_id, brand_id, model_id, year_from, year_to, engine_types) VALUES
(1, 1, 1, 1, 2018, 2023, '1.6 Petrol'),
(2, 3, 1, 1, 2018, 2023, 'All'),
(3, 4, 1, 1, 2018, 2023, 'All'),
(4, 2, 2, 3, 2016, 2024, 'All'),
(5, 6, 2, 4, 2017, 2024, 'All'),
(6, 9, 5, 7, 2019, 2024, 'All'),
(7, 10,5, 7, 2019, 2024, 'All'),
(8, 11,6, 9, 2019, 2024, 'All'),
(9, 12,3, 5, 2018, 2024, 'All'),
(10,5, 1, 1, 2018, 2023, 'All'),
(11,7, 2, 3, 2016, 2024, 'All'),
(12,8, 2, 3, 2016, 2024, 'All')
AS new
ON DUPLICATE KEY UPDATE engine_types=new.engine_types;

-- Images
INSERT INTO part_images (image_id, part_id, image_url, is_primary, image_order) VALUES
(1, 1, 'img/toy_oil_001.jpg', TRUE, 1),
(2, 2, 'img/bmw_oil_003.jpg', TRUE, 1),
(3, 3, 'img/toy_bpad_010.jpg', TRUE, 1),
(4, 4, 'img/toy_bdsk_020.jpg', TRUE, 1),
(5, 5, 'img/h7_led.jpg', TRUE, 1),
(6, 6, 'img/bmw_tl_505.jpg', TRUE, 1),
(7, 7, 'img/spk_set_004.jpg', TRUE, 1),
(8, 8, 'img/eng_hose_110.jpg', TRUE, 1),
(9, 9, 'img/vw_bpad_030.jpg', TRUE, 1),
(10,10,'img/vw_bdsk_040.jpg', TRUE, 1),
(11,11,'img/ren_cab_050.jpg', TRUE, 1),
(12,12,'img/frd_ign_060.jpg', TRUE, 1)
AS new
ON DUPLICATE KEY UPDATE image_url=new.image_url;

-- =========================
-- 5) CARTS & CART ITEMS
-- =========================

INSERT INTO carts (cart_id, user_id, cart_status, created_at, updated_at) VALUES
(1, 6, 'active',   '2025-12-10 10:00:00', '2025-12-12 09:10:00'),
(2, 7, 'active',   '2025-12-09 15:00:00', '2025-12-12 12:00:00'),
(3, 8, 'abandoned','2025-12-01 08:00:00', '2025-12-05 09:00:00'),
(4, 9, 'abandoned','2025-11-28 08:00:00', '2025-12-01 09:00:00'),
(5, 10,'checked_out','2025-12-02 11:30:00','2025-12-02 12:10:00'),
(14, 11, 'active', '2025-12-12 10:00:00', '2025-12-12 10:00:00')
AS new
ON DUPLICATE KEY UPDATE cart_status=new.cart_status;

INSERT INTO cart_items (cart_item_id, cart_id, part_id, quantity, unit_price_snapshot, vehicle_id) VALUES
(1, 1, 1, 1, 180.00, 1),
(2, 1, 3, 1, 650.00, 1),
(3, 2, 2, 1, 300.00, 2),
(4, 3, 11,1, 220.00, 4),
(5, 4, 9, 2, 590.00, 3),
(6, 14, 5, 2, 350.00, 6)
AS new
ON DUPLICATE KEY UPDATE quantity=new.quantity;

-- =========================
-- 6) ORDERS, ITEMS, PAYMENTS, REVIEWS, WISHLISTS
-- =========================

-- Orders (some within last 30 days + one old for archive demo)
INSERT INTO orders (order_id, order_number, user_id, total_amount, final_amount, order_status, order_date) VALUES
(1, 'ORD-2025-0001', 6, 830.00, 880.00, 'delivered', '2025-12-02 12:00:00'),
(2, 'ORD-2025-0002', 7, 300.00, 330.00, 'processing','2025-12-11 09:30:00'),
(3, 'ORD-2025-0003', 8, 220.00, 240.00, 'cancelled', '2025-12-01 14:10:00'),
(4, 'ORD-2024-0100', 9, 590.00, 650.00, 'delivered', '2024-10-01 10:00:00'),
(21, 'ORD-2025-0021', 12, 450.00, 450.00, 'delivered', '2025-12-10 14:00:00'),
(22, 'ORD-2025-0022', 13, 1200.00, 1200.00, 'shipped', '2025-12-12 09:00:00')
AS new
ON DUPLICATE KEY UPDATE order_status=new.order_status;

INSERT INTO order_items (order_item_id, order_id, part_id, seller_id, quantity, unit_price, item_total) VALUES
(1, 1, 1, 4, 1, 180.00, 180.00),
(2, 1, 3, 2, 1, 650.00, 650.00),
(3, 2, 2, 4, 1, 300.00, 300.00),
(4, 3, 11,4, 1, 220.00, 220.00),
(5, 4, 9, 2, 1, 590.00, 590.00),
(6, 21, 5, 3, 1, 350.00, 350.00),
(7, 22, 4, 2, 1, 1200.00, 1200.00)
AS new
ON DUPLICATE KEY UPDATE quantity=new.quantity;

INSERT INTO payments (payment_id, order_id, payment_method, amount, status, transaction_id) VALUES
(1, 1, 'credit_card', 880.00, 'completed', 'TXN-0001'),
(2, 2, 'bank_transfer', 330.00, 'pending',   'TXN-0002'),
(3, 3, 'paypal', 240.00, 'failed',          'TXN-0003'),
(4, 4, 'credit_card', 650.00, 'completed',  'TXN-0100'),
(5, 21, 'credit_card', 450.00, 'completed', 'TXN-0021'),
(6, 22, 'credit_card', 1200.00, 'completed', 'TXN-0022')
AS new
ON DUPLICATE KEY UPDATE status=new.status;

INSERT INTO reviews (review_id, user_id, part_id, order_id, rating, comment, fitment_rating) VALUES
(1, 6, 1, 1, 5, 'Fast shipping, good quality!', 5),
(2, 6, 3, 1, 4, 'Pads are fine, slight dust.', 4),
(3, 9, 9, 4, 5, 'Perfect match for Golf.', 5)
AS new
ON DUPLICATE KEY UPDATE rating=new.rating;

INSERT INTO wishlists (wishlist_id, user_id, part_id, notes) VALUES
(1, 7, 6, 'Waiting for discount'),
(2, 8, 10, 'Need next month'),
(3, 10,5, 'Try later')
AS new
ON DUPLICATE KEY UPDATE notes=new.notes;

-- =========================
-- 7) ARCHIVE ORDERS (SEED)
-- =========================
INSERT INTO archive_orders (order_id, order_number, user_id, total_amount, final_amount, order_status, order_date, archived_at) VALUES
(1001, 'ORD-2022-9001', 6, 150.00, 150.00, 'delivered', '2022-05-15 10:00:00', '2023-01-01 00:00:00')
AS new
ON DUPLICATE KEY UPDATE order_status=new.order_status;

-- Re-enable FK checks
SET FOREIGN_KEY_CHECKS = 1;