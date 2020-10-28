use vk;
-- 1. Создать и заполнить таблицы лайков и постов.
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
 
 INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Создать все необходимые внешние ключи и диаграмму отношений.

DESC profiles;

ALTER TABLE profiles MODIFY COLUMN status_id INT UNSIGNED NULL;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_status_id_fk
    FOREIGN KEY (status_id) REFERENCES profile_statuses(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_city_id_fk
    FOREIGN KEY (city_id) REFERENCES cities(id)
      ON DELETE SET NULL;
      
ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;

DESC messages;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

ALTER TABLE posts
	ADD CONSTRAINT posts_communities_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id),
	ADD CONSTRAINT posts_media_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id);
		
ALTER TABLE friendships
	ADD CONSTRAINT friendships_users_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT friendships_friends_id_fk
		FOREIGN KEY (friend_id) REFERENCES users(id),
	ADD CONSTRAINT friendships_status_id_fk
		FOREIGN KEY (status_id) REFERENCES profile_statuses(id);
		
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT COUNT(*) from profiles WHERE gender = 'M';
SELECT COUNT(*) from profiles WHERE gender = 'P';

SELECT CASE
			WHEN (SELECT COUNT(*) from profiles WHERE gender = 'M') > (SELECT COUNT(*) from profiles WHERE gender = 'P')
			THEN 'Мужчин больше'
			WHEN (SELECT COUNT(*) from profiles WHERE gender = 'M') = (SELECT COUNT(*) from profiles WHERE gender = 'P')
			THEN 'Одинаково'
			ELSE 'Женщин больше'
		END AS 'Количество';

-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT COUNT(*) FROM likes WHERE target_id IN (
	SELECT user_id FROM (
-- 	  SELECT
-- 	    ROW_NUMBER() OVER (ORDER BY birthday DESC) AS rownumber,
-- 	    user_id
-- 	  FROM profiles
	  SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
	) AS birthday_rows
-- 	WHERE rownumber <11
); 
-- Вариант в комментариях для стандартной SQL нотации.

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
SELECT * FROM users p2 WHERE id IN(SELECT user_id FROM (SELECT user_id, COUNT(1) AS count_activity FROM
(SELECT user_id FROM posts AS p
UNION ALL
SELECT user_id FROM media AS m
UNION ALL
SELECT user_id FROM likes AS l) AS union_p_m_l
GROUP BY user_id ORDER BY count_activity LIMIT 10) AS rank_users)
;






