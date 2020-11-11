use vk;


SELECT p2.gender, COUNT(*)
	FROM 
		likes l 
		JOIN
		profiles p2 
	ON l.user_id = p2.user_id
		AND p2.gender IN ('M','P')
	GROUP BY p2.gender;
-- 4. ѕодсчитать общее количество лайков дес€ти самым молодым пользовател€м (сколько лайков получили 10 самых молодых пользователей).

SELECT SUM(likes) FROM(SELECT COUNT(l.target_id) AS likes
	FROM 
		profiles p
		LEFT JOIN
		likes l 
	ON p.user_id = l.target_id 
	GROUP BY p.user_id
	ORDER BY p.birthday DESC
	LIMIT 10) AS count_likes;

-- 5. Ќайти 10 пользователей, которые про€вл€ют наименьшую активность в использовании социальной сети
SELECT u.first_name ,u.last_name, COUNT(l.id)+COUNT(p.id)+COUNT(m.id) as activity
	FROM users u
	LEFT JOIN 
		likes l
			ON u.id = l.user_id
	LEFT JOIN 
		posts p
			ON u.id = p.user_id
	LEFT JOIN 
		media m
			ON u.id = m.user_id
	GROUP BY u.id
	ORDER BY activity LIMIT 10;

