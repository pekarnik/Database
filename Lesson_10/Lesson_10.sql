-- 1. ���������������� ����� ������� ����� ����������� ��������
-- ����� � �������� ������ ���������� � �������� ����������� �������.

CREATE INDEX user_media_idx ON media(user_id);
CREATE INDEX user_id_friend_idx ON friendships(user_id,friend_id);

-- ����� ���� ����� � ���������� ����� ������� ����������, ������ ������������, �������������� ������� �� ��� ����� �������� �����������

-- 2. ������� �� ������� �������
-- ��������� ������, ������� ����� �������� ��������� �������:
-- ��� ������
-- ������� ���������� ������������� � �������
-- ����� ������� ������������ � ������
-- ����� ������� ������������ � ������
-- ����� ���������� ������������� � ������
-- ����� ������������� � �������
-- ��������� � ��������� (����� ���������� ������������� � ������ / ����� ������������� � �������) * 100

SELECT 
	DISTINCT c.name,
	YEAR(CURRENT_DATE) - YEAR(MAX(birthday) OVER w)  AS youngest_user,
	YEAR(CURRENT_DATE) - YEAR(MIN(birthday) OVER w)  AS oldest_user, -- ��� ���������� ����� ������-�� ���������� ������ ������ - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
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