##每周日刷一次上周，存到ranks表
INSERT INTO ranks(rankid,uid,nickname,distance,score,total_score,guai,weeks)
SELECT @a:=IFNULL(@a,0)+1 AS rankid,  n.uid,a.nickname,n.oneDistance,n.oneSocre,n.oneAllsocre,n.oneGuai,WEEK(CURDATE())-1
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),6) AND NOW() 
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
##LIMIT 0,100;

##取上周ranks表排名
SELECT rankid,uid,nickname,distance,score,total_score,guai
FROM ranks 
WHERE weeks = IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE())) - 1
ORDER BY rankid
LIMIT 0,100;

##取某人上周排名
##设入参i_uid为所取用户标志
SELECT rankid
FROM ranks 
WHERE weeks = IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-2,WEEK(CURDATE())-1) AND uid = i_uid;


##取实时排行榜
##设入参num,num为每次取的记录数
##设入参temp_id，temp_id为每次取的开始名次数(最小为1)
SELECT @a:=IFNULL(@a,temp_id-1)+1 AS rankid,  n.uid,a.nickname,n.oneDistance,n.oneSocre,n.oneAllsocre,n.oneGuai
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),IF(DAYOFWEEK(CURDATE())=1,6,DATE_FORMAT(CURDATE(),'%w')-1)) AND NOW()
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT temp_id,num;

##查询用户当前的排名(未取详细信息)
##设入参i_uid为所取用户标志 
SELECT k.rankid
FROM (
SELECT @a:=IFNULL(@a,0)+1 AS rankid,n.uid
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),IF(DAYOFWEEK(CURDATE())=1,6,DATE_FORMAT(CURDATE(),'%w')-1)) AND NOW()
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT 1,1000000) k
WHERE k.uid=i_uid
##通过传入用户的排名，获取前后10名
##设入参i_rank为所取用户当前排名
SELECT r.rankid,r.uid,r.nickname,r.oneDistance,r.oneSocre,r.oneAllsocre,r.oneGuai
FROM 
(
SELECT @a:=IFNULL(@a,0)+1 AS rankid,n.uid,a.nickname,n.oneDistance,n.oneSocre,n.oneAllsocre,n.oneGuai
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),IF(DAYOFWEEK(CURDATE())=1,6,DATE_FORMAT(CURDATE(),'%w')-1)) AND NOW()
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT 1,1000000) r
WHERE r.rankid BETWEEN (i_rank-10) AND (i_rank+10)

