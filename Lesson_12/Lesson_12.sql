-- CREATE DATABASE wowhead;

USE wowhead;

-- 1. Составить общее текстовое описание БД и решаемых ею задач;

-- БД служит для хранения и обработки данных сайта wowhead.com, явлюящийся базой знаний по игре World of Warcraft.
-- На сайте хранится описание каждой сущности, у которой есть тип, комментарии пользователей, форум и гайды являются отдельными страницами,
-- в базе данных они учитываться не будут. Необходимо создать таблицы пользователей, комментариев, самих сущностей, лайков.

-- 2. минимальное количество таблиц - 10;
-- 3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);

-- Таблица item будет описывать сущность, которой принадлежит страница в базе знаний
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name',
  `item_type_id` int unsigned NOT NULL COMMENT 'Item_type',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  PRIMARY KEY (`id`)
) COMMENT='Items';

-- Таблица item_types описывает типы сущностей.
DROP TABLE IF EXISTS `item_types`;
CREATE TABLE `item_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name',
  PRIMARY KEY (`id`)
) COMMENT='Item_types';

-- Таблица Item_references содержит ссылки на сущности, имеющие отношение к выбранной
-- (например сундук содержит внутри такие-то предметы, подземелье содержит таких-то боссов и т.д.)
DROP TABLE IF EXISTS `item_references`;
CREATE TABLE `item_references` (
  `curr_item_id` int unsigned NOT NULL COMMENT 'curr_id',
  `reference_item_id` int unsigned NOT NULL COMMENT 'ref_id'
) COMMENT='Item_references';

-- Таблица comments создана для комментариев к сущностями, помимо ссылок на оставивших их пользователей она будет хранить дату создания и обновления
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`item_id` int unsigned NOT NULL COMMENT 'item_id',
	`text` text NOT NULL COMMENT 'comment_text',
	`user_id` int unsigned NOT NULL COMMENT 'user_id',
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
  	`updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  	 PRIMARY KEY (`id`)
) COMMENT='comments';

-- Таблица users хранит данные о имеющихся пользователях, на этом сайте у пользователей очень мало данных, таблица профилей создаваться не будет(нет необходимости).
-- Помимо времени создания необходима роль, потому что есть просто пользователи, одобренные пользователи(их комментарии помечаются цветом, означающим что этот пользователь
-- заслужил доверие администрации), модератор(может править и удалять чужие сообщения), а также администратор, обладающий правами создания новых сущностей, бана пользователей,
-- но это будет уже таблица ролей.
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
	`role_id` int unsigned NOT NULL COMMENT 'id',
  	PRIMARY KEY (`id`)
) COMMENT = 'users';

DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE `users_roles`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`name` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name',
  	PRIMARY KEY (`id`)
) COMMENT = 'users_roles';

-- Таблица game_versions хранит данные о версиях игры, это необходимо для комментариев, потому что в разных версиях игры квесты убирались/появлялись, 
-- понять о версии можно будет по дате создания, тоже самое у комментариев.
DROP TABLE IF EXISTS `game_versions`;
CREATE TABLE `game_versions`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`version` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Version_name',
	`start_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'start_time',
	`end_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'end_time',
  	PRIMARY KEY (`id`)
) COMMENT = 'game_versions';

-- Таблица likes хранит лайки к комментариям, тут все проще чем с соцсетями, лайки ставяться только им.
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`user_id` int unsigned NOT NULL COMMENT 'user_id',
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
	`comment_id` int unsigned NOT NULL COMMENT 'comment_id',
  	PRIMARY KEY (`id`)
) COMMENT = 'likes';

-- Таблица media хранит данные о добавленных медиафайлах к сущностям.
DROP TABLE IF EXISTS `media`;
CREATE TABLE `media`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`name` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name',
	`user_id` int unsigned NOT NULL COMMENT 'user_id',
	`item_id` int unsigned NOT NULL COMMENT 'item_id',
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Create time',
	`size` int unsigned NOT NULL COMMENT 'size',
	`media_type_id` int unsigned NOT NULL COMMENT 'size',
  	PRIMARY KEY (`id`)
) COMMENT = 'media';

-- Таблица media хранит данные о добавленных медиафайлах к сущностям.
DROP TABLE IF EXISTS `media_type`;
CREATE TABLE `media_type`(
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	`type` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name',
  	PRIMARY KEY (`id`)
) COMMENT = 'media_type';


ALTER TABLE item
	ADD CONSTRAINT `item_type_id_fk` FOREIGN KEY (item_type_id)
		REFERENCES item_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE item_references
	ADD CONSTRAINT `curr_item_id_fk` FOREIGN KEY (curr_item_id)
		REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `reference_item_id_fk` FOREIGN KEY (reference_item_id)
		REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE comments
	ADD CONSTRAINT `comments_user_id_fk` FOREIGN KEY (user_id)
		REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `comments_item_id_fk` FOREIGN KEY (user_id)
		REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE users
	ADD CONSTRAINT `users_role_id_fk` FOREIGN KEY (role_id)
		REFERENCES users_roles(id) ON UPDATE CASCADE ON DELETE CASCADE;
		
ALTER TABLE likes
	ADD CONSTRAINT `likes_user_id_fk` FOREIGN KEY (user_id)
		REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `likes_comment_id_fk` FOREIGN KEY (comment_id)
		REFERENCES comments(id) ON UPDATE CASCADE ON DELETE CASCADE;
		
