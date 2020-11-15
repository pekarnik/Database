-- 1. Проанализировать какие запросы могут выполняться наиболее
-- часто в процессе работы приложения и добавить необходимые индексы.

CREATE INDEX user_media_idx ON media(user_id);
CREATE INDEX user_id_friend_idx ON friendships(user_id,friend_id);

-- Думаю чаще всего в социальных сетях смотрят фотографии, друзей пользователя, соответственно индексы на это будут наиболее актуальными

-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT 
	DISTINCT c.name,
	YEAR(CURRENT_DATE) - YEAR(MAX(birthday) OVER w)  AS youngest_user,
	YEAR(CURRENT_DATE) - YEAR(MIN(birthday) OVER w)  AS oldest_user, -- при добавлении этого почему-то появляются лишние строки - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
	COUNT(cu.user_id) OVER w AS users_in_group,
	COUNT(1) OVER () AS all_users,
	COUNT(cu.user_id) OVER w / COUNT(1) OVER () * 100 AS `percentage`
		FROM 
		profiles p
		LEFT JOIN 
		communities_users cu
			ON cu.user_id = p.user_id 
		LEFT JOIN 
		communities c
			ON c.id = cu.community_id 
			WINDOW w AS (PARTITION BY cu.community_id);
			
SELECT COUNT(cu.user_id) FROM communities_users cu
	GROUP BY cu.community_id ;