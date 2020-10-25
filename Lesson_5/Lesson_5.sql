use shop;
show tables;
SELECT * FROM users;

-- Операторы, фильтрация, сортировка и ограничение

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users SET created_at = NOW(), updated_at = NOW();

SELECT * FROM users u;

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;

SELECT * FROM users;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
SELECT * FROM storehouses_products ;
SELECT * FROM storehouses;
SELECT * FROM products;
INSERT INTO storehouses (name, created_at, updated_at) values ('Деброва', NOW(),NOW()), 
('Пушкинская', NOW(),NOW()),('Невская', NOW(),NOW()),('Елизаровская', NOW(),NOW()),('Купчино', NOW(),NOW());

INSERT INTO storehouses_products (storehouse_id,product_id,value,created_at,updated_at) 
VALUES (1,2,2500,NOW(),NOW()), (3,4,500,NOW(),NOW()),(5,7,30,NOW(),NOW()),(3,1,1,NOW(),NOW()),(3,3,0,NOW(),NOW()), (3,6,0,NOW(),NOW())

SELECT value from storehouses_products ORDER BY CASE 
	WHEN value > 0
	THEN value
	ELSE 10000000000000000000000000000000000000000000000000000000000
	END;
	

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)
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

-- 5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
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
		
-- Агрегация данных

-- 1. Подсчитайте средний возраст пользователей в таблице users.
SELECT
    ROUND(AVG(
    (YEAR(CURRENT_DATE) - YEAR(birthday_at)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d'))
  )) AS age
FROM users;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT
	DAYOFWEEK( (DATE_FORMAT(DATE_ADD(birthday_at, INTERVAL (YEAR(CURRENT_DATE()) - YEAR(birthday_at)) YEAR), '%Y-%m-%d'))) AS weekday_of_birthday,
	COUNT(1)
FROM users
	GROUP BY weekday_of_birthday;
	
SELECT * FROM users;

-- 3. Подсчитайте произведение чисел в столбце таблицы.

SELECT exp(SUM(log(id))) FROM products;

-- http://www.sql-tutorial.ru/ru/book_product_of_column_values.html Взял за пример решение отсюда, пора вспоминать школьную математику)