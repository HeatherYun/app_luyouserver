##随机生成挑战用户
SELECT t1.uid 
FROM `accountusers` AS t1 
  JOIN (SELECT ROUND(RAND() * ((SELECT MAX(uid) FROM `accountusers`)-1000)+1000) AS uid) AS t2 WHERE t1.uid >= t2.uid AND LENGTH(t1.`nickname`) > 0 
ORDER BY t1.uid LIMIT 1;