##每周日刷一次上周，存到ranks表
INSERT INTO ranks(uid,nickname,distance,score,total_score,guai,weeks)
SELECT n.uid,a.nickname,n.oneDistance,n.oneSocre,n.oneAllsocre,n.oneGuai,WEEK(CURDATE())-1
FROM
(
SELECT MAX(id) AS id,p.uid,p.oneAllsocre
FROM
(SELECT uid,MAX(oneAllsocre) AS oneAllsocre
FROM `one_game_log`
WHERE  posttime BETWEEN SUBDATE(CURDATE(),6) AND NOW()AND valid=1
GROUP BY uid) p
JOIN `one_game_log` l ON l.uid=p.uid AND l.oneAllsocre=p.oneAllsocre
GROUP BY p.uid,p.oneAllsocre
) s
JOIN `accountusers` a ON s.uid = a.uid
JOIN `one_game_log` n ON n.id = s.id
ORDER BY n.oneAllsocre DESC
LIMIT 0,100;


##取上周ranks表排名
SELECT @a:=IFNULL(@a,0)+1 ASrankid,uid,nickname,distance,score,total_score
FROM (
SELECTuid,nickname,distance,score,total_score,guai,@a:=0
FROM ranks
WHERE weeks =IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE())) -1
) t
ORDER BY total_score DESC

##取某人上周排名
##设入参i_uid为所取用户标志
SELECT rankid
FROM
(
SELECT @a:=IFNULL(@a,0)+1 ASrankid,uid,nickname,distance,score,total_score
FROM (
SELECTuid,nickname,distance,score,total_score,guai,@a:=0
FROM ranks
WHERE weeks =IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE())) -1
) t
ORDER BY total_score DESC) src
WHERE uid =i_uid





##查询用户本周最高积分，有可能返回空行
##设i_uid为用户标志入参
SELECT total_score
FROM `cur_week_score` 
WHERE uid=i_uid


##如果是本周最高积分就插入
##UID为主键，如果该用户本周最高积分已经存在，则直接替换，
##所以必须程序先判断修改后的积分是最高积分
REPLACE INTO cur_week_score(uid,nickname,distance,score,total_score,guai) 
SELECT uid,nickname,4226,43437,85697,29
FROM accountusers 
WHERE uid=1903

##定时器每周清理上周积分(周一0点执行)
TRUNCATE TABLE cur_week_score;


##取实时排行榜
##设入参num,num为每次取的记录数
##设入参temp_id，temp_id为每次取的开始名次数(最小为1)
SELECT @a:=IFNULL(@a,temp_id-1)+1 AS rankid,`uid` ,`nickname` ,`distance` ,`score` ,`total_score` ,`guai` 
FROM cur_week_score s JOIN (SELECT @a:=0) a
ORDER BY s.total_score DESC
LIMIT temp_id,num;

##查询用户当前的排名
##设入参i_uid为所取用户标志 
SELECT rankid,`uid` ,`nickname` ,`distance` ,`score` ,`total_score` ,`guai` 
FROM (
SELECT @a:=IFNULL(@a,0)+1 AS rankid,`uid` ,`nickname` ,`distance` ,`score` ,`total_score` ,`guai` 
FROM cur_week_score s JOIN (SELECT @a:=0) a
ORDER BY s.`total_score` DESC) k
WHERE uid=i_uid

##通过传入用户的排名，获取前后10名
##设入参i_rank为所取用户当前排名
SELECT  rankid,`uid` ,`nickname` ,`distance` ,`score` ,`total_score` ,`guai` 
FROM 
(
SELECT @a:=IFNULL(@a,0)+1 AS rankid,`uid` ,`nickname` ,`distance` ,`score` ,`total_score` ,`guai` 
FROM cur_week_score s JOIN (SELECT @a:=0) a
ORDER BY s.total_score DESC) r
WHERE r.rankid BETWEEN (i_rank-10) AND (i_rank+10)