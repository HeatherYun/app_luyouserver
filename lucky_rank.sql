## 幸运榜每周更新脚本(周一0点执行),应该可以放在同一个定时器里面吧……
##NO1
INSERT INTO rank_lucky(lucky_id,weeks)
SELECT id,WEEK(NOW())
FROM sys_config_rank_lucky

##NO2
INSERT rank_lucky_jackpot(weeks,num) VALUES(WEEK(NOW()),0)



##打榜,是否达到打榜条件由服务端那边判断吧
##i_id为打榜榜单编号,i_uid为用户编号,i_score为分数
UPDATE rank_lucky
SET uid=i_uid
   ,`status`=2
WHERE weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE()))
  AND lucky_id=i_id
  AND `status` IN (1,2)
  AND score<i_score

##霸占
##i_id为打榜榜单编号,i_uid为用户编号
UPDATE rank_lucky
SET `status`=3
WHERE weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE()))
  AND lucky_id=i_id
  AND uid=i_uid
  AND `status`=2


##查找上周幸运榜获奖用户
SELECT l.lucky_id,s.lucky_name,s.sort_id,s.summary,l.uid
FROM rank_lucky l JOIN sys_config_rank_lucky s ON s.id=l.lucky_id
WHERE l.weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-2,WEEK(CURDATE())-1)
  AND `status` IN (2,3)
  

##查找本周幸运榜用户
SELECT l.lucky_id,l.uid
FROM rank_lucky l 
WHERE l.weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE()))


##读取幸运榜配置
SELECT id,lucky_name,sort_id,score,consume_type,consume_num,grab_num,grab_add,summary
FROM sys_config_rank_lucky
WHERE is_show=1

##增加奖池奖金
##i_num为增加的奖金数
UPDATE rank_lucky_jackpot
SET num=+i_num
WHERE weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE()))

##读取当前奖池奖金
SELECT num 
FROM rank_lucky_jackpot
WHERE weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-1,WEEK(CURDATE()))

##读取上周奖池奖金
SELECT num 
FROM rank_lucky_jackpot
WHERE weeks=IF(DAYOFWEEK(CURDATE())=1,WEEK(CURDATE())-2,WEEK(CURDATE())-1)