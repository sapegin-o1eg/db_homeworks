/*
1)	Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
	Заполните их текущими датой и временем.

2)	Таблица users была неудачно спроектирована. Записи created_at и updated_at 
	были заданы типом VARCHAR и в них долгое время помещались значения в формате 
	"20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив 
	введеные ранее значения.

3)	В таблице складских запасов storehouses_products в поле value могут встречаться 
	самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются 
	запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в 
	порядке увеличения значения value. Однако, нулевые запасы должны выводиться в 
	конце, после всех записей.
	
4)	(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в 
	августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

5)	(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
	SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, 
	заданном в списке IN.
*/


USE shop;


-- 1.
UPDATE
	users
SET
	created_at = NOW(),
	updated_at = NOW()
WHERE
	created_at IS NULL
	OR updated_at IS NULL;
	

-- 2.
-- преобразуем строку
UPDATE 
	users
SET
	created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i"),
	updated_at = STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i");
	
-- преобразуем тип данных
ALTER TABLE
	users
CHANGE
	created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE
	users
CHANGE
	updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
	

-- 3.
SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;


-- 4.
SELECT
	name
FROM
	users
WHERE
	DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');


-- 5.
SELECT
	*	
FROM
	catalogs
WHERE
	id IN (5, 1, 2)
ORDER BY
	FIELD(id, 5, 1, 2);
