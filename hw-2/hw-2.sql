/* Задача 2
Написать крипт, добавляющий в БД vk, которую создали на занятии,
3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/

USE vk;


DROP TABLE IF EXISTS `auth_history`;
CREATE TABLE `auth_history` (
	user_id BIGINT UNSIGNED NOT NULL,
	ipaddr INT UNSIGNED NOT NULL,
	`status` ENUM('login', 'logout', 'fail'),
	event_date DATETIME DEFAULT NOW(),
  
	INDEX user_id_idx(user_id),
	INDEX auth_date_idx(event_date),
	PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'История аутентификаций';

DROP TABLE IF EXISTS `user_ban`;
CREATE TABLE `user_ban` (
	user_id BIGINT UNSIGNED NOT NULL,
	banned_id BIGINT UNSIGNED NOT NULL,
	
	PRIMARY KEY(user_id, banned_id),
	FOREIGN KEY(user_id) REFERENCES users(id),
	FOREIGN KEY(banned_id) REFERENCES users(id)
) COMMENT 'Пользовательские баны|добавить в черный список';

DROP TABLE IF EXISTS `wallet`;
CREATE TABLE `wallet` (
	user_id BIGINT UNSIGNED NOT NULL,
	balance DECIMAL(13,2),
	
	PRIMARY KEY(user_id),
	FOREIGN KEY(user_id) REFERENCES users(id)
) COMMENT 'Пользовательские кошельки - баланс';

DROP TABLE IF EXISTS `user_transactions`;
CREATE TABLE `user_transactions` (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	value DECIMAL(13,2) COMMENT 'Сумма',
	`type` ENUM('request', 'transfer') COMMENT 'Два типа операций - запросить и перевести средства',
	comment TEXT COMMENT 'Комментарий к транзакции',
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	
	INDEX (from_user_id),
	INDEX (to_user_id),
	FOREIGN KEY(from_user_id) REFERENCES users(id),
	FOREIGN KEY(to_user_id) REFERENCES users(id)
) COMMENT 'История пользовательских транзакций';