##如果末位是：2.0.1.4  抽奖50钻石
SELECT DISTINCT uid
FROM one_game_log
WHERE posttime BETWEEN '2014-2-18 00:00:00' AND '2014-2-19 23:59:59'
AND oneAllsocre >=1000 AND RIGHT(oneAllsocre,1) IN (2,0,1,4);

##如果最后两位是：14 抽奖100钻石
SELECT DISTINCT uid
FROM one_game_log
WHERE posttime BETWEEN '2014-2-18 00:00:00' AND '2014-2-19 23:59:59'
AND oneAllsocre >=1000 AND RIGHT(oneAllsocre,2)=14;



##如果最后三位是：014 抽奖10话费

SELECT DISTINCT uid
FROM one_game_log
WHERE posttime BETWEEN '2014-2-18 00:00:00' AND '2014-2-19 23:59:59'
AND oneAllsocre >=1000 AND RIGHT(oneAllsocre,3)='014';

##如果最后四位是：2014 抽奖50话费

SELECT DISTINCT uid
FROM one_game_log
WHERE posttime BETWEEN '2014-2-18 00:00:00' AND '2014-2-19 23:59:59'
AND RIGHT(oneAllsocre,4)=2014;
