/*
	1)	Составьте список пользователей users, которые осуществили 
		хотя бы один заказ orders в интернет магазине.
	2)	Выведите список товаров products и разделов catalogs, 
		который соответствует товару.
	3)	(по желанию) Пусть имеется таблица рейсов flights (id, from, to) 
		и таблица городов cities (label, name). Поля from, to и label 
		содержат английские названия городов, поле name — русское. 
		Выведите список рейсов flights с русскими названиями городов.
*/


USE shop;


-- 1.
SELECT * FROM users u
	WHERE EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.id);


-- 2.
SELECT
	p.name,
	p.description,
	p.price,
	c.name
FROM
	products p
JOIN
	catalogs c
ON
	p.catalog_id = c.id;


-- 3.
SELECT
	id,
-- 	f.`from`,
-- 	f.`to`,
	c1.name AS из,
	c2.name AS в
FROM
	flights f
JOIN
	cities c1
ON
	f.`from` = c1.label
JOIN
	cities c2
ON
	f.`to` = c2.label
ORDER BY id;