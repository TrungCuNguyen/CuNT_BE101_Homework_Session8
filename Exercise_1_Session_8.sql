CREATE TABLE oder_detail
(
    id           SERIAL PRIMARY KEY,
    order_id     INT,
    product_name VARCHAR(100),
    quantity     INT,
    unit_price   NUMERIC
);

INSERT INTO oder_detail (order_id, product_name, quantity, unit_price)
VALUES (101, 'Điện thoại iPhone 15', 1, 25000000.00),
       (101, 'Bàn phím cơ AKKO', 1, 1500000.00),
       (102, 'Laptop Asus Zenbook', 1, 21500000.00),
       (103, 'Chuột Logitech G Pro', 2, 2300000.00),
       (104, 'Áo thun Local Brand', 3, 350000.00),
       (104, 'Quần Jean Slimfit', 1, 550000.00),
       (105, 'Giày Thể Thao Nike', 1, 3200000.00),
       (106, 'Sách Thao Túng Tâm Lý', 5, 120000.00),
       (107, 'Bình giữ nhiệt Lock&Lock', 2, 450000.00),
       (108, 'Tai nghe Sony WH-1000XM5', 1, 6800000.00);

CREATE OR REPLACE PROCEDURE calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC
)
    language plpgsql
AS
$$
BEGIN
    SELECT quantity * unit_price
    INTO total
    FROM oder_detail
    WHERE order_id = order_id_input;
END;
$$;

DO
$$
    DECLARE
        v_order_id INT;
        v_total    NUMERIC;
    BEGIN
        v_order_id := 101;
        CALL calculate_order_total(v_order_id, v_total);
        RAISE NOTICE 'tổng giá trị đơn hàng theo mã đơn hàng % là: %',v_order_id, v_total;
    END;
$$