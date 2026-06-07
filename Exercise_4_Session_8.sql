-- Tạo bảng products bt-4-ss-8
CREATE TABLE products
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(100),
    price            NUMERIC,
    discount_percent INT
);

-- Thêm 10 dữ liệu mẫu
INSERT INTO products (name, price, discount_percent)
VALUES ('Laptop Dell XPS 13', 32000, 10),
       ('Điện thoại Samsung Galaxy S23', 25000, 5),
       ('Tai nghe AirPods Pro', 5500, 15),
       ('Màn hình LG UltraWide 34"', 12000, 20),
       ('Chuột Logitech MX Master 3', 2500, 10),
       ('Bàn phím cơ Razer BlackWidow', 4000, 12),
       ('Loa Bluetooth Bose SoundLink', 6000, 8),
       ('Ổ cứng SSD Crucial 1TB', 3500, 60),
       ('Máy ảnh Canon EOS R6', 45000, 18),
       ('USB SanDisk 64GB', 500, 25);

-- Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC)

CREATE OR REPLACE PROCEDURE calculate_discount(p_id INT, OUT p_final_price NUMERIC)
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_price            NUMERIC;
    v_discount_percent INT;
BEGIN
    SELECT price, discount_percent
    INTO v_price, v_discount_percent
    FROM products
    WHERE p_id = id;

    IF v_discount_percent > 50 THEN
        v_discount_percent := 50;
    END IF;

    p_final_price = v_price - (v_price * v_discount_percent / 100);
END;
$$;

-- Gọi thử:
DO
$$
    DECLARE
        p_final_price NUMERIC;
    BEGIN
        CALL calculate_discount(2, p_final_price);
        RAISE NOTICE 'Giá sau khi giảm là: %', p_final_price;
    END;
$$;

-- Cập nhật lại cột price trong bảng products thành giá sau giảm
DO
$$
    DECLARE
        p_final_price NUMERIC;
        v_item        RECORD;
    BEGIN

        FOR v_item IN SELECT id, price FROM products
            LOOP
                CALL calculate_discount(v_item.id, p_final_price);
                UPDATE products
                SET price = p_final_price
                WHERE v_item.id = id;
            END LOOP;
    END;
$$;
