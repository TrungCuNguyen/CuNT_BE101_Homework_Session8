CREATE TABLE inventory
(
    product_id   SERIAL PRIMARY key,
    product_name VARCHAR(100),
    quantity     INT
);

INSERT INTO inventory (product_name, quantity)
VALUES ('Laptop Dell Inspiron', 15),
       ('Chuột Logitech M185', 50),
       ('Bàn phím cơ Keychron K2', 20),
       ('Màn hình Samsung 24 inch', 12),
       ('Tai nghe Sony WH-1000XM4', 8),
       ('Ổ cứng SSD Samsung 1TB', 25),
       ('Điện thoại iPhone 14', 10),
       ('Máy in Canon LBP2900', 5),
       ('Loa Bluetooth JBL Flip 6', 18),
       ('USB Kingston 32GB', 100);


-- Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
--  Kiểm tra xem sản phẩm có đủ hàng không
--  Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’
CREATE OR REPLACE PROCEDURE check_stock(
    p_id INT,
    p_qty INT
)
    language plpgsql
AS
$$
DECLARE
    v_quantity INT;
BEGIN
    SELECT quantity
    INTO v_quantity
    FROM inventory
    WHERE p_id = product_id;
    IF v_quantity < p_qty THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    ELSE
        RAISE NOTICE 'Đủ hàng trong kho';
    END IF;
END;
$$;

-- Gọi Procedure với các trường hợp:
--  Một sản phẩm có đủ hàng
--  Một sản phẩm không đủ hàng
DO
$$
    BEGIN
        CALL check_stock(2, 10);
        CALL check_stock(1, 20);
    END;
$$

