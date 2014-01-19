##每十分钟统计一次收入并插入收入统计表中
INSERT INTO `stat_money`(game_id,channel,amount,postdate,posttime)
SELECT gameid,channel,IFNULL(SUM(buyprice)/100,0),CURDATE(),CURTIME()
FROM `charge` 
WHERE buytime>=CURDATE() AND buyresult=3
GROUP BY gameid,channel;

##################################
##查询某款游戏单日各渠道收入曲线
##设入参i_gameid 是游戏标志
##设入参i_postdate是查询曲线日期
##################################
SELECT channel,amount,posttime
FROM `stat_money`
WHERE game_id=i_gameid AND postdate=i_postdate ;

##################################
##查询游戏单日收入曲线
##设入参i_gameid 是游戏标志
##设入参i_postdate是查询曲线日期
##################################
SELECT SUM(amount),posttime
FROM `stat_money`
WHERE game_id=i_gameid AND postdate=i_postdate
GROUP BY posttime
ORDER BY posttime;


##每十分钟统计一次注册人数并插入用户统计表中
INSERT INTO `stat_users`(channel,register_amount,postdate,posttime)
SELECT channel,COUNT(1),CURDATE(),CURTIME()
FROM `accountusers` 
WHERE `registertime`>=CURDATE()
GROUP BY channel;

##################################
##查询某款游戏单日各渠道注册人数
##设入参i_postdate是查询曲线日期
##设入参i_channel是渠道号
##################################
SELECT channel,register_amount,posttime
FROM `stat_users`
WHERE game_id=i_gameid AND postdate=i_postdate;

##################################
##查询某款游戏单日注册人数
##设入参i_postdate是查询曲线日期
##设入参i_channel是渠道号
##################################
SELECT SUM(register_amount),posttime
FROM `stat_users`
WHERE game_id=i_gameid AND postdate=i_postdate
GROUP BY posttime
ORDER BY posttime;


PS:查询需求要问下文著兄，然后，改结构和补数据，最好是两个人都在的时候改，补数据补多久的？

