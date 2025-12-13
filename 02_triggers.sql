-- 02_triggers.sql
USE auto_parts_ecommerce;


-- Re-runnable: drop triggers if they already exist
SET @OLD_SQL_NOTES = @@SQL_NOTES;
SET SQL_NOTES = 0;
DROP TRIGGER IF EXISTS check_stock_before_cart_insert;
DROP TRIGGER IF EXISTS check_stock_before_cart_update;
DROP TRIGGER IF EXISTS generate_order_number;
DROP TRIGGER IF EXISTS restore_stock_on_order_cancellation;
DROP TRIGGER IF EXISTS update_stock_after_order;
DROP TRIGGER IF EXISTS validate_vehicle_year_before_insert;
DROP TRIGGER IF EXISTS validate_vehicle_year_before_update;
SET SQL_NOTES = @OLD_SQL_NOTES;


-- Stock control trigger
DELIMITER $$

CREATE TRIGGER check_stock_before_cart_insert
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    DECLARE part_status VARCHAR(20);

    SELECT stock_quantity, part_status INTO available_stock, part_status
    FROM parts
    WHERE part_id = NEW.part_id;

    IF part_status != 'active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This part is not available for purchase';
    END IF;

    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this part';
    END IF;

    -- Capture current price from parts table
    SET NEW.unit_price_snapshot = (
        SELECT unit_price FROM parts WHERE part_id = NEW.part_id
    );
END$$

DELIMITER ;

-- Stock update trigger after order
DELIMITER $$

CREATE TRIGGER update_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE parts
    SET stock_quantity = stock_quantity - NEW.quantity,
        part_status = CASE 
            WHEN (stock_quantity - NEW.quantity) <= 0 THEN 'out_of_stock'
            ELSE 'active'
        END
    WHERE part_id = NEW.part_id;
END$$

DELIMITER ;

-- Order cancellation trigger (restore stock)
DELIMITER $$

CREATE TRIGGER restore_stock_on_order_cancellation
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status != 'cancelled' AND NEW.order_status = 'cancelled' THEN
        UPDATE parts p
        JOIN order_items oi ON p.part_id = oi.part_id
        SET p.stock_quantity = p.stock_quantity + oi.quantity,
            p.part_status = 'active'
        WHERE oi.order_id = NEW.order_id;
    END IF;
END$$

DELIMITER ;

-- Generate order number trigger (Updated for ORD-YYYY-NNNN format)
DELIMITER $$

CREATE TRIGGER generate_order_number
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE next_seq INT;

    IF NEW.order_date IS NULL THEN
        SET NEW.order_date = CURRENT_TIMESTAMP;
    END IF;

IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        SELECT COALESCE(MAX(SUBSTRING(order_number, 10)), 0) + 1 INTO next_seq
        FROM orders
        WHERE order_number LIKE CONCAT('ORD-', YEAR(NEW.order_date), '-%');

        IF next_seq IS NULL THEN
            SET next_seq = 1;
        END IF;

        SET NEW.order_number = CONCAT('ORD-', YEAR(NEW.order_date), '-', LPAD(next_seq, 4, '0'));
    END IF;
END$$

DELIMITER ;
-- Vehicle year validation (MySQL CHECK cannot use CURDATE() in some versions; enforce via triggers)
DELIMITER $$

CREATE TRIGGER validate_vehicle_year_before_insert
BEFORE INSERT ON customer_vehicles
FOR EACH ROW
BEGIN
    IF NEW.year < 1900 OR NEW.year > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle year is out of allowed range';
    END IF;
END$$

CREATE TRIGGER validate_vehicle_year_before_update
BEFORE UPDATE ON customer_vehicles
FOR EACH ROW
BEGIN
    IF NEW.year < 1900 OR NEW.year > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle year is out of allowed range';
    END IF;
END$$

DELIMITER ;

-- Prevent cart quantity increases beyond stock (update scenario)
DELIMITER $$

CREATE TRIGGER check_stock_before_cart_update
BEFORE UPDATE ON cart_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    DECLARE part_status VARCHAR(20);

    SELECT stock_quantity, part_status INTO available_stock, part_status
    FROM parts
    WHERE part_id = NEW.part_id;

    IF part_status != 'active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This part is not available for purchase';
    END IF;

    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this part';
    END IF;

    -- keep the original snapshot for audit, do not overwrite it on update
END$$

DELIMITER ;