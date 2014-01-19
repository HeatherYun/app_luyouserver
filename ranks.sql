##每周日刷一次前100名，存到ranks表
INSERT INTO ranks(rankid,uid,nickname,distance,score,total_score,guai,weeks)
SELECT @a:=IFNULL(@a,0)+1 AS rankid,  n.uid,a.nickname,n.oneDistance,n.oneSocre,n.oneAllsocre,n.oneGuai,WEEK(CURDATE()-1)
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),6) AND NOW() AND modelType = 2
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT 0,100;

##取上周ranks表排名
SELECT rankid,uid,nickname,distance,score,total_score,guai
FROM ranks 
WHERE weeks = IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE())) - 1;

##取某人上周排名
##设入参i_uid为所取用户标志
SELECT rankid
FROM ranks 
WHERE weeks = IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE())) AND uid = i_uid;


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
WHERE  posttime BETWEEN SUBDATE(CURDATE(),IF(DAYOFWEEK(CURDATE())=1,6,DATE_FORMAT(CURDATE(),'%w')-1)) AND NOW() AND modelType = 2
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre= p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT temp_id,num;


