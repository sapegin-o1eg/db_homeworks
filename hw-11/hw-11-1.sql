/*
	Практическое задание по теме “Оптимизация запросов”

	1)	Создайте таблицу logs типа Archive. Пусть при каждом 
		создании записи в таблицах users, catalogs и products в 
		таблицу logs помещается время и дата создания записи, 
		название таблицы, идентификатор первичного ключа и 
		содержимое поля name.
	2)	(по желанию) Создайте SQL-запрос, который помещает 
		в таблицу users миллион записей.

*/


-- 1.
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	`id` SERIAL,
	`datetime` DATETIME,
	`tbl_name` VARCHAR(100),
	`pk_id` BIGINT UNSIGNED,
	`name` VARCHAR(255)
) ENGINE = ARCHIVE;

DELIMITER $$
DROP TRIGGER IF EXISTS tr_log_users_ins$$
CREATE TRIGGER tr_log_users_ins AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs VALUES (
		NULL,
		COALESCE(NEW.created_at,CURRENT_TIMESTAMP),
		'users',
		NEW.id,
		NEW.name);
END$$

DROP TRIGGER IF EXISTS tr_log_catalogs_ins$$
CREATE TRIGGER tr_log_catalogs_ins AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs VALUES (
		NULL,
		CURRENT_TIMESTAMP,
		'catalogs',
		NEW.id,
		NEW.name);
END$$

DROP TRIGGER IF EXISTS tr_log_products_ins$$
CREATE TRIGGER tr_log_products_ins AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO shop.logs VALUES (
		NULL,
		COALESCE(NEW.created_at, CURRENT_TIMESTAMP),
		'products',
		NEW.id,
		NEW.name);
END$$
DELIMITER ;


-- 2.
-- медленный вариант
DELIMITER $$
DROP PROCEDURE IF EXISTS proc_ins_n_rows$$
CREATE PROCEDURE proc_ins_n_rows (n INT UNSIGNED)
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < n DO
		INSERT INTO users (name, birthday_at) VALUES
			(CONCAT('user_', i), (NOW() - INTERVAL i DAY));
		SET i = i + 1;
	END WHILE;
END $$
DELIMITER ;

CALL proc_ins_n_rows(1000000);


-- более быстрый вариант
INSERT INTO users (name, birthday_at)
SELECT CONCAT('user_', N), NOW() - INTERVAL N HOUR
  FROM
(
select a.N + b.N * 10 + c.N * 100 + d.N * 1000 + e.N * 10000 + f.N * 100000 + 1 N
from (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) a
      , (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) b
      , (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) c
      , (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) d
      , (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) e
      , (select 0 as N union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) f
) t