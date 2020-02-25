/* Задача 4
i.		Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
ii.		Написать скрипт, возвращающий список имен (только firstname) пользователей 
		без повторений в алфавитном порядке
iii.	Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных 
	 	(поле is_active = false). Предварительно добавить такое поле в таблицу profiles 
	 	со значением по умолчанию = true (или 1)
iv. 	Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
v. 		Написать название темы курсового проекта (в комментарии)
*/


USE vk;
-- i.
-- дамп БД vk с заполненными данными сохранен в файле vk.sql


-- ii.
SELECT DISTINCT firstname as fn FROM users ORDER BY fn ASC;
SELECT DISTINCT firstname FROM users;


-- iii.
ALTER TABLE profiles ADD is_active BIT DEFAULT 1 NOT NULL;
UPDATE profiles SET is_active=0 WHERE (birthday + INTERVAL 18 YEAR) >= NOW();


-- iv.
-- UPDATE messages SET created_at = created_at + INTERVAL 1000 YEAR WHERE id <= 100;
DELETE FROM messages WHERE created_at > NOW();


-- v.
-- БД для профессиональной социальной сети для установления деловых контактов