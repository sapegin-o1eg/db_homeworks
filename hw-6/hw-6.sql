/*
	1)	Пусть задан некоторый пользователь. Из всех друзей этого пользователя
		найдите человека, который больше всех общался с нашим пользователем.
	2)	Подсчитать общее количество лайков, которые получили пользователи
		младше 10 лет..
	3)	Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/

USE vk;


-- 1.
SELECT
	(SELECT CONCAT_WS(' ', firstname, lastname) FROM users WHERE id = msg.friend) AS friend, COUNT(*) AS messages_cnt
FROM (
	SELECT
		to_user_id AS friend
	FROM
		messages
	WHERE
		(from_user_id = 1 AND to_user_id IN (
			SELECT target_user_id AS friends FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved'
			UNION
			SELECT initiator_user_id AS friends FROM friend_requests WHERE target_user_id = 1 AND status = 'approved'
		))
	UNION ALL
	SELECT
		from_user_id AS friend
	FROM
		messages
	WHERE
		(to_user_id = 1 AND from_user_id IN (
			SELECT target_user_id AS friends FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved'
			UNION
			SELECT initiator_user_id AS friends FROM friend_requests WHERE target_user_id = 1 AND status = 'approved'
		))
) AS msg
GROUP BY msg.friend
ORDER BY messages_cnt DESC
LIMIT 1;


-- 2.
SELECT
	COUNT(*) AS lt_10_years_likes
FROM
	likes
WHERE user_id IN (
	SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(year, birthday, NOW()) < 10 
);


-- 3.
SELECT 
	CASE (gender)
		WHEN 'f' THEN 'Больше всего лайков поставили женщины'
		WHEN 'm' THEN 'Больше всего лайков поставили мужчины'
		ELSE 'something wrong...'
	END AS likes
FROM (
		SELECT
			(SELECT gender FROM profiles p WHERE p.user_id = l.user_id ) AS gender
		FROM
			likes l
		GROUP BY gender
		ORDER BY COUNT(*) DESC
		LIMIT 1
) AS gender;

-- SELECT
-- 	(SELECT gender FROM profiles p WHERE p.user_id = l.user_id ) AS gender,
-- 	COUNT(*) AS cnt
-- FROM
-- 	likes l
-- GROUP BY gender
-- ORDER BY cnt DESC;

-- SELECT
-- 	(SELECT gender FROM profiles p WHERE p.user_id = l.user_id ) AS gender
-- FROM
-- 	likes l
-- GROUP BY gender
-- ORDER BY COUNT(*) DESC
-- LIMIT 1;


