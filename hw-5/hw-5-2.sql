/*
1)	Подсчитайте средний возраст пользователей в таблице users

2)	Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
	Следует учесть, что необходимы дни недели текущего года, а не года рождения.

3)	(по желанию) Подсчитайте произведение чисел в столбце таблицы
*/


USE shop;


-- 1.
SELECT
	AVG(TIMESTAMPDIFF(year, birthday_at, NOw())) AS age
FROM
	users;
	

-- 2.
SELECT
	DATE_FORMAT(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)), '%W') AS day,
	COUNT(*) AS total
FROM
	users
GROUP BY
	day
ORDER BY
	total DESC;


-- 3.
SELECT
	ROUND(EXP(SUM(LN(id)))) AS product
FROM
	catalogs;