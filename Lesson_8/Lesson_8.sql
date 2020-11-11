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

SELECT * FROM target_types tt ;
SELECT * FROM likes;

SELECT SUM(got_likes) AS total_likes_for_youngest
  FROM (   
    SELECT COUNT(target_types.id) AS got_likes 
      FROM profiles
        LEFT JOIN likes
          ON likes.target_id = profiles.user_id
        LEFT JOIN target_types
          ON likes.target_type_id = target_types.id
            AND target_types.name = 'users'
      GROUP BY profiles.user_id
      ORDER BY profiles.birthday DESC
      LIMIT 10
) AS youngest;

-- 5. Ќайти 10 пользователей, которые про€вл€ют наименьшую активность в использовании социальной сети
SELECT users.id,
  COUNT(DISTINCT messages.id) + 
  COUNT(DISTINCT likes.id) + 
  COUNT(DISTINCT media.id) AS activity 
  FROM users
    LEFT JOIN messages 
      ON users.id = messages.from_user_id
    LEFT JOIN likes
      ON users.id = likes.user_id
    LEFT JOIN media
      ON users.id = media.user_id
  GROUP BY users.id
  ORDER BY activity
  LIMIT 10;

