/*
	Практическое задание по теме “Хранимые процедуры и функции, триггеры"
	
	1)	Создайте хранимую функцию hello(), которая будет возвращать 
		приветствие, в зависимости от текущего времени суток. С 6:00 
		до 12:00 функция должна возвращать фразу "Доброе утро", 
		с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
		с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
	2)	В таблице products есть два текстовых поля: name с названием 
		товара и description с его описанием. Допустимо присутствие 
		обоих полей или одно из них. Ситуация, когда оба поля 
		принимают неопределенное значение NULL неприемлема. Используя 
		триггеры, добейтесь того, чтобы одно из этих полей или оба поля 
		были заполнены. При попытке присвоить полям NULL-значение 
		необходимо отменить операцию.
	3)	(по желанию) Напишите хранимую функцию для вычисления 
		произвольного числа Фибоначчи. Числами Фибоначчи называется 
		последовательность в которой число равно сумме двух предыдущих 
		чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
 */


-- 1.
-- ЕСЛИ MySQL 8 И SQL Error [1418] [HY000]
-- SET GLOBAL log_bin_trust_function_creators = 1; 
DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS VARCHAR(255) NOT DETERMINISTIC
BEGIN
	DECLARE curr_time TEXT;
	
	SET curr_time = CURRENT_TIME();
	
	IF(curr_time >= '06:00:00' AND curr_time <= '11:59:59') THEN
		RETURN 'Доброе утро';
	ELSEIF (curr_time >= '12:00:00' AND curr_time <= '17:59:59') THEN
		RETURN 'Добрый день';
  	ELSEIF (curr_time >= '18:00:00' AND curr_time <= '23:59:59') THEN
		RETURN 'Добрый вечер';
  	ELSE
		RETURN 'Доброй ночи';
  	END IF;
END
DELIMITER ;


-- 2.
DELIMITER //
DROP TRIGGER IF EXISTS check_prod_ins//
CREATE TRIGGER check_prod_ins BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET 
		MESSAGE_TEXT = "Insert canceled. Name or description must be defined";
	END IF;
END//

DROP TRIGGER IF EXISTS check_prod_upd//
CREATE TRIGGER check_prod_upd BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
		SET NEW.name = COALESCE(NEW.name,
								OLD.name);
		SET NEW.description = COALESCE(OLD.description,
										NEW.description);
	
-- 		SIGNAL SQLSTATE '45000' SET 
-- 		MESSAGE_TEXT = "Update canceled. Name or description must be defined";
	END IF;
END//
DELIMITER ;


-- 3.
DELIMITER //
DROP FUNCTION IF EXISTS fibonacci//
CREATE FUNCTION fibonacci (n INT)
RETURNS BIGINT DETERMINISTIC
BEGIN
	DECLARE i INT DEFAULT 2;
	DECLARE a, b BIGINT;
	DECLARE value BIGINT DEFAULT 0;

	SET a = 1;
	SET b = 1;
	
	IF (n < 0 ) THEN
		SIGNAL SQLSTATE '45000' SET 
		MESSAGE_TEXT = "Аргумент должен быть >= 0";
	ELSEIF (n = 0) THEN
		RETURN 0;
	ELSEIF (n = 1 OR n = 2) THEN
		RETURN 1;
	ELSE
		cycle: WHILE i < n DO
			SET value = a + b;
			SET a = b;
			SET b = value;
			SET i = i + 1;
		END WHILE cycle;
	
		RETURN value;
	END IF;
END
DELIMITER ;

-- SELECT fibonacci(90);