ALTER TABLE media
	ADD CONSTRAINT `media_user_id_fk` FOREIGN KEY (user_id)
		REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `media_item_id_fk` FOREIGN KEY (item_id)
		REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `media_type_id_fk` FOREIGN KEY (media_type_id)
		REFERENCES media_type(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- необходимо создать индекс на эти 2 стоблца, потому что частенько необходимо узнать, к какой версии игры оставлен комментарий
ALTER TABLE game_versions ADD UNIQUE(start_at, end_at);

-- думаю ко всем остальным частым запросам достаточно индексов созданных внешними ключами.

-- 4. создать ERDiagram для БД;
-- Task4.png в папке.

-- 5. скрипты наполнения БД данными;
INSERT INTO `users_roles` (`id`, `name`) VALUES (1, 'l');
INSERT INTO `users_roles` (`id`, `name`) VALUES (2, 'p');
INSERT INTO `users_roles` (`id`, `name`) VALUES (3, 'c');
INSERT INTO `users_roles` (`id`, `name`) VALUES (4, 'x');

SELECT * FROM users_roles ur ;

INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (1, '2017-12-01 06:42:53', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (2, '2013-07-04 15:21:58', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (3, '1986-08-09 03:41:29', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (4, '1997-08-24 07:10:30', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (5, '2005-04-18 04:11:36', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (6, '1985-06-04 04:05:22', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (7, '1982-05-15 15:49:06', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (8, '2016-12-20 23:25:51', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (9, '1989-06-03 21:50:40', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (10, '2015-04-14 19:04:13', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (11, '2016-10-28 09:55:10', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (12, '2011-11-26 01:05:19', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (13, '2020-06-22 11:15:55', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (14, '1977-03-07 19:54:38', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (15, '2006-09-04 05:38:16', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (16, '2020-05-22 12:34:05', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (17, '1977-05-28 00:08:43', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (18, '1988-06-15 02:41:44', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (19, '2001-11-01 05:41:18', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (20, '2014-09-27 06:05:21', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (21, '1970-12-30 15:49:08', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (22, '2001-12-08 04:58:04', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (23, '1974-11-16 20:55:40', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (24, '1999-09-25 13:30:30', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (25, '1997-09-23 08:14:36', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (26, '2009-07-11 19:20:36', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (27, '2009-11-02 00:05:27', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (28, '1985-06-28 22:42:14', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (29, '1982-05-26 10:23:21', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (30, '2000-01-08 04:21:34', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (31, '1988-04-20 05:44:17', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (32, '1977-01-07 14:46:21', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (33, '1997-04-07 08:23:27', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (34, '2018-02-12 00:35:24', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (35, '2002-07-03 19:43:57', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (36, '1987-05-16 20:23:24', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (37, '2000-02-01 07:14:30', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (38, '1998-11-27 13:22:15', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (39, '1988-10-09 12:28:31', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (40, '2005-08-26 17:04:11', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (41, '1996-04-26 13:23:10', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (42, '1993-10-16 00:17:18', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (43, '2006-01-18 01:10:26', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (44, '1977-02-10 09:02:48', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (45, '2002-05-01 09:08:07', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (46, '1976-07-03 08:34:13', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (47, '1979-04-16 19:10:45', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (48, '1993-03-21 09:03:01', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (49, '2000-04-09 02:33:08', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (50, '2017-11-17 09:23:03', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (51, '1979-03-06 22:16:56', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (52, '2006-03-04 10:34:26', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (53, '1996-11-11 01:04:16', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (54, '2013-06-25 05:32:31', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (55, '2013-03-05 18:28:03', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (56, '2019-10-07 19:34:22', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (57, '2002-03-22 05:13:36', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (58, '1978-01-10 18:12:38', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (59, '2000-07-27 01:16:48', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (60, '2015-08-29 11:33:55', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (61, '1980-04-26 16:12:44', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (62, '1986-09-14 01:08:49', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (63, '2012-06-17 02:41:44', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (64, '1999-11-26 01:51:17', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (65, '1982-08-10 11:06:42', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (66, '1994-07-06 05:15:39', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (67, '2015-01-04 22:57:28', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (68, '1976-10-26 10:30:31', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (69, '1972-10-06 01:17:42', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (70, '1995-11-13 18:11:32', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (71, '1994-12-26 07:53:24', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (72, '2001-04-20 22:39:42', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (73, '2015-01-05 00:25:26', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (74, '1990-08-27 19:46:26', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (75, '1974-08-21 12:46:42', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (76, '1994-09-30 20:00:15', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (77, '2003-07-21 17:29:07', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (78, '1990-07-03 06:36:28', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (79, '1985-07-06 07:15:22', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (80, '1992-02-06 20:41:40', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (81, '2001-10-27 22:42:33', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (82, '1984-04-26 03:56:06', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (83, '1990-09-06 18:49:28', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (84, '1972-01-13 07:17:32', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (85, '1978-05-06 08:56:21', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (86, '1971-02-26 13:07:31', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (87, '1992-01-16 14:33:25', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (88, '1997-02-19 01:32:05', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (89, '2008-01-20 13:56:21', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (90, '1988-05-04 05:36:06', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (91, '2002-12-18 21:34:52', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (92, '1995-02-01 19:59:28', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (93, '1986-06-04 23:39:44', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (94, '1981-05-17 11:28:52', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (95, '1991-09-11 10:36:58', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (96, '1984-06-05 19:52:00', 4);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (97, '1989-08-28 23:12:35', 1);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (98, '2009-10-20 19:56:44', 2);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (99, '1979-08-16 16:56:06', 3);
INSERT INTO `users` (`id`, `created_at`, `role_id`) VALUES (100, '1985-09-06 17:25:59', 4);

SELECT * FROM users;

INSERT INTO `media_type` (`id`, `type`) VALUES (1, 'molestiae');
INSERT INTO `media_type` (`id`, `type`) VALUES (2, 'veniam');
INSERT INTO `media_type` (`id`, `type`) VALUES (3, 'alias');
INSERT INTO `media_type` (`id`, `type`) VALUES (4, 'praesentium');
INSERT INTO `media_type` (`id`, `type`) VALUES (5, 'enim');
INSERT INTO `media_type` (`id`, `type`) VALUES (6, 'placeat');
INSERT INTO `media_type` (`id`, `type`) VALUES (7, 'omnis');
INSERT INTO `media_type` (`id`, `type`) VALUES (8, 'aut');
INSERT INTO `media_type` (`id`, `type`) VALUES (9, 'dicta');
INSERT INTO `media_type` (`id`, `type`) VALUES (10, 'odit');
INSERT INTO `media_type` (`id`, `type`) VALUES (11, 'nulla');
INSERT INTO `media_type` (`id`, `type`) VALUES (12, 'autem');
INSERT INTO `media_type` (`id`, `type`) VALUES (13, 'laudantium');
INSERT INTO `media_type` (`id`, `type`) VALUES (14, 'dolorem');
INSERT INTO `media_type` (`id`, `type`) VALUES (15, 'et');
INSERT INTO `media_type` (`id`, `type`) VALUES (16, 'ullam');
INSERT INTO `media_type` (`id`, `type`) VALUES (17, 'eveniet');
INSERT INTO `media_type` (`id`, `type`) VALUES (18, 'quo');
INSERT INTO `media_type` (`id`, `type`) VALUES (19, 'magnam');
INSERT INTO `media_type` (`id`, `type`) VALUES (20, 'assumenda');
INSERT INTO `media_type` (`id`, `type`) VALUES (21, 'id');
INSERT INTO `media_type` (`id`, `type`) VALUES (22, 'eius');
INSERT INTO `media_type` (`id`, `type`) VALUES (23, 'ut');
INSERT INTO `media_type` (`id`, `type`) VALUES (24, 'voluptas');
INSERT INTO `media_type` (`id`, `type`) VALUES (25, 'similique');
INSERT INTO `media_type` (`id`, `type`) VALUES (26, 'facere');
INSERT INTO `media_type` (`id`, `type`) VALUES (27, 'itaque');
INSERT INTO `media_type` (`id`, `type`) VALUES (28, 'repellendus');
INSERT INTO `media_type` (`id`, `type`) VALUES (29, 'totam');
INSERT INTO `media_type` (`id`, `type`) VALUES (30, 'qui');
INSERT INTO `media_type` (`id`, `type`) VALUES (31, 'doloribus');
INSERT INTO `media_type` (`id`, `type`) VALUES (32, 'incidunt');
INSERT INTO `media_type` (`id`, `type`) VALUES (33, 'velit');
INSERT INTO `media_type` (`id`, `type`) VALUES (34, 'optio');
INSERT INTO `media_type` (`id`, `type`) VALUES (35, 'adipisci');
INSERT INTO `media_type` (`id`, `type`) VALUES (36, 'nostrum');
INSERT INTO `media_type` (`id`, `type`) VALUES (37, 'natus');
INSERT INTO `media_type` (`id`, `type`) VALUES (38, 'dolor');
INSERT INTO `media_type` (`id`, `type`) VALUES (39, 'est');
INSERT INTO `media_type` (`id`, `type`) VALUES (40, 'eaque');
INSERT INTO `media_type` (`id`, `type`) VALUES (41, 'numquam');
INSERT INTO `media_type` (`id`, `type`) VALUES (42, 'consequatur');
INSERT INTO `media_type` (`id`, `type`) VALUES (43, 'nobis');
INSERT INTO `media_type` (`id`, `type`) VALUES (44, 'ipsa');
INSERT INTO `media_type` (`id`, `type`) VALUES (45, 'quia');
INSERT INTO `media_type` (`id`, `type`) VALUES (46, 'deleniti');
INSERT INTO `media_type` (`id`, `type`) VALUES (47, 'perspiciatis');
INSERT INTO `media_type` (`id`, `type`) VALUES (48, 'harum');
INSERT INTO `media_type` (`id`, `type`) VALUES (49, 'culpa');
INSERT INTO `media_type` (`id`, `type`) VALUES (50, 'libero');
INSERT INTO `media_type` (`id`, `type`) VALUES (51, 'magni');
INSERT INTO `media_type` (`id`, `type`) VALUES (52, 'cum');
INSERT INTO `media_type` (`id`, `type`) VALUES (53, 'error');
INSERT INTO `media_type` (`id`, `type`) VALUES (54, 'explicabo');
INSERT INTO `media_type` (`id`, `type`) VALUES (55, 'vitae');
INSERT INTO `media_type` (`id`, `type`) VALUES (56, 'quis');
INSERT INTO `media_type` (`id`, `type`) VALUES (57, 'in');
INSERT INTO `media_type` (`id`, `type`) VALUES (58, 'doloremque');
INSERT INTO `media_type` (`id`, `type`) VALUES (59, 'odio');
INSERT INTO `media_type` (`id`, `type`) VALUES (60, 'saepe');
INSERT INTO `media_type` (`id`, `type`) VALUES (61, 'rerum');
INSERT INTO `media_type` (`id`, `type`) VALUES (62, 'accusantium');
INSERT INTO `media_type` (`id`, `type`) VALUES (63, 'sunt');
INSERT INTO `media_type` (`id`, `type`) VALUES (64, 'occaecati');
INSERT INTO `media_type` (`id`, `type`) VALUES (65, 'necessitatibus');
INSERT INTO `media_type` (`id`, `type`) VALUES (66, 'voluptatem');
INSERT INTO `media_type` (`id`, `type`) VALUES (67, 'impedit');
INSERT INTO `media_type` (`id`, `type`) VALUES (68, 'voluptatum');
INSERT INTO `media_type` (`id`, `type`) VALUES (69, 'pariatur');
INSERT INTO `media_type` (`id`, `type`) VALUES (70, 'quod');
INSERT INTO `media_type` (`id`, `type`) VALUES (71, 'cupiditate');
INSERT INTO `media_type` (`id`, `type`) VALUES (72, 'temporibus');
INSERT INTO `media_type` (`id`, `type`) VALUES (73, 'expedita');
INSERT INTO `media_type` (`id`, `type`) VALUES (74, 'exercitationem');
INSERT INTO `media_type` (`id`, `type`) VALUES (75, 'sint');
INSERT INTO `media_type` (`id`, `type`) VALUES (76, 'fugit');
INSERT INTO `media_type` (`id`, `type`) VALUES (77, 'minus');
INSERT INTO `media_type` (`id`, `type`) VALUES (78, 'quisquam');
INSERT INTO `media_type` (`id`, `type`) VALUES (79, 'quibusdam');
INSERT INTO `media_type` (`id`, `type`) VALUES (80, 'sed');
INSERT INTO `media_type` (`id`, `type`) VALUES (81, 'hic');
INSERT INTO `media_type` (`id`, `type`) VALUES (82, 'officia');
INSERT INTO `media_type` (`id`, `type`) VALUES (83, 'provident');
INSERT INTO `media_type` (`id`, `type`) VALUES (84, 'corrupti');
INSERT INTO `media_type` (`id`, `type`) VALUES (85, 'unde');
INSERT INTO `media_type` (`id`, `type`) VALUES (86, 'fuga');
INSERT INTO `media_type` (`id`, `type`) VALUES (87, 'ea');
INSERT INTO `media_type` (`id`, `type`) VALUES (88, 'vero');
INSERT INTO `media_type` (`id`, `type`) VALUES (89, 'eum');
INSERT INTO `media_type` (`id`, `type`) VALUES (90, 'neque');
INSERT INTO `media_type` (`id`, `type`) VALUES (91, 'ad');
INSERT INTO `media_type` (`id`, `type`) VALUES (92, 'voluptatibus');
INSERT INTO `media_type` (`id`, `type`) VALUES (93, 'dignissimos');
INSERT INTO `media_type` (`id`, `type`) VALUES (94, 'officiis');
INSERT INTO `media_type` (`id`, `type`) VALUES (95, 'perferendis');
INSERT INTO `media_type` (`id`, `type`) VALUES (96, 'consectetur');
INSERT INTO `media_type` (`id`, `type`) VALUES (97, 'modi');
INSERT INTO `media_type` (`id`, `type`) VALUES (98, 'tempora');
INSERT INTO `media_type` (`id`, `type`) VALUES (99, 'architecto');
INSERT INTO `media_type` (`id`, `type`) VALUES (100, 'molestias');

SELECT * FROM media_type mt ;

INSERT INTO `item_types` (`id`, `name`) VALUES (1, 'consequatur');
INSERT INTO `item_types` (`id`, `name`) VALUES (2, 'totam');
INSERT INTO `item_types` (`id`, `name`) VALUES (3, 'pariatur');
INSERT INTO `item_types` (`id`, `name`) VALUES (4, 'et');
INSERT INTO `item_types` (`id`, `name`) VALUES (5, 'dolorem');
INSERT INTO `item_types` (`id`, `name`) VALUES (6, 'maiores');
INSERT INTO `item_types` (`id`, `name`) VALUES (7, 'sint');
INSERT INTO `item_types` (`id`, `name`) VALUES (8, 'porro');
INSERT INTO `item_types` (`id`, `name`) VALUES (9, 'sed');
INSERT INTO `item_types` (`id`, `name`) VALUES (10, 'aperiam');
INSERT INTO `item_types` (`id`, `name`) VALUES (11, 'aliquid');
INSERT INTO `item_types` (`id`, `name`) VALUES (12, 'delectus');
INSERT INTO `item_types` (`id`, `name`) VALUES (13, 'qui');
INSERT INTO `item_types` (`id`, `name`) VALUES (14, 'doloremque');
INSERT INTO `item_types` (`id`, `name`) VALUES (15, 'nostrum');
INSERT INTO `item_types` (`id`, `name`) VALUES (16, 'numquam');
INSERT INTO `item_types` (`id`, `name`) VALUES (17, 'voluptatem');
INSERT INTO `item_types` (`id`, `name`) VALUES (18, 'rerum');
INSERT INTO `item_types` (`id`, `name`) VALUES (19, 'id');
INSERT INTO `item_types` (`id`, `name`) VALUES (20, 'molestias');
INSERT INTO `item_types` (`id`, `name`) VALUES (21, 'odio');
INSERT INTO `item_types` (`id`, `name`) VALUES (22, 'facilis');
INSERT INTO `item_types` (`id`, `name`) VALUES (23, 'cum');
INSERT INTO `item_types` (`id`, `name`) VALUES (24, 'nihil');
INSERT INTO `item_types` (`id`, `name`) VALUES (25, 'praesentium');
INSERT INTO `item_types` (`id`, `name`) VALUES (26, 'adipisci');
INSERT INTO `item_types` (`id`, `name`) VALUES (27, 'fugit');
INSERT INTO `item_types` (`id`, `name`) VALUES (28, 'est');
INSERT INTO `item_types` (`id`, `name`) VALUES (29, 'vel');
INSERT INTO `item_types` (`id`, `name`) VALUES (30, 'in');
INSERT INTO `item_types` (`id`, `name`) VALUES (31, 'maxime');
INSERT INTO `item_types` (`id`, `name`) VALUES (32, 'recusandae');
INSERT INTO `item_types` (`id`, `name`) VALUES (33, 'ducimus');
INSERT INTO `item_types` (`id`, `name`) VALUES (34, 'deleniti');
INSERT INTO `item_types` (`id`, `name`) VALUES (35, 'repellendus');
INSERT INTO `item_types` (`id`, `name`) VALUES (36, 'debitis');
INSERT INTO `item_types` (`id`, `name`) VALUES (37, 'labore');
INSERT INTO `item_types` (`id`, `name`) VALUES (38, 'nisi');
INSERT INTO `item_types` (`id`, `name`) VALUES (39, 'sapiente');
INSERT INTO `item_types` (`id`, `name`) VALUES (40, 'minima');
INSERT INTO `item_types` (`id`, `name`) VALUES (41, 'laboriosam');
INSERT INTO `item_types` (`id`, `name`) VALUES (42, 'ex');
INSERT INTO `item_types` (`id`, `name`) VALUES (43, 'dolore');
INSERT INTO `item_types` (`id`, `name`) VALUES (44, 'autem');
INSERT INTO `item_types` (`id`, `name`) VALUES (45, 'eius');
INSERT INTO `item_types` (`id`, `name`) VALUES (46, 'ut');
INSERT INTO `item_types` (`id`, `name`) VALUES (47, 'iste');
INSERT INTO `item_types` (`id`, `name`) VALUES (48, 'explicabo');
INSERT INTO `item_types` (`id`, `name`) VALUES (49, 'atque');
INSERT INTO `item_types` (`id`, `name`) VALUES (50, 'unde');
INSERT INTO `item_types` (`id`, `name`) VALUES (51, 'doloribus');
INSERT INTO `item_types` (`id`, `name`) VALUES (52, 'eveniet');
INSERT INTO `item_types` (`id`, `name`) VALUES (53, 'officiis');
INSERT INTO `item_types` (`id`, `name`) VALUES (54, 'assumenda');
INSERT INTO `item_types` (`id`, `name`) VALUES (55, 'quisquam');
INSERT INTO `item_types` (`id`, `name`) VALUES (56, 'asperiores');
INSERT INTO `item_types` (`id`, `name`) VALUES (57, 'quia');
INSERT INTO `item_types` (`id`, `name`) VALUES (58, 'aspernatur');
INSERT INTO `item_types` (`id`, `name`) VALUES (59, 'neque');
INSERT INTO `item_types` (`id`, `name`) VALUES (60, 'eum');
INSERT INTO `item_types` (`id`, `name`) VALUES (61, 'architecto');
INSERT INTO `item_types` (`id`, `name`) VALUES (62, 'enim');
INSERT INTO `item_types` (`id`, `name`) VALUES (63, 'iure');
INSERT INTO `item_types` (`id`, `name`) VALUES (64, 'corrupti');
INSERT INTO `item_types` (`id`, `name`) VALUES (65, 'eligendi');
INSERT INTO `item_types` (`id`, `name`) VALUES (66, 'veniam');
INSERT INTO `item_types` (`id`, `name`) VALUES (67, 'exercitationem');
INSERT INTO `item_types` (`id`, `name`) VALUES (68, 'sit');
INSERT INTO `item_types` (`id`, `name`) VALUES (69, 'aut');
INSERT INTO `item_types` (`id`, `name`) VALUES (70, 'commodi');
INSERT INTO `item_types` (`id`, `name`) VALUES (71, 'eaque');
INSERT INTO `item_types` (`id`, `name`) VALUES (72, 'vitae');
INSERT INTO `item_types` (`id`, `name`) VALUES (73, 'harum');
INSERT INTO `item_types` (`id`, `name`) VALUES (74, 'magni');
INSERT INTO `item_types` (`id`, `name`) VALUES (75, 'magnam');
INSERT INTO `item_types` (`id`, `name`) VALUES (76, 'cumque');
INSERT INTO `item_types` (`id`, `name`) VALUES (77, 'laudantium');
INSERT INTO `item_types` (`id`, `name`) VALUES (78, 'omnis');
INSERT INTO `item_types` (`id`, `name`) VALUES (79, 'ea');
INSERT INTO `item_types` (`id`, `name`) VALUES (80, 'saepe');
INSERT INTO `item_types` (`id`, `name`) VALUES (81, 'ab');
INSERT INTO `item_types` (`id`, `name`) VALUES (82, 'repellat');
INSERT INTO `item_types` (`id`, `name`) VALUES (83, 'tempore');
INSERT INTO `item_types` (`id`, `name`) VALUES (84, 'mollitia');
INSERT INTO `item_types` (`id`, `name`) VALUES (85, 'nulla');
INSERT INTO `item_types` (`id`, `name`) VALUES (86, 'dicta');
INSERT INTO `item_types` (`id`, `name`) VALUES (87, 'similique');
INSERT INTO `item_types` (`id`, `name`) VALUES (88, 'molestiae');
INSERT INTO `item_types` (`id`, `name`) VALUES (89, 'perferendis');
INSERT INTO `item_types` (`id`, `name`) VALUES (90, 'nam');
INSERT INTO `item_types` (`id`, `name`) VALUES (91, 'velit');
INSERT INTO `item_types` (`id`, `name`) VALUES (92, 'error');
INSERT INTO `item_types` (`id`, `name`) VALUES (93, 'aliquam');
INSERT INTO `item_types` (`id`, `name`) VALUES (94, 'animi');
INSERT INTO `item_types` (`id`, `name`) VALUES (95, 'dolor');
INSERT INTO `item_types` (`id`, `name`) VALUES (96, 'quo');
INSERT INTO `item_types` (`id`, `name`) VALUES (97, 'natus');
INSERT INTO `item_types` (`id`, `name`) VALUES (98, 'itaque');
INSERT INTO `item_types` (`id`, `name`) VALUES (99, 'non');
INSERT INTO `item_types` (`id`, `name`) VALUES (100, 'quam');

SELECT * FROM item_types it ;


INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (1, 'occaecati', 1, '1997-10-20 17:30:54', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (2, 'officiis', 2, '2009-09-30 14:06:21', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (3, 'aliquid', 3, '1974-06-27 22:02:52', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (4, 'dolorem', 4, '2013-05-16 07:08:14', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (5, 'itaque', 5, '1997-10-10 06:37:03', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (6, 'eveniet', 6, '2015-04-13 14:18:04', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (7, 'velit', 7, '2015-10-29 19:29:04', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (8, 'vel', 8, '2003-11-29 07:57:10', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (9, 'ex', 9, '2016-05-15 07:33:09', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (10, 'in', 10, '1980-12-20 10:23:25', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (11, 'id', 11, '1982-06-30 07:49:31', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (12, 'et', 12, '1997-02-02 06:53:23', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (13, 'sint', 13, '2002-11-02 01:52:06', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (14, 'doloribus', 14, '1982-06-24 08:34:33', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (15, 'culpa', 15, '1979-08-22 08:49:40', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (16, 'accusamus', 16, '1982-10-03 10:58:52', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (17, 'quos', 17, '1973-06-20 11:21:17', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (18, 'voluptas', 18, '1989-08-11 05:22:20', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (19, 'iure', 19, '2011-07-27 18:39:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (20, 'consequuntur', 20, '2016-05-19 04:08:12', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (21, 'voluptatem', 21, '2006-12-31 16:25:52', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (22, 'ad', 22, '1994-11-26 11:13:59', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (23, 'excepturi', 23, '2013-04-22 01:42:22', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (24, 'qui', 24, '1995-07-05 15:05:32', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (25, 'sequi', 25, '2001-05-18 15:04:17', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (26, 'suscipit', 26, '2002-01-22 16:26:08', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (27, 'aperiam', 27, '1976-01-01 17:01:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (28, 'est', 28, '1994-11-23 00:26:00', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (29, 'consectetur', 29, '2005-12-29 04:34:14', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (30, 'modi', 30, '2003-12-17 12:53:18', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (31, 'amet', 31, '1998-07-02 01:47:03', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (32, 'ab', 32, '1990-10-30 10:55:18', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (33, 'quo', 33, '1975-08-14 12:12:38', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (34, 'animi', 34, '2007-08-28 13:21:28', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (35, 'beatae', 35, '1994-01-29 11:48:08', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (36, 'vitae', 36, '1984-06-13 06:35:54', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (37, 'saepe', 37, '1985-03-05 05:18:13', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (38, 'consequatur', 38, '1985-11-08 14:02:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (39, 'impedit', 39, '1986-11-09 23:24:48', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (40, 'doloremque', 40, '1989-07-13 10:27:13', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (41, 'magnam', 41, '2011-07-13 18:12:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (42, 'sit', 42, '2020-11-20 00:48:05', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (43, 'repellendus', 43, '1978-04-08 18:18:08', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (44, 'ut', 44, '2007-05-18 07:25:27', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (45, 'dolorum', 45, '1987-04-29 01:08:12', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (46, 'odit', 46, '1995-12-31 00:32:30', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (47, 'facere', 47, '1973-04-13 11:57:59', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (48, 'ea', 48, '2015-01-05 19:20:39', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (49, 'atque', 49, '1987-02-28 08:06:31', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (50, 'odio', 50, '1992-03-20 22:52:10', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (51, 'tempore', 51, '2000-04-25 23:46:31', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (52, 'quisquam', 52, '1981-04-25 06:24:24', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (53, 'ipsum', 53, '2004-01-29 22:52:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (54, 'numquam', 54, '1998-06-16 21:24:01', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (55, 'perspiciatis', 55, '2009-05-10 11:53:12', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (56, 'vero', 56, '1990-11-13 08:30:25', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (57, 'recusandae', 57, '1977-09-22 01:40:22', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (58, 'mollitia', 58, '1986-05-16 18:27:28', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (59, 'commodi', 59, '2015-04-14 06:07:04', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (60, 'quia', 60, '2002-05-15 02:46:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (61, 'quis', 61, '1998-03-13 00:41:00', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (62, 'aut', 62, '1997-01-15 03:49:58', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (63, 'tempora', 63, '1975-07-04 18:58:35', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (64, 'molestiae', 64, '2001-07-06 00:53:39', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (65, 'maxime', 65, '2016-01-01 22:04:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (66, 'nobis', 66, '1994-08-17 14:46:39', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (67, 'soluta', 67, '1997-10-01 14:52:09', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (68, 'facilis', 68, '2018-12-20 23:36:47', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (69, 'minus', 69, '1985-06-26 06:41:16', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (70, 'voluptatum', 70, '2015-10-20 03:47:50', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (71, 'corporis', 71, '2019-07-08 03:53:13', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (72, 'quam', 72, '1981-10-18 11:52:59', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (73, 'adipisci', 73, '2009-07-14 18:10:30', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (74, 'explicabo', 74, '1976-02-13 15:47:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (75, 'porro', 75, '1992-09-14 01:53:59', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (76, 'dolor', 76, '2015-03-08 00:53:48', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (77, 'harum', 77, '1978-02-22 18:04:59', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (78, 'corrupti', 78, '2007-02-08 15:33:17', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (79, 'molestias', 79, '2003-01-27 00:19:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (80, 'cumque', 80, '2001-03-11 07:18:46', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (81, 'placeat', 81, '1999-10-19 20:33:13', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (82, 'deleniti', 82, '2010-12-22 13:14:17', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (83, 'cupiditate', 83, '1983-01-29 17:32:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (84, 'sed', 84, '2020-07-15 13:15:00', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (85, 'autem', 85, '1980-07-24 05:00:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (86, 'rerum', 86, '1978-08-12 05:46:40', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (87, 'libero', 87, '1975-04-14 08:02:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (88, 'quod', 88, '1976-04-26 10:52:58', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (89, 'nesciunt', 89, '1985-06-03 06:12:38', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (90, 'a', 90, '1972-07-01 04:10:31', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (91, 'voluptates', 91, '1973-05-20 01:42:26', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (92, 'nam', 92, '1975-12-14 10:15:56', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (93, 'omnis', 93, '2018-05-01 14:07:20', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (94, 'dicta', 94, '1995-04-18 20:04:01', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (95, 'blanditiis', 95, '2013-12-27 14:26:32', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (96, 'temporibus', 96, '1975-02-17 07:26:04', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (97, 'assumenda', 97, '2015-01-05 18:56:48', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (98, 'architecto', 98, '2004-10-02 09:03:24', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (99, 'hic', 99, '1983-08-16 04:18:38', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (100, 'nisi', 100, '1972-08-09 19:36:17', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (101, 'non', 1, '1982-12-10 01:36:51', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (102, 'unde', 2, '1985-02-06 23:41:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (103, 'nihil', 3, '2017-03-08 06:00:21', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (104, 'ducimus', 4, '2002-04-04 15:32:23', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (105, 'aliquam', 5, '2014-07-13 13:03:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (106, 'dolores', 6, '2012-07-30 09:26:34', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (107, 'eos', 7, '1986-09-29 01:44:23', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (108, 'fuga', 8, '2001-10-13 22:57:32', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (109, 'inventore', 9, '1994-11-24 17:55:09', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (110, 'eligendi', 10, '2006-11-01 00:15:41', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (111, 'dolore', 11, '2017-04-30 10:27:29', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (112, 'quibusdam', 12, '2016-03-17 07:01:25', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (113, 'veritatis', 13, '1992-10-27 18:23:51', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (114, 'enim', 14, '1980-03-20 04:55:31', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (115, 'quasi', 15, '1975-10-28 10:53:45', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (116, 'sunt', 16, '1997-12-30 01:24:10', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (117, 'nulla', 17, '2019-08-04 14:49:45', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (118, 'cum', 18, '1999-06-29 07:48:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (119, 'sapiente', 19, '1970-12-01 07:17:21', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (120, 'alias', 20, '1982-10-09 08:52:35', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (121, 'ullam', 21, '1991-12-24 10:24:30', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (122, 'debitis', 22, '1977-10-08 18:41:38', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (123, 'aspernatur', 23, '1970-09-02 15:49:45', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (124, 'voluptatibus', 24, '1975-04-25 15:56:39', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (125, 'eius', 25, '2005-09-16 15:52:30', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (126, 'asperiores', 26, '1988-02-27 07:38:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (127, 'ipsam', 27, '2001-03-18 13:58:55', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (128, 'totam', 28, '2014-08-21 15:12:05', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (129, 'laudantium', 29, '1992-06-30 09:11:45', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (130, 'accusantium', 30, '2013-07-15 05:35:58', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (131, 'quae', 31, '1975-09-17 03:55:11', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (132, 'similique', 32, '2013-06-20 08:25:14', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (133, 'laborum', 33, '1992-07-17 08:37:28', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (134, 'voluptate', 34, '1973-09-04 19:24:49', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (135, 'error', 35, '2009-02-01 15:10:57', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (136, 'veniam', 36, '2004-11-15 00:18:57', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (137, 'tenetur', 37, '1984-04-06 04:29:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (138, 'minima', 38, '1997-01-14 19:14:16', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (139, 'quidem', 39, '2012-04-01 08:43:09', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (140, 'distinctio', 40, '1976-02-29 15:40:23', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (141, 'iusto', 41, '1999-03-02 09:24:21', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (142, 'labore', 42, '2009-02-20 14:46:56', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (143, 'eaque', 43, '1991-06-24 12:49:41', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (144, 'fugit', 44, '1995-07-11 10:46:37', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (145, 'praesentium', 45, '2018-05-30 17:27:52', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (146, 'maiores', 46, '1974-02-25 02:51:55', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (147, 'pariatur', 47, '1995-12-15 09:50:36', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (148, 'fugiat', 48, '1980-02-15 21:27:02', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (149, 'provident', 49, '2018-04-25 03:07:25', '2020-11-23 08:01:22');
INSERT INTO `item` (`id`, `name`, `item_type_id`, `created_at`, `updated_at`) VALUES (150, 'earum', 50, '1999-08-08 08:42:58', '2020-11-23 08:01:22');

SELECT * FROM item;


INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (1, 'sed', 1, 1, '2003-01-25 14:06:59', 6840, 1);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (2, 'eveniet', 2, 2, '2013-06-17 11:08:48', 152, 2);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (3, 'quaerat', 3, 3, '2011-02-11 05:38:39', 69072, 3);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (4, 'culpa', 4, 4, '2014-05-25 11:39:19', 0, 4);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (5, 'porro', 5, 5, '1987-04-04 14:05:27', 97, 5);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (6, 'mollitia', 6, 6, '2019-10-26 06:25:13', 949, 6);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (7, 'nisi', 7, 7, '1972-05-17 00:50:42', 57, 7);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (8, 'sint', 8, 8, '1993-06-08 14:50:53', 9, 8);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (9, 'expedita', 9, 9, '1996-08-03 03:51:47', 0, 9);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (10, 'voluptatem', 10, 10, '2009-04-09 09:40:05', 300775565, 10);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (11, 'quos', 11, 11, '1991-12-13 19:37:54', 4204659, 11);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (12, 'minus', 12, 12, '1987-01-09 20:46:08', 104, 12);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (13, 'in', 13, 13, '1996-08-13 11:59:58', 763161, 13);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (14, 'rerum', 14, 14, '1975-11-26 01:33:31', 690832, 14);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (15, 'quos', 15, 15, '2018-06-04 02:26:29', 221327, 15);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (16, 'laboriosam', 16, 16, '1979-03-30 15:11:37', 7, 16);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (17, 'ipsam', 17, 17, '1975-11-17 06:39:52', 820730171, 17);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (18, 'nobis', 18, 18, '2018-01-16 11:46:13', 95, 18);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (19, 'officia', 19, 19, '1972-11-01 15:02:17', 199, 19);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (20, 'aliquam', 20, 20, '1981-03-23 23:14:26', 0, 20);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (21, 'impedit', 21, 21, '2012-05-04 01:29:46', 5899843, 21);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (22, 'qui', 22, 22, '2015-05-14 10:10:18', 476, 22);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (23, 'commodi', 23, 23, '2003-10-02 03:44:17', 34938, 23);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (24, 'facere', 24, 24, '2015-04-16 18:45:38', 9321, 24);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (25, 'fugit', 25, 25, '2018-10-25 20:07:52', 6, 25);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (26, 'itaque', 26, 26, '2002-02-28 19:31:36', 0, 26);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (27, 'possimus', 27, 27, '1982-12-09 09:09:31', 148822, 27);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (28, 'veritatis', 28, 28, '2010-07-02 22:50:19', 718, 28);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (29, 'itaque', 29, 29, '2000-12-28 01:09:26', 9, 29);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (30, 'officiis', 30, 30, '1999-05-02 19:53:49', 76878, 30);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (31, 'similique', 31, 31, '1973-01-07 12:58:17', 7085451, 31);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (32, 'architecto', 32, 32, '2011-12-05 04:29:48', 509989622, 32);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (33, 'totam', 33, 33, '1988-08-05 00:42:51', 4, 33);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (34, 'unde', 34, 34, '1996-12-29 03:42:57', 719988, 34);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (35, 'assumenda', 35, 35, '1988-11-24 11:53:07', 829903, 35);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (36, 'voluptates', 36, 36, '2007-01-15 03:32:32', 615, 36);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (37, 'commodi', 37, 37, '2008-05-03 08:05:14', 1263, 37);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (38, 'esse', 38, 38, '1971-02-02 18:33:06', 21702, 38);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (39, 'deserunt', 39, 39, '1988-10-24 05:34:38', 1, 39);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (40, 'similique', 40, 40, '1981-02-12 06:45:16', 70983660, 40);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (41, 'facilis', 41, 41, '1972-01-26 13:05:09', 2549, 41);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (42, 'aut', 42, 42, '2017-05-25 00:33:11', 9, 42);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (43, 'eos', 43, 43, '2003-05-01 00:42:32', 8, 43);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (44, 'ab', 44, 44, '1988-01-13 07:50:17', 1567, 44);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (45, 'recusandae', 45, 45, '1984-08-06 15:09:54', 63, 45);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (46, 'et', 46, 46, '2011-01-08 07:49:11', 746917, 46);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (47, 'vero', 47, 47, '1998-09-04 23:36:59', 9272, 47);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (48, 'ut', 48, 48, '1998-04-08 15:01:11', 513371, 48);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (49, 'deserunt', 49, 49, '1974-02-02 14:50:47', 9, 49);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (50, 'saepe', 50, 50, '2017-06-03 06:13:51', 377, 50);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (51, 'magnam', 51, 51, '2001-04-13 06:34:04', 634, 51);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (52, 'nemo', 52, 52, '2008-06-22 03:57:53', 6900, 52);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (53, 'sit', 53, 53, '1970-12-05 13:47:28', 7541681, 53);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (54, 'sint', 54, 54, '2014-04-21 14:10:28', 2, 54);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (55, 'magnam', 55, 55, '1972-06-23 01:06:07', 32759, 55);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (56, 'eos', 56, 56, '1991-01-04 16:18:21', 59752, 56);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (57, 'ut', 57, 57, '1989-04-07 12:06:24', 7892, 57);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (58, 'ratione', 58, 58, '1989-04-29 02:10:22', 30549631, 58);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (59, 'omnis', 59, 59, '1999-04-21 13:02:35', 1366, 59);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (60, 'quidem', 60, 60, '1976-10-29 10:54:30', 891209376, 60);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (61, 'ut', 61, 61, '1977-06-12 16:55:10', 78, 61);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (62, 'voluptas', 62, 62, '2010-10-15 03:05:34', 982006860, 62);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (63, 'animi', 63, 63, '1990-11-28 05:14:18', 218, 63);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (64, 'ducimus', 64, 64, '1996-02-22 14:02:20', 8, 64);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (65, 'ea', 65, 65, '2003-08-02 23:25:14', 33, 65);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (66, 'magnam', 66, 66, '1983-03-02 01:48:53', 6265, 66);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (67, 'magni', 67, 67, '1973-07-29 14:28:38', 1157, 67);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (68, 'delectus', 68, 68, '1975-08-24 10:50:12', 24946467, 68);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (69, 'aut', 69, 69, '1978-03-25 14:15:44', 73616, 69);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (70, 'fugit', 70, 70, '2014-03-19 01:27:22', 94, 70);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (71, 'reiciendis', 71, 71, '2003-03-15 05:54:55', 4017, 71);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (72, 'in', 72, 72, '1987-07-22 00:29:39', 6735, 72);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (73, 'libero', 73, 73, '2012-08-25 16:13:46', 1, 73);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (74, 'pariatur', 74, 74, '1999-03-18 08:23:39', 1294736, 74);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (75, 'corporis', 75, 75, '1993-11-08 21:02:59', 3144147, 75);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (76, 'voluptate', 76, 76, '1977-03-16 23:56:43', 684579093, 76);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (77, 'ullam', 77, 77, '2014-06-06 04:28:28', 280283, 77);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (78, 'dicta', 78, 78, '1981-03-24 17:32:49', 31, 78);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (79, 'quidem', 79, 79, '2002-04-24 06:25:26', 105, 79);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (80, 'et', 80, 80, '1970-07-26 02:43:38', 18832636, 80);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (81, 'temporibus', 81, 81, '1982-08-02 06:30:04', 8, 81);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (82, 'qui', 82, 82, '1976-09-13 02:34:00', 84514, 82);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (83, 'deleniti', 83, 83, '1973-12-17 12:05:59', 68, 83);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (84, 'quo', 84, 84, '2015-11-25 08:49:57', 25918, 84);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (85, 'optio', 85, 85, '1983-01-11 15:54:51', 6140171, 85);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (86, 'qui', 86, 86, '1992-12-29 05:53:26', 0, 86);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (87, 'quam', 87, 87, '2020-05-04 13:18:41', 12781202, 87);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (88, 'dolorum', 88, 88, '1986-01-03 08:14:11', 60819570, 88);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (89, 'minus', 89, 89, '1987-12-01 21:43:04', 400, 89);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (90, 'dolorum', 90, 90, '1977-05-11 09:15:37', 0, 90);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (91, 'sit', 91, 91, '1989-05-04 02:53:52', 76, 91);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (92, 'dolor', 92, 92, '1996-08-14 10:36:52', 7230263, 92);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (93, 'perspiciatis', 93, 93, '1989-05-23 19:40:06', 9634, 93);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (94, 'natus', 94, 94, '1977-07-12 23:28:38', 122, 94);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (95, 'odio', 95, 95, '1994-08-10 06:26:58', 289541, 95);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (96, 'qui', 96, 96, '1976-07-17 15:45:19', 19716538, 96);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (97, 'voluptatem', 97, 97, '1975-01-16 07:54:03', 5519852, 97);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (98, 'animi', 98, 98, '1991-01-19 08:29:23', 4773, 98);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (99, 'rerum', 99, 99, '1989-03-27 08:27:19', 6, 99);
INSERT INTO `media` (`id`, `name`, `user_id`, `item_id`, `created_at`, `size`, `media_type_id`) VALUES (100, 'saepe', 100, 100, '1970-01-30 20:27:42', 27, 100);

SELECT * FROM media;

INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (1, 'id', '2013-06-23 19:39:58', '2018-10-19 19:33:19');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (2, 'ad', '1991-01-24 16:00:52', '2016-09-22 03:49:06');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (3, 'asperiores', '1999-11-27 02:05:04', '1972-04-22 07:49:55');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (4, 'laborum', '2009-04-21 11:59:16', '1978-08-24 06:10:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (5, 'magni', '1988-10-28 11:45:48', '1982-03-26 10:43:05');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (6, 'commodi', '2002-01-22 13:01:49', '2015-02-09 18:24:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (7, 'at', '2009-04-22 19:15:11', '2019-05-25 20:30:42');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (8, 'qui', '1992-06-10 23:57:32', '1992-05-04 11:05:41');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (9, 'quam', '2011-10-25 17:06:14', '2017-04-19 19:26:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (10, 'soluta', '1971-02-24 00:22:03', '2011-07-02 10:09:03');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (11, 'magnam', '1979-10-19 13:00:20', '2009-02-17 09:40:57');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (12, 'amet', '2015-03-12 21:46:48', '1980-02-08 06:40:31');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (13, 'dolorem', '2013-01-15 01:42:44', '1973-10-22 10:04:52');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (14, 'et', '1997-01-16 23:04:11', '1995-02-25 12:24:01');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (15, 'alias', '1984-09-14 22:36:55', '1989-04-16 13:40:41');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (16, 'unde', '2017-07-23 05:59:25', '1998-10-11 05:18:34');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (17, 'aliquam', '2013-12-10 15:03:06', '2005-01-07 16:25:15');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (18, 'minima', '1980-08-01 03:47:20', '1981-12-30 03:15:12');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (19, 'quas', '2012-10-05 07:21:36', '1982-03-25 20:38:34');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (20, 'incidunt', '1974-02-02 06:53:26', '1985-09-05 20:20:53');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (21, 'consequuntur', '2020-02-07 01:39:22', '2007-02-02 09:19:25');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (22, 'ut', '2006-11-23 02:57:42', '2006-10-19 02:04:07');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (23, 'quo', '1973-11-07 11:20:43', '2002-01-28 17:11:07');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (24, 'natus', '2014-05-04 09:05:51', '1989-02-10 12:46:16');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (25, 'eaque', '2017-02-23 22:32:07', '2011-09-26 00:57:14');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (26, 'est', '1984-10-19 19:39:14', '2007-07-15 20:28:03');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (27, 'aliquid', '1970-04-20 05:55:12', '1982-06-07 05:58:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (28, 'temporibus', '1996-09-18 08:14:25', '2011-08-22 10:34:02');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (29, 'placeat', '1987-03-23 17:24:58', '2015-01-11 03:29:05');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (30, 'possimus', '1980-10-10 09:21:31', '1979-07-06 12:52:03');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (31, 'consectetur', '2014-11-23 18:54:08', '1983-02-14 06:53:07');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (32, 'aperiam', '2003-11-14 05:21:14', '1997-04-10 22:29:13');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (33, 'vel', '2003-02-02 09:30:46', '1978-10-16 01:39:19');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (34, 'sunt', '2011-07-06 20:25:06', '2001-11-27 10:14:20');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (35, 'eius', '2011-04-08 06:23:42', '2004-02-29 07:26:51');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (36, 'cum', '1990-01-28 19:03:47', '1991-07-07 03:24:05');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (37, 'aut', '1973-09-16 12:46:24', '1973-03-31 02:05:26');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (38, 'ratione', '1989-07-23 18:19:49', '1983-07-14 18:00:39');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (39, 'autem', '1985-01-01 13:30:24', '2001-02-12 09:12:12');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (40, 'quidem', '1988-12-21 20:56:04', '2000-11-22 09:18:52');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (41, 'nostrum', '1979-02-13 08:16:07', '1996-12-15 09:21:59');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (42, 'fugit', '2009-02-22 03:59:17', '1991-12-16 12:08:34');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (43, 'facere', '1997-08-30 17:04:39', '1988-06-22 07:12:20');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (44, 'maxime', '1997-08-22 05:37:35', '2010-05-11 07:25:56');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (45, 'voluptatem', '2019-08-02 01:51:15', '1983-04-03 13:11:13');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (46, 'sed', '2002-01-31 18:21:28', '1983-11-30 11:41:05');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (47, 'reprehenderit', '1986-09-27 15:36:54', '2002-02-25 21:52:03');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (48, 'blanditiis', '1974-10-02 14:15:45', '2005-01-07 21:12:34');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (49, 'earum', '1997-06-21 14:41:53', '2003-04-09 01:12:43');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (50, 'dolore', '2006-10-22 17:18:32', '2009-09-01 16:03:42');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (51, 'modi', '2007-11-09 22:02:12', '1992-03-03 00:42:11');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (52, 'quae', '2005-12-26 23:56:15', '2017-02-01 04:56:16');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (53, 'dolor', '1997-11-10 09:00:58', '1989-06-14 17:02:13');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (54, 'error', '1995-06-24 08:06:07', '1991-02-06 07:17:13');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (55, 'omnis', '1998-02-28 07:23:11', '1982-08-21 20:54:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (56, 'eos', '1985-09-18 20:15:08', '2000-12-25 05:22:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (57, 'sit', '1977-10-14 15:05:14', '1985-09-07 13:16:25');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (58, 'maiores', '2003-10-23 21:55:17', '1990-05-27 16:08:27');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (59, 'cupiditate', '2015-06-09 00:42:44', '1988-11-15 10:59:07');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (60, 'voluptatibus', '1998-10-22 20:02:45', '1970-06-30 22:54:50');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (61, 'voluptas', '2009-06-20 04:53:20', '1972-05-22 16:44:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (62, 'quis', '1984-08-24 20:28:57', '1987-10-03 17:43:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (63, 'nulla', '1995-08-16 08:19:28', '2014-04-17 22:58:51');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (64, 'molestiae', '1975-06-04 23:31:37', '2002-11-04 13:37:38');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (65, 'dignissimos', '2007-08-07 14:01:40', '1986-06-06 08:23:35');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (66, 'rerum', '1976-04-03 00:21:59', '1979-08-21 00:53:52');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (67, 'labore', '1974-08-08 19:11:28', '1994-08-24 10:30:05');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (68, 'necessitatibus', '1997-02-03 12:55:33', '2015-02-24 05:05:54');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (69, 'doloremque', '1987-01-29 09:03:04', '2008-01-19 01:54:42');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (70, 'enim', '1973-12-01 09:22:01', '1980-08-13 15:04:34');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (71, 'deleniti', '2005-12-31 03:36:08', '2003-08-01 07:26:23');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (72, 'sint', '2001-10-14 05:05:30', '1978-01-04 13:04:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (73, 'nobis', '1995-09-07 19:46:46', '1973-05-08 00:16:39');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (74, 'perferendis', '2011-01-14 12:48:20', '2015-07-01 11:38:18');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (75, 'pariatur', '1992-04-23 03:35:28', '2001-01-22 10:11:32');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (76, 'ducimus', '2020-04-07 15:48:16', '2000-06-10 16:34:28');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (77, 'voluptatum', '1971-08-22 20:05:56', '2004-09-08 10:18:16');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (78, 'quos', '1986-05-19 13:00:38', '2017-07-05 10:33:00');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (79, 'velit', '2012-11-20 00:58:27', '1980-10-30 19:15:53');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (80, 'ea', '2016-11-19 17:50:43', '1980-09-18 11:22:53');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (81, 'tempore', '1975-07-06 04:28:35', '2012-05-29 19:04:03');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (82, 'numquam', '2013-11-10 13:45:22', '1976-11-19 22:42:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (83, 'expedita', '1977-08-04 01:31:52', '1998-01-07 22:51:22');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (84, 'nam', '1993-08-08 01:37:36', '2020-09-03 18:22:46');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (85, 'reiciendis', '1982-02-07 18:41:43', '1970-05-29 08:29:51');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (86, 'vitae', '1982-12-25 00:14:42', '2012-05-05 16:21:09');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (87, 'dolores', '1995-11-19 14:51:08', '1999-05-29 22:48:07');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (88, 'eveniet', '1980-07-02 02:42:31', '1998-10-10 04:24:31');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (89, 'optio', '1989-12-12 16:36:12', '2019-11-30 00:16:13');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (90, 'corrupti', '1998-08-16 13:53:14', '1994-05-09 16:00:10');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (91, 'tempora', '1972-05-18 04:08:25', '1995-08-20 02:22:52');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (92, 'porro', '1982-05-10 19:43:11', '1994-09-15 12:27:30');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (93, 'quisquam', '2017-10-07 05:55:23', '1974-07-28 05:13:46');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (94, 'vero', '2009-01-19 06:21:14', '1983-01-26 15:20:57');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (95, 'deserunt', '2012-06-11 10:52:27', '1993-06-23 15:42:48');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (96, 'ullam', '1972-07-09 15:04:51', '1988-09-27 05:05:09');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (97, 'sequi', '1982-06-08 18:51:55', '2009-10-08 17:42:04');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (98, 'atque', '2019-03-30 11:12:21', '2019-03-27 16:26:51');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (99, 'nesciunt', '2002-01-01 23:58:35', '2013-03-11 12:13:29');
INSERT INTO `game_versions` (`id`, `version`, `start_at`, `end_at`) VALUES (100, 'quia', '1983-04-02 11:06:08', '2004-12-19 22:38:27');

SELECT * FROM game_versions gv ;

INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (1, 1, 'Natus qui voluptates ea. Sit enim aut et dolorem rerum tempora corrupti. Dolor illo consequuntur et consequatur nihil minus voluptates.', 1, '2009-06-19 07:54:48', '1999-03-09 05:43:45');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (2, 2, 'Eos ut explicabo sed aspernatur omnis. Aliquid aperiam quae modi dolore qui. Et rerum laboriosam et perferendis.', 2, '1999-01-11 21:08:26', '2008-02-28 09:08:45');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (3, 3, 'Quod consequuntur repellat suscipit porro esse qui. Dolor omnis id impedit labore. Sit necessitatibus autem laudantium fugiat et. Inventore dolores et eum doloremque consequatur velit eos.', 3, '2005-02-15 01:41:08', '1989-07-01 10:52:25');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (4, 4, 'Eaque qui deleniti quo officia. Dolore dolorem harum at itaque eum nihil. Vel voluptas ut ut amet deleniti quaerat. Incidunt unde pariatur consectetur et ea suscipit. Nemo ad alias id.', 4, '1987-01-18 08:44:32', '1993-04-21 18:17:15');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (5, 5, 'Aut ab molestiae possimus sunt facere quos. Doloremque est iste ipsam eos. Omnis aspernatur labore voluptate et tempora eum dolor incidunt.', 5, '1975-05-31 08:29:36', '2004-01-17 10:54:16');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (6, 6, 'Perspiciatis consequuntur veniam et ab. Possimus quaerat maiores in in ipsam et et. Quasi quas magni voluptatum. Commodi quis impedit atque eum.', 6, '1984-06-15 21:09:45', '2009-11-21 21:43:21');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (7, 7, 'Quis facilis et ut ipsum animi. Ut nam consequatur est voluptas qui assumenda nam placeat. Possimus et perferendis vero minima. Quibusdam rerum voluptas et dolor necessitatibus.', 7, '2018-10-11 10:17:15', '1996-07-03 21:07:01');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (8, 8, 'Ipsum rerum sunt et eum. Vero magni voluptatem non sint earum ut similique. Eum qui excepturi odit occaecati dignissimos.', 8, '1971-07-15 19:45:22', '2010-03-03 09:44:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (9, 9, 'Dolor dolores ab quia ullam. Eaque aut sit qui quis et totam. Dicta repudiandae explicabo nemo tempore quidem quibusdam.', 9, '2000-11-01 13:27:40', '1981-06-25 00:12:28');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (10, 10, 'Est voluptas quia est consequatur consequuntur laboriosam quae. Aspernatur quos sunt temporibus.', 10, '1975-04-30 02:07:44', '1973-11-22 08:09:58');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (11, 11, 'Saepe in et ab aliquam. Commodi omnis molestiae rem qui. Assumenda illo eveniet nihil dolor rerum culpa ut eaque. Quam nisi sit deserunt facere.', 11, '2012-10-20 20:53:08', '1989-11-29 20:02:21');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (12, 12, 'Quia quaerat est perferendis quia repellat sit architecto. Tenetur qui sed illo doloremque fugit. Consequatur quas magni iste et. Ducimus quisquam ea rerum libero iusto.', 12, '1975-06-01 21:59:44', '2014-06-10 21:16:06');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (13, 13, 'Voluptatem omnis quia et aliquid rerum. Soluta pariatur blanditiis aut qui. Ex rerum perferendis qui et a.', 13, '1989-06-25 06:12:49', '1994-03-19 15:26:59');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (14, 14, 'Amet enim beatae optio alias quibusdam sed cum. Nam quia consequatur atque et maiores.', 14, '1983-01-31 15:56:23', '2007-10-19 10:11:39');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (15, 15, 'Ea voluptatem numquam inventore temporibus quam aut quam. Excepturi nemo aperiam ea nulla quidem velit. Omnis deserunt minus error aut qui voluptates. Voluptatum ut sequi dolor laboriosam.', 15, '1972-06-02 02:12:16', '1997-09-11 15:01:33');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (16, 16, 'Laboriosam id fugit dolor libero non cum non saepe. Voluptate quia et optio nemo unde dignissimos. Temporibus sed autem eos qui.', 16, '1972-05-06 18:29:14', '1974-02-18 21:45:26');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (17, 17, 'Nobis dolore fugiat non blanditiis. Eligendi ea incidunt molestiae. Nulla dolorem optio soluta. Ipsa odio voluptates sit qui. Porro cupiditate voluptatem fuga harum sed.', 17, '2011-01-03 19:00:47', '1980-06-20 16:01:09');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (18, 18, 'Vel tempore eos non optio explicabo. Sint et asperiores omnis mollitia est. Nihil consequatur nemo voluptatum quaerat.', 18, '1986-03-28 01:12:22', '1982-08-16 15:27:17');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (19, 19, 'Nisi blanditiis eaque est velit dolor minus velit. Libero facilis vitae laboriosam. Ut fuga et officia repellat natus veniam voluptatibus.', 19, '1980-12-16 16:01:12', '2002-08-05 10:09:35');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (20, 20, 'Molestiae eos vitae sint iusto quia nemo. Cumque mollitia unde dolor dolores amet vero. A voluptatibus aut reprehenderit ratione et veritatis voluptatum.', 20, '1976-05-19 21:08:55', '2009-10-24 22:40:16');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (21, 21, 'Vel est reiciendis libero temporibus. Ipsa minus cupiditate reprehenderit amet. Autem voluptatum optio quis.', 21, '1973-02-19 00:42:54', '2015-10-24 14:32:37');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (22, 22, 'Dolorum et id consequatur. Blanditiis quasi laboriosam asperiores provident eum placeat.', 22, '1989-10-08 23:27:35', '2018-11-24 21:47:18');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (23, 23, 'Ea animi illum recusandae vero atque eos. Nemo neque aperiam et veniam quibusdam qui. Quibusdam tempora occaecati consequatur. Fugiat quia aperiam et dolorem quos dolorem.', 23, '1995-03-18 17:36:13', '2015-11-11 07:02:32');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (24, 24, 'Velit velit ut qui dolores sit nihil id. Suscipit cum blanditiis molestiae quam labore. Aperiam saepe assumenda ad eius. Voluptatem cumque voluptatem porro molestiae animi ipsa suscipit.', 24, '2003-08-16 02:41:15', '1998-06-25 08:20:33');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (25, 25, 'Nisi doloremque officia explicabo eum rerum nam. Quaerat facere sunt explicabo. Quia qui beatae aperiam sed accusamus.', 25, '2009-12-24 16:28:10', '2001-02-07 20:45:33');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (26, 26, 'Reiciendis architecto debitis eaque similique. Id facere voluptatem rem nisi.', 26, '2000-06-21 00:48:03', '1979-05-09 05:50:06');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (27, 27, 'Vel temporibus voluptatem quas rem et veniam culpa sint. Sed delectus nesciunt qui. Repudiandae libero nulla non.', 27, '1985-06-14 15:32:44', '1993-10-28 12:52:47');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (28, 28, 'Harum voluptatem asperiores voluptates soluta quae. Et vel laboriosam aliquam quos eos iste dolor. Suscipit voluptatibus hic quia sed quo laborum facere.', 28, '1998-05-16 20:31:13', '1999-07-23 03:18:39');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (29, 29, 'Nostrum beatae sed et officiis et asperiores facilis. Sequi aut et eveniet omnis. Praesentium est non a quas quasi distinctio. Laudantium molestiae corporis sequi nisi.', 29, '1991-12-31 11:49:34', '1970-05-28 04:23:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (30, 30, 'Ut et cumque voluptatem saepe nobis ad qui. Ut enim et aliquam accusantium beatae. Iure suscipit voluptates velit sed qui pariatur. Minus necessitatibus harum est ea.', 30, '1972-02-29 02:42:34', '1976-06-08 04:15:54');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (31, 31, 'Doloremque labore velit alias vel perspiciatis ipsa. Voluptatem qui cupiditate molestias tempore autem.', 31, '1993-12-18 10:21:13', '2019-04-01 17:55:25');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (32, 32, 'Quidem consequatur sapiente cum laboriosam assumenda. Ipsa necessitatibus in minus vero ab illo. Distinctio beatae iste rerum error soluta et nihil ab. Eos dolores dicta placeat illo hic.', 32, '2004-12-19 20:56:31', '1992-06-20 08:23:55');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (33, 33, 'Voluptatem in saepe beatae qui. Error impedit nisi reiciendis. Non labore nesciunt dolorem et.', 33, '2018-12-11 09:59:18', '1997-06-30 15:59:18');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (34, 34, 'Sunt deserunt atque et et. Est veniam non similique sit distinctio minima. Vitae veniam voluptate enim deserunt alias eum saepe.', 34, '1982-06-01 22:21:27', '1976-05-22 05:20:51');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (35, 35, 'Harum quod quidem nemo. Debitis dolorem maiores earum magnam quo sit laborum numquam. Rerum rerum ipsam et impedit odio nesciunt.', 35, '1975-06-17 04:44:45', '2002-06-05 15:58:19');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (36, 36, 'Eos molestias in dolores a deserunt sint nesciunt veritatis. Voluptates amet excepturi dolorem impedit eum.', 36, '1979-02-28 14:48:53', '2005-05-02 08:34:13');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (37, 37, 'Commodi quam et quo ut ipsam. Minus ex aut vel numquam. At et quisquam consectetur sed ut.', 37, '2018-10-04 23:17:05', '1987-04-10 21:13:11');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (38, 38, 'Soluta ut perspiciatis optio. Voluptate non laborum nulla facere inventore. Et voluptatum repudiandae placeat praesentium qui cupiditate nihil.', 38, '2018-03-30 13:00:19', '2010-07-03 04:01:22');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (39, 39, 'Ut voluptatibus qui omnis dolor. Possimus a occaecati hic voluptas iusto qui. Ullam adipisci sunt ut at eaque.', 39, '1996-09-02 12:15:59', '1979-07-03 08:12:38');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (40, 40, 'Fuga atque ut exercitationem architecto blanditiis. Quo eos nam nemo ut nostrum ipsum. Inventore incidunt asperiores ducimus quae aut aut.', 40, '1998-10-02 01:32:33', '1975-04-04 07:31:46');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (41, 41, 'Illo voluptatem voluptatem dolore laboriosam veritatis eaque. Eius voluptatem ipsam aut eaque cumque quidem ut et. Recusandae sit et eum voluptas animi nesciunt.', 41, '2019-08-14 08:14:43', '1976-04-28 12:05:20');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (42, 42, 'Repudiandae sunt adipisci quia. Omnis accusantium mollitia minima veritatis quia eveniet eos. Laborum enim quibusdam libero facilis alias. Magni laboriosam totam nostrum non qui non voluptas.', 42, '1973-03-28 21:29:22', '2009-06-21 05:46:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (43, 43, 'Dolorem commodi sapiente totam hic neque iste sunt. Quia voluptatibus adipisci nesciunt quos omnis ut earum. Aliquam deleniti similique suscipit minus qui assumenda molestiae.', 43, '1977-10-30 04:02:34', '2016-03-17 20:16:43');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (44, 44, 'Eum minima est veritatis quam natus nemo autem. Ullam sint ex provident consequatur explicabo. Dicta vel et et.', 44, '2018-10-06 03:37:54', '1998-06-03 17:28:13');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (45, 45, 'Laboriosam dolores optio eligendi qui ducimus aperiam ex. Corrupti dolores deserunt deserunt occaecati ipsum. Ipsam quod eius autem aut in.', 45, '1983-12-15 21:37:44', '1981-05-09 21:24:10');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (46, 46, 'Incidunt accusantium libero explicabo nihil excepturi. Debitis consequuntur eos quibusdam debitis vero sit ut quam. Laudantium quia sed iste doloribus. Non recusandae qui tempore excepturi rerum.', 46, '2007-06-05 17:24:14', '1985-01-29 11:38:34');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (47, 47, 'Et consequatur quia eaque est incidunt. Enim facilis ullam velit veritatis est dolores voluptatem. Dolorum ut eos similique laboriosam.', 47, '1984-08-15 02:52:50', '2016-09-13 21:04:28');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (48, 48, 'Aut cupiditate soluta laudantium minus rerum cumque. Porro assumenda ad provident beatae omnis accusantium fugit laborum. Fugit eligendi blanditiis deserunt modi quidem nobis.', 48, '1973-10-21 19:33:26', '1978-02-22 19:39:17');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (49, 49, 'Et fuga consectetur laborum quos sit quo. Numquam ducimus aperiam esse delectus quo dolor. Aut accusantium quia culpa consequuntur quaerat sit.', 49, '2003-07-12 12:28:42', '2018-02-22 21:54:04');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (50, 50, 'Aliquam impedit eius doloremque ipsa aspernatur occaecati. Et molestiae dolores earum assumenda aspernatur perspiciatis quis quo. Excepturi quia voluptas quia et.', 50, '1984-07-15 06:41:55', '2004-09-25 14:05:09');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (51, 51, 'Odio veniam molestiae quis ut pariatur ut illo soluta. Voluptatem cumque vel dolorum veniam quibusdam eaque sint illum.', 51, '1970-10-06 12:58:07', '1986-09-22 08:50:48');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (52, 52, 'Enim maiores debitis facilis dignissimos in quia. Culpa error sed cum accusantium sed officiis. Atque doloremque ad ipsa. Eaque est quo necessitatibus quisquam non.', 52, '2010-04-10 21:52:46', '2019-01-21 05:15:22');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (53, 53, 'Assumenda quis maiores sequi voluptas veniam sint. Adipisci voluptas alias nihil officiis et itaque dolores. Consequatur nesciunt non repudiandae ut omnis natus dolor. Alias assumenda assumenda et.', 53, '1990-10-04 09:36:29', '2001-10-18 08:49:24');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (54, 54, 'Officiis et adipisci blanditiis nesciunt non qui qui. Omnis eum quos a porro adipisci molestias molestias. Ad excepturi et est odit aut et commodi.', 54, '2001-05-06 17:59:39', '1983-04-16 07:33:25');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (55, 55, 'Provident est ipsa corrupti corporis. Sunt maiores rem omnis tempore nesciunt aliquam architecto. Dolores quidem voluptates fugiat quis ut.', 55, '1982-05-03 12:50:00', '2006-05-24 22:04:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (56, 56, 'Eum deserunt quo dolores assumenda. Quia tempore laudantium aliquam voluptatem voluptatem voluptas sequi. Maiores consequuntur voluptatibus qui sint et neque.', 56, '2009-02-11 06:10:10', '2019-12-25 20:47:31');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (57, 57, 'Aspernatur enim aut vel aut. Minus sequi eaque voluptatem qui error occaecati est. Qui aut praesentium officiis nemo quae dolores est hic.', 57, '1982-02-04 03:36:23', '2010-03-18 04:26:54');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (58, 58, 'Est sit non eligendi tempora quo iure eius. Ipsum atque id voluptatem. Totam fugiat corrupti praesentium dolorem veritatis qui aut. Aperiam dolor possimus blanditiis voluptatibus.', 58, '1973-02-21 09:25:10', '1977-07-09 22:08:17');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (59, 59, 'Esse molestiae omnis autem omnis totam. Laudantium porro facilis eius qui.', 59, '1984-06-28 17:43:45', '2012-10-14 06:09:47');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (60, 60, 'Maiores recusandae id provident unde. Aut qui vero non. Doloremque voluptates fugit non tempora.', 60, '2015-05-30 23:47:44', '2002-03-29 17:42:46');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (61, 61, 'Non sit iure provident voluptatem animi nesciunt. Sit sit optio itaque voluptas inventore aut iure.', 61, '1991-05-29 09:08:04', '2012-11-18 03:47:53');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (62, 62, 'Enim aspernatur quas ea modi quas. Esse omnis quaerat repellat non beatae magnam quae. Eos consequatur recusandae est sint.', 62, '2006-12-02 12:32:37', '2007-12-10 00:40:48');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (63, 63, 'Magni ipsa deserunt vitae. Consectetur voluptas alias repellat et expedita dicta cupiditate blanditiis. Tempore impedit maiores delectus voluptates optio quo dolorem iure.', 63, '1978-01-02 04:55:23', '2013-05-12 17:10:34');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (64, 64, 'Nostrum illo voluptatem quaerat aut totam sit non. Et ipsa enim dignissimos consequatur. Amet hic sint est est. Et voluptas rerum et doloremque tempora.', 64, '2005-04-21 00:57:38', '1993-12-04 19:09:57');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (65, 65, 'Sed enim molestiae autem cumque eveniet dolorem vitae. Perspiciatis saepe non ducimus labore amet suscipit pariatur. Aut nulla est et voluptatem.', 65, '2012-12-01 21:38:42', '1974-05-02 07:34:02');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (66, 66, 'Dolor vero enim numquam error cupiditate dignissimos similique. Eum aliquid dolorem explicabo porro repellendus eos. Dolores sunt culpa qui. Necessitatibus vel voluptatum beatae aperiam.', 66, '1993-07-27 16:23:42', '1992-06-09 19:03:42');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (67, 67, 'Suscipit alias qui reprehenderit qui. Molestias cupiditate et vero fugit maiores. Quia alias ipsum dolorem sed.', 67, '1992-10-29 05:25:05', '1997-06-13 04:04:42');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (68, 68, 'Ipsam id earum ut necessitatibus. Dignissimos ex dignissimos facilis dolore et asperiores in. Qui magni sunt consectetur et excepturi tempore fugiat eum.', 68, '2014-10-17 08:49:48', '1995-01-14 13:15:20');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (69, 69, 'Officiis nostrum quo sint odio at. Temporibus est quia veniam sunt tempore enim ut error. Eaque officiis et inventore libero perferendis eum illum.', 69, '2009-09-24 05:50:42', '1994-09-05 03:00:38');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (70, 70, 'Hic praesentium sit ullam at. Architecto ea consequatur nihil dignissimos dignissimos quia. Quia esse ipsam id maiores vel dolorum voluptatem rerum. Modi eum explicabo quas veritatis.', 70, '1987-10-18 04:31:17', '2019-11-07 10:55:47');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (71, 71, 'Et est est accusantium iure dolorum dolorem vel natus. Vero enim sit nisi sunt maiores sunt. Et maiores illo et distinctio. Sed laboriosam ullam sapiente quos sint accusantium rerum harum.', 71, '1973-11-29 04:28:03', '1973-07-28 16:09:32');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (72, 72, 'Delectus aut autem recusandae sequi. Consequatur dolores tempore beatae atque assumenda repudiandae temporibus eos. Dolor et eligendi id ab tenetur. Nam est quia ut ea.', 72, '2013-06-11 18:45:36', '2015-12-12 09:35:12');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (73, 73, 'Sed et inventore perferendis vel. Aut rerum neque quia nobis nostrum. Consequuntur neque dolore eius culpa.', 73, '2011-01-25 19:43:37', '1990-09-29 05:56:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (74, 74, 'Vitae maiores commodi quod assumenda et dolorem. Ad unde officiis vero numquam. Quia est qui vel commodi officiis.', 74, '1985-02-07 16:24:04', '2020-04-01 01:40:26');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (75, 75, 'Voluptate animi dolorem optio eum. Impedit sunt mollitia consequatur illum unde molestias odit. Reprehenderit architecto corrupti natus consequuntur nobis et voluptatem.', 75, '1981-05-24 03:56:55', '2018-07-08 10:49:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (76, 76, 'Ullam aspernatur autem unde nisi. Culpa consectetur adipisci culpa delectus rerum distinctio veniam. Tempore aut aperiam dolorum quos. Sunt perspiciatis ex adipisci.', 76, '1983-01-18 20:38:22', '2013-09-11 08:57:05');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (77, 77, 'Distinctio laborum rerum libero ad pariatur libero. Beatae sequi sed consequatur enim ut nihil enim mollitia. Commodi est voluptatum cupiditate.', 77, '1996-11-16 17:30:11', '2010-10-08 07:16:25');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (78, 78, 'Consectetur occaecati et distinctio rerum nihil et. Ipsa quasi rerum asperiores suscipit dolorum est numquam sed. Quasi non corrupti recusandae provident et voluptas. Aliquid ad nesciunt quis ipsam.', 78, '1987-07-05 19:52:50', '1980-02-26 06:56:06');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (79, 79, 'Corporis et asperiores aliquid enim assumenda. Sint voluptatum non iste est vel rerum ut. Quia est ut error eum velit.', 79, '1980-03-24 05:58:27', '1996-06-27 08:16:13');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (80, 80, 'Nihil laboriosam aut dolorum. Consequatur quod reiciendis eum pariatur. Deserunt labore magnam ut rerum possimus sunt tenetur. Consequuntur excepturi labore sed voluptatibus quae odio.', 80, '2006-09-20 07:43:51', '1998-08-07 17:56:47');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (81, 81, 'Consequatur rem sit voluptas. Velit fuga qui totam qui. Omnis omnis error sunt pariatur quae delectus. Aut corporis culpa exercitationem eligendi et.', 81, '1992-01-20 02:40:08', '2012-10-04 10:35:54');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (82, 82, 'Aut ut ipsum labore quos eaque molestiae neque. Exercitationem delectus vel qui eveniet repudiandae ut. Sit quasi consequatur libero nam unde. Animi aut sit ut et alias et tempora.', 82, '1974-01-27 01:18:54', '2013-07-27 10:42:30');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (83, 83, 'Consectetur quisquam nostrum sit non ipsa. Inventore excepturi fuga omnis laborum rerum praesentium. Qui facilis deleniti optio et odit quae quidem occaecati.', 83, '2006-10-19 14:03:22', '2012-11-01 09:33:04');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (84, 84, 'Cupiditate qui voluptatum rerum soluta cumque exercitationem amet alias. Omnis sequi ea consequatur ratione. Commodi quaerat sit id. Sit perferendis earum similique animi ut.', 84, '2001-11-25 21:34:15', '1990-06-07 04:51:45');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (85, 85, 'Quis impedit nostrum dignissimos numquam. Est est itaque aliquam ratione voluptate in sequi. Illum veritatis veritatis rerum error ipsum. Et maxime et consequatur ab.', 85, '1981-08-07 20:22:37', '1972-06-22 03:34:11');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (86, 86, 'Vitae et ut sit ipsum quia. Cum voluptatem earum hic id vero reprehenderit sit. Nulla velit ipsam et dignissimos voluptas.', 86, '2011-06-21 13:03:25', '1988-12-15 07:40:34');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (87, 87, 'Maxime aperiam deserunt sed sed enim labore. Eius officiis ratione labore. Modi vel ea consequuntur explicabo natus.', 87, '1992-11-10 20:33:30', '1982-09-03 08:58:31');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (88, 88, 'Id voluptas officiis iure. Ut et eaque iusto dolorem. Atque autem et est. Harum eum rerum mollitia aut doloremque et eius aut. Sapiente et ad ipsam sint.', 88, '1994-01-31 11:23:51', '2005-03-04 00:24:58');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (89, 89, 'Dolorum labore quas eligendi delectus at. Ut nesciunt quidem cum magni corporis rerum nesciunt.', 89, '1976-08-17 17:55:33', '2000-03-21 18:26:09');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (90, 90, 'Velit aut voluptas numquam voluptatem odit. Qui modi ea ut delectus. Vero et soluta omnis ad aliquam repudiandae quis.', 90, '1986-03-27 11:31:02', '1993-09-21 16:08:55');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (91, 91, 'Ad eaque mollitia suscipit dolores cum qui alias. Voluptas sit ut fuga voluptates voluptates id sequi ipsam. Ut ea et delectus magni optio. Eligendi ut a id tempora.', 91, '1981-12-03 01:40:30', '2009-05-12 15:04:41');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (92, 92, 'Nihil commodi ipsam dolorem itaque est. Consequatur accusamus perferendis reprehenderit voluptatibus natus. Sequi ad et eos incidunt.', 92, '2007-02-20 18:37:07', '1995-03-14 06:01:23');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (93, 93, 'Omnis est at amet qui neque quae sapiente. Amet quis et rerum unde. Et voluptatem rerum ducimus pariatur.', 93, '1972-08-19 01:12:55', '2017-08-14 08:59:08');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (94, 94, 'Beatae quia voluptatibus molestiae qui. Nobis corporis molestiae id magnam. Sed sint omnis non nihil. Ipsam beatae et dolor veniam porro accusantium.', 94, '2004-12-14 19:40:45', '1998-11-30 14:45:51');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (95, 95, 'Illo omnis et fugiat dolor et. Perspiciatis dolore aut eum iste ducimus. Ut deleniti earum nostrum vel iusto placeat quisquam quod. Qui quaerat aut inventore in qui.', 95, '2006-12-15 06:50:21', '2014-10-27 20:20:01');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (96, 96, 'Velit est quibusdam expedita. Sit voluptas error tempora voluptates facere dolor facere. Qui velit sed ratione et. Hic repellat voluptatum ullam veniam.', 96, '1990-04-15 12:22:41', '1983-12-15 05:48:56');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (97, 97, 'Sed ut culpa modi. Esse qui qui omnis expedita veniam enim magnam. Nihil velit distinctio nihil. Ut maxime quia dicta vel.', 97, '2001-05-27 00:53:29', '1988-10-09 10:09:42');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (98, 98, 'Iusto officiis doloribus quam minus. Dolore expedita nulla ipsam et sed aut expedita. Eos ipsam molestiae eos voluptas.', 98, '2003-02-11 11:02:54', '1994-11-01 00:38:29');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (99, 99, 'Necessitatibus aut aut sunt impedit et. Blanditiis sed corrupti ut voluptas. Neque reprehenderit asperiores sapiente voluptatem perferendis modi. Nam earum laudantium esse aut in.', 99, '2020-03-26 10:04:02', '1976-08-04 06:37:57');
INSERT INTO `comments` (`id`, `item_id`, `text`, `user_id`, `created_at`, `updated_at`) VALUES (100, 100, 'Unde et fuga iusto nulla quia. Repellendus dolor dolorem a. Est sed totam quae eos qui et architecto qui.', 100, '1996-04-29 12:05:38', '1992-09-06 22:00:03');

SELECT * FROM comments;

INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (1, 1, '1998-06-02 20:05:25', 1);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (2, 2, '2007-12-23 20:18:51', 2);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (3, 3, '2002-06-16 20:39:28', 3);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (4, 4, '1981-05-16 20:00:55', 4);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (5, 5, '2001-07-30 13:10:45', 5);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (6, 6, '1994-01-28 21:44:16', 6);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (7, 7, '2001-01-28 13:29:58', 7);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (8, 8, '2018-05-26 07:14:12', 8);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (9, 9, '1972-05-03 15:35:56', 9);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (10, 10, '2020-01-22 07:54:10', 10);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (11, 11, '2001-01-26 20:50:49', 11);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (12, 12, '2019-07-12 04:06:14', 12);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (13, 13, '2019-09-11 03:21:05', 13);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (14, 14, '1970-01-12 09:41:57', 14);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (15, 15, '1980-07-19 17:45:31', 15);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (16, 16, '1982-02-28 08:57:38', 16);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (17, 17, '2009-06-09 20:52:01', 17);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (18, 18, '1979-01-04 16:35:40', 18);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (19, 19, '1979-12-29 06:45:05', 19);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (20, 20, '2000-05-15 12:31:35', 20);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (21, 21, '1985-08-07 03:12:52', 21);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (22, 22, '2001-06-13 10:32:23', 22);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (23, 23, '1982-04-01 02:52:41', 23);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (24, 24, '1979-08-31 08:20:13', 24);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (25, 25, '2001-02-10 19:35:42', 25);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (26, 26, '2005-08-14 21:02:03', 26);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (27, 27, '1991-05-05 07:57:12', 27);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (28, 28, '2016-12-22 12:27:43', 28);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (29, 29, '1992-11-15 11:55:17', 29);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (30, 30, '1974-12-04 07:22:32', 30);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (31, 31, '1989-04-06 20:38:04', 31);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (32, 32, '1992-05-12 15:08:03', 32);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (33, 33, '1987-12-28 12:17:43', 33);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (34, 34, '1992-05-11 18:35:59', 34);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (35, 35, '1993-03-13 17:15:51', 35);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (36, 36, '1993-05-24 16:39:23', 36);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (37, 37, '2015-10-30 20:07:44', 37);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (38, 38, '2020-06-25 15:37:46', 38);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (39, 39, '1999-12-19 05:06:56', 39);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (40, 40, '2016-03-08 09:33:54', 40);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (41, 41, '1995-04-14 07:12:23', 41);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (42, 42, '1990-11-30 19:47:15', 42);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (43, 43, '1999-10-06 11:03:01', 43);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (44, 44, '1984-12-31 16:14:33', 44);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (45, 45, '1986-06-08 16:44:19', 45);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (46, 46, '1973-09-26 03:52:27', 46);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (47, 47, '1993-12-06 16:02:05', 47);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (48, 48, '1996-01-04 03:57:04', 48);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (49, 49, '1983-12-22 22:53:59', 49);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (50, 50, '1999-08-20 22:45:53', 50);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (51, 51, '2017-10-26 17:40:45', 51);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (52, 52, '1999-10-28 23:37:21', 52);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (53, 53, '1994-07-27 20:28:52', 53);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (54, 54, '2000-03-09 08:50:54', 54);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (55, 55, '2002-07-13 19:10:10', 55);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (56, 56, '1998-06-12 21:49:17', 56);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (57, 57, '1997-11-12 06:11:55', 57);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (58, 58, '1988-09-07 19:47:59', 58);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (59, 59, '2002-11-06 10:53:22', 59);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (60, 60, '2017-08-23 09:38:13', 60);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (61, 61, '1999-01-13 18:54:02', 61);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (62, 62, '1980-07-01 12:09:45', 62);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (63, 63, '1977-04-13 21:31:11', 63);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (64, 64, '2016-03-06 14:02:02', 64);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (65, 65, '1991-12-02 18:31:27', 65);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (66, 66, '1990-06-14 12:44:52', 66);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (67, 67, '2020-07-31 10:32:46', 67);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (68, 68, '1973-10-20 11:56:08', 68);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (69, 69, '1978-09-02 06:12:39', 69);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (70, 70, '1993-05-09 06:47:30', 70);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (71, 71, '1993-01-13 23:54:01', 71);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (72, 72, '2006-04-24 21:44:44', 72);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (73, 73, '2007-07-13 18:26:45', 73);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (74, 74, '2006-02-08 16:09:34', 74);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (75, 75, '1983-08-08 18:50:46', 75);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (76, 76, '2007-08-07 03:38:50', 76);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (77, 77, '1982-05-26 17:48:37', 77);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (78, 78, '2015-08-03 16:37:20', 78);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (79, 79, '2019-11-21 11:01:12', 79);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (80, 80, '2019-12-30 20:52:19', 80);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (81, 81, '2014-09-18 01:21:34', 81);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (82, 82, '1983-03-23 13:15:49', 82);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (83, 83, '2018-11-04 19:07:08', 83);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (84, 84, '1993-01-27 23:06:22', 84);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (85, 85, '1978-08-06 23:53:17', 85);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (86, 86, '2019-02-26 12:11:55', 86);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (87, 87, '1975-01-28 05:50:06', 87);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (88, 88, '2012-03-16 13:10:12', 88);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (89, 89, '1988-07-30 15:39:35', 89);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (90, 90, '2016-08-28 02:10:02', 90);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (91, 91, '1981-08-10 19:16:51', 91);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (92, 92, '1989-04-27 16:37:02', 92);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (93, 93, '2010-11-13 03:10:30', 93);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (94, 94, '1971-02-17 07:48:25', 94);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (95, 95, '1983-03-13 22:15:35', 95);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (96, 96, '1988-07-21 16:07:28', 96);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (97, 97, '2001-06-20 01:31:56', 97);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (98, 98, '2011-04-22 15:44:18', 98);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (99, 99, '1995-10-01 11:37:47', 99);
INSERT INTO `likes` (`id`, `user_id`, `created_at`, `comment_id`) VALUES (100, 100, '1999-09-04 07:40:59', 100);

SELECT * FROM likes;

-- 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
SELECT role_id, COUNT(id) FROM users 
	GROUP BY role_id; -- выборка показывающая количество пользователей по ролям
	
SELECT i.id, i.name, c.id , c.text
	FROM item i
		LEFT JOIN
			comments c
		ON c.item_id = i.id; 
		-- выборка показывающая комментарии к сущностям, часто используется, потому что обычно в комментариях игроки узнают
		-- важную информацию о конкретной сущности(как пройти босса, получить вещь, достижение, квест)

SELECT m.id, m.media_type_id 
	FROM media m
		WHERE item_id IN (SELECT id FROM item i WHERE item_type_id = (SELECT it.id FROM item_types it WHERE it.name = 'Dungeons'));  
		-- выборка видео из подземелий, часто используется для просмотра видео прохождений
	
-- 7. представления (минимум 2);
CREATE VIEW item_type_count AS SELECT  it.name, count(1) FROM item i JOIN item_types it ON it.id = i.item_type_id GROUP BY i.item_type_id ;
SELECT * FROM item_type_count;

SELECT i.name, c.`text`  from item i LEFT JOIN comments c ON c.item_id = i.id;
CREATE VIEW item_comments AS SELECT i.name, c.`text`  from item i LEFT JOIN comments c ON c.item_id = i.id;

SELECT * FROM item_comments;

-- 8. хранимые процедуры / триггеры;

CREATE PROCEDURE `wowhead`.`ADD_VERSION`(IN `versionName` VARCHAR(150), IN `startTime` DATETIME)
BEGIN
	INSERT INTO `wowhead`.`game_versions` VALUES(`versionName`,`startTime`,NOW());
END

-- удаляет сущности при удалении определенного типа.
DELIMITER //
CREATE TRIGGER `delete_items` BEFORE DELETE ON `item_types`
FOR EACH ROW BEGIN
  DELETE FROM `item` WHERE `item`.`item_id`=OLD.`id`;
END // 
DELIMITER ;