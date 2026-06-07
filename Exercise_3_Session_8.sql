-- Tạo bảng employees bt-3-ss-8
CREATE TABLE employees
(
    emp_id    SERIAL PRIMARY KEY,
    emp_name  VARCHAR(100),
    job_level INT,
    salary    NUMERIC
);

-- Thêm 10 dữ liệu mẫu
INSERT INTO employees (emp_name, job_level, salary)
VALUES ('Nguyen Van A', 1, 500),
       ('Tran Thi B', 2, 1200),
       ('Le Van C', 3, 2500),
       ('Pham Thi D', 1, 600),
       ('Hoang Van E', 3, 4000),
       ('Do Thi F', 2, 1500),
       ('Vu Van G', 3, 2800),
       ('Dang Thi H', 3, 6000),
       ('Nguyen Van I', 2, 1300),
       ('Tran Thi J', 1, 550);

-- Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
CREATE OR REPLACE PROCEDURE adjust_salary(
    p_emp_id INT,
    OUT p_new_salary NUMERIC
)
    language plpgsql
AS
$$
DECLARE
    v_salary    NUMERIC;
    v_job_level INT;
BEGIN
    SELECT salary, job_level
    INTO v_salary, v_job_level
    FROM employees
    WHERE p_emp_id = emp_id;

    IF v_job_level = 1 THEN
        UPDATE employees
        SET salary = 1.05 * salary
        WHERE p_emp_id = emp_id;
        p_new_salary := 1.05 * v_salary;
    ELSIF v_job_level = 2 THEN
        UPDATE employees
        SET salary = 1.1 * salary
        WHERE p_emp_id = emp_id;
        p_new_salary := 1.1 * v_salary;
    ELSIF v_job_level = 3 THEN
        UPDATE employees
        SET salary = 1.15 * salary
        WHERE p_emp_id = emp_id;
        p_new_salary := 1.15 * v_salary;
    END IF;
END;
$$;

DO
$$
    DECLARE
        p_new_salary NUMERIC;
    BEGIN

        CALL adjust_salary(3, p_new_salary);
        RAISE NOTICE 'new salary: %', p_new_salary;
        -- Không dùng được lệnh SELECT p_new_salary
    END;
$$

