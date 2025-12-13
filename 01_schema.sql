
-- 01_schema.sql
-- Database creation
DROP DATABASE IF EXISTS auto_parts_ecommerce;
CREATE DATABASE auto_parts_ecommerce;
USE auto_parts_ecommerce;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    user_type ENUM('customer', 'seller', 'admin') DEFAULT 'customer',
    account_status ENUM('active', 'inactive', 'suspended', 'verified') DEFAULT 'active',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_account_status (account_status),
    INDEX idx_user_type (user_type)
);

-- Customer Vehicles table
CREATE TABLE customer_vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    engine_type VARCHAR(50),
    license_plate VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_make_model_year (make, model, year),
    CHECK (year >= 1900 AND year <= 2100)
);

-- Sellers table
CREATE TABLE sellers (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    store_name VARCHAR(255) NOT NULL,
    tax_number VARCHAR(50),
    specialization VARCHAR(100),
    rating_avg DECIMAL(3,2) DEFAULT 0.00,
    seller_status ENUM('active', 'inactive', 'verified') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_store_name (store_name),
    INDEX idx_seller_status (seller_status),
    INDEX idx_specialization (specialization)
);

-- Vehicle Brands table
CREATE TABLE vehicle_brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(50) UNIQUE NOT NULL,
    country_of_origin VARCHAR(50),
    founded_year INT,
    INDEX idx_brand_name (brand_name)
);

-- Vehicle Models table
CREATE TABLE vehicle_models (
    model_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    generation VARCHAR(20),
    production_years VARCHAR(20),
    body_type VARCHAR(30),
    FOREIGN KEY (brand_id) REFERENCES vehicle_brands(brand_id) ON DELETE CASCADE,
    INDEX idx_brand_model (brand_id, model_name),
    INDEX idx_model_name (model_name)
);

-- Part Categories table
CREATE TABLE part_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES part_categories(category_id) ON DELETE SET NULL,
    INDEX idx_category_name (category_name),
    INDEX idx_parent_category (parent_category_id)
);

-- Parts table
CREATE TABLE parts (
    part_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT NOT NULL,
    category_id INT NOT NULL,
    part_name VARCHAR(255) NOT NULL,
    part_number VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    part_status ENUM('active', 'inactive', 'out_of_stock') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES part_categories(category_id) ON DELETE RESTRICT,
    INDEX idx_seller_id (seller_id),
    INDEX idx_category_id (category_id),
    INDEX idx_part_name (part_name),
    INDEX idx_part_status (part_status),
    INDEX idx_price (unit_price),
    CHECK (unit_price > 0),
    CHECK (stock_quantity >= 0)
);

-- Compatibility table (Updated)
CREATE TABLE compatibility (
    compatibility_id INT PRIMARY KEY AUTO_INCREMENT,
    part_id INT NOT NULL,
    brand_id INT NOT NULL,
    model_id INT NOT NULL,
    year_from INT,
    year_to INT,
    engine_types VARCHAR(255),
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES vehicle_brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (model_id) REFERENCES vehicle_models(model_id) ON DELETE CASCADE,
    INDEX idx_part_id (part_id),
    INDEX idx_brand_model (brand_id, model_id),
    INDEX idx_years (year_from, year_to)
);

-- Part Images table (Updated)
CREATE TABLE part_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    part_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    image_order INT DEFAULT 0,
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE,
    INDEX idx_part_id (part_id),
    INDEX idx_is_primary (is_primary)
);

-- Addresses table
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_type ENUM('shipping', 'billing') NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100),
    open_address VARCHAR(255) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_address_type (address_type),
    INDEX idx_is_default (is_default)
);

-- Carts table
CREATE TABLE carts (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    cart_status ENUM('active', 'abandoned', 'checked_out') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_cart_status (cart_status)
);

-- Cart Items table
CREATE TABLE cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price_snapshot DECIMAL(10,2) NOT NULL,
    vehicle_id INT,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES customer_vehicles(vehicle_id) ON DELETE SET NULL,
    INDEX idx_cart_id (cart_id),
    INDEX idx_part_id (part_id),
    INDEX idx_vehicle_id (vehicle_id),
    CHECK (quantity > 0)
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    final_amount DECIMAL(10,2) NOT NULL,
    order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_user_id (user_id),
    INDEX idx_order_date (order_date),
    INDEX idx_order_status (order_status),
    CHECK (total_amount > 0),
    CHECK (final_amount > 0)
);

-- Archive Orders table (for historical records)
-- Same columns as orders + archived_at
CREATE TABLE archive_orders (
    order_id INT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    final_amount DECIMAL(10,2) NOT NULL,
    order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL,
    order_date TIMESTAMP NOT NULL,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_order_date (order_date),
    INDEX idx_order_status (order_status)
);


-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    part_id INT NOT NULL,
    seller_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    item_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts(part_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    INDEX idx_order_id (order_id),
    INDEX idx_part_id (part_id),
    INDEX idx_seller_id (seller_id),
    CHECK (quantity > 0),
    CHECK (unit_price > 0),
    CHECK (item_total > 0)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('completed', 'pending', 'failed') DEFAULT 'pending',
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    INDEX idx_order_id (order_id),
    INDEX idx_status (status),
    INDEX idx_transaction_id (transaction_id),
    CHECK (amount > 0)
);

-- Reviews table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    part_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    fitment_rating INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_part_id (part_id),
    INDEX idx_rating (rating),
    CHECK (rating >= 1 AND rating <= 5),
    CHECK (fitment_rating >= 1 AND fitment_rating <= 5)
);

-- Wishlists table
CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    part_id INT NOT NULL,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_part_id (part_id)
);
