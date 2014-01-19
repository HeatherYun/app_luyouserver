##每十分钟统计一次收入并插入收入统计表中
INSERT INTO `stat_money`(game_id,amount,postdate,posttime)
SELECT gameid,IFNULL(SUM(buyprice)/100,0),CURDATE(),CURTIME()
FROM `charge` 
WHERE buytime>=CURDATE() AND buyresult=3
GROUP BY gameid

##刷单日收入曲线
##设入参i_gameid 是游戏标志
##设入参i_postdate是查询曲线日期
EXPLAIN SELECT amount,posttime
FROM `stat_money`
WHERE game_id=i_gameid AND postdate=i_postdate
ORDER BY posttime

##每十分钟统计一次注册人数并插入用户统计表中
INSERT INTO `stat_users`(register_amount,postdate,posttime)
SELECT COUNT(1),CURDATE(),CURTIME()
FROM `accountusers` 
WHERE `registertime`>=CURDATE()

##刷单日注册人数曲线
##设入参i_postdate是查询曲线日期
SELECT register_amount,posttime
FROM `stat_users`
WHERE postdate=i_postdate
ORDER BY posttime


