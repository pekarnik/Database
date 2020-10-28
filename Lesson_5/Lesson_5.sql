use shop;
show tables;
SELECT * FROM users;

-- ���������, ����������, ���������� � �����������

-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
UPDATE users SET created_at = NOW(), updated_at = NOW();

SELECT * FROM users u;

-- 2. ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. 
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;

SELECT * FROM users;

-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
-- ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. ������ ������� ������ ������ ���������� � �����, ����� ���� �������.
SELECT * FROM storehouses_products ;
SELECT * FROM storehouses;
SELECT * FROM products;
INSERT INTO storehouses (name, created_at, updated_at) values ('�������', NOW(),NOW()), 
('����������', NOW(),NOW()),('�������', NOW(),NOW()),('������������', NOW(),NOW()),('�������', NOW(),NOW());

INSERT INTO storehouses_products (storehouse_id,product_id,value,created_at,updated_at) 
VALUES (1,2,2500,NOW(),NOW()), (3,4,500,NOW(),NOW()),(5,7,30,NOW(),NOW()),(3,1,1,NOW(),NOW()),(3,3,0,NOW(),NOW()), (3,6,0,NOW(),NOW())

SELECT value from storehouses_products ORDER BY CASE 
	WHEN value > 0
	THEN value
	ELSE 10000000000000000000000000000000000000000000000000000000000
	END;
	

-- 4. (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� (may, august)
SELECT * FROM users;
SELECT 
	name, 
	CASE 
		WHEN MONTH(birthday_at) = 5
		THEN 'may'
		WHEN MONTH(birthday_at) = 8
		THEN 'august'
	END 
FROM 
	users
WHERE MONTH(birthday_at) IN(5, 8);

-- 5. �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.
SELECT * FROM catalogs WHERE id IN (5,1,2)
	ORDER BY 
		CASE
			WHEN id = 5
				THEN 0
			WHEN id = 1
				THEN 1
			WHEN id = 2
				THEN 2
		END;
		
-- ��������� ������

-- 1. ����������� ������� ������� ������������� � ������� users.
SELECT
    ROUND(AVG(
    (YEAR(CURRENT_DATE) - YEAR(birthday_at)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d'))
  )) AS age
FROM users;

-- 2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.

SELECT
	DAYOFWEEK( (DATE_FORMAT(DATE_ADD(birthday_at, INTERVAL (YEAR(CURRENT_DATE()) - YEAR(birthday_at)) YEAR), '%Y-%m-%d'))) AS weekday_of_birthday,
	COUNT(1)
FROM users
	GROUP BY weekday_of_birthday;
	
SELECT * FROM users;

-- 3. ����������� ������������ ����� � ������� �������.

SELECT exp(SUM(log(id))) FROM products;

-- http://www.sql-tutorial.ru/ru/book_product_of_column_values.html ���� �� ������ ������� ������, ���� ���������� �������� ����������)