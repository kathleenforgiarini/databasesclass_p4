-- Project 4

SPOOL C:\BD2\Project4.txt
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS') FROM dual;

-- Q1
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE compare_numbers (p_num1 IN NUMBER, p_num2 IN NUMBER,
  p_result OUT VARCHAR2) AS
BEGIN
  IF p_num1 = p_num2 THEN
    p_result := 'EQUAL';
  ELSE
    p_result := 'DIFFERENT';
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE L4Q1 (p_length IN NUMBER, p_width IN NUMBER) AS
  v_result VARCHAR2(20);
  v_area NUMBER;
  v_perimeter NUMBER;
BEGIN
  v_area := p_length * p_width;
  v_perimeter := 2 * (p_length + p_width);
  
  compare_numbers(p_length, p_width, v_result);
  
  IF v_result = 'EQUAL' THEN
    DBMS_OUTPUT.PUT_LINE('The area of a square size ' || p_length || ' by ' || p_width || ' is ' || v_area || '. It`s perimeter is ' || v_perimeter || '.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || p_length || ' by ' || p_width || ' is ' || v_area || '. It`s perimeter is ' || v_perimeter || '.');
  END IF;
END;
/

EXEC L4Q1(2,2)
EXEC L4Q1(2,3)
EXEC L4Q1(5,4)


-- Q2

CREATE OR REPLACE PROCEDURE pseudo_fun (in_height IN NUMBER, in_width IN NUMBER, 
out_result_area OUT NUMBER, out_result_perimeter OUT NUMBER) AS
BEGIN
  out_result_area := in_height * in_width;
  out_result_perimeter := 2 * (in_height + in_width);
END;
/

CREATE OR REPLACE PROCEDURE L4Q2 (p_height NUMBER, p_width NUMBER) AS
  v_area NUMBER;
  v_perimeter NUMBER;
BEGIN
  pseudo_fun(p_height, p_width, v_area, v_perimeter);
  
  IF p_height = p_width THEN
    DBMS_OUTPUT.PUT_LINE('The area of a square size ' || p_height || ' by ' || p_width || ' is ' || v_area || '. It`s perimeter is ' || v_perimeter || '.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || p_height || ' by ' || p_width || ' is ' || v_area || '. It`s perimeter is ' || v_perimeter || '.');
  END IF;
END;
/

EXEC L4Q2(2,2)
EXEC L4Q2(2,3)
EXEC L4Q2(5,4)


-- Q3

CREATE OR REPLACE PROCEDURE update_price (p_inv_id NUMBER, p_percent_increase NUMBER, new_price OUT NUMBER, new_qoh OUT NUMBER)
AS
BEGIN
    UPDATE inventory
    SET inv_price = inv_price * (1 + p_percent_increase / 100)
    WHERE inv_id = p_inv_id;

    
    SELECT inv_price, inv_qoh
    INTO new_price, new_qoh
    FROM inventory
    WHERE inv_id = p_inv_id;
    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Inventory number '|| p_inv_id || ' does not exist!');

END;
/

CREATE OR REPLACE PROCEDURE L4Q3 (p_inv_id NUMBER, p_percent_increase NUMBER)
IS
    l_price NUMBER;
    l_quantity NUMBER;
    l_value NUMBER;
BEGIN
    update_price(p_inv_id, p_percent_increase, l_price, l_quantity);
    l_value := l_price * l_quantity;

    DBMS_OUTPUT.PUT_LINE('The new value of the inventory is: ' || l_value);
    
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Inventory number '|| p_inv_id || ' does not exist!');

END;
/

EXEC L4Q3 (1,10)

SPOOL OFF;