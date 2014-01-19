##每十分钟统计一次收入并插入收入统计表中
INSERT INTO `stat_money`(game_id,amount,postdate,posttime)
SELECT 100,
       IF(0=(SELECT COUNT(1) FROM `charge` WHERE buytime>=CURDATE() AND buyresult=3),
          0,
          (SELECT IFNULL(SUM(buyprice)/100,0) FROM `charge` WHERE buytime>=CURDATE() AND buyresult=3 GROUP BY gameid)),
       CURDATE(),
       CURTIME()

##################################
##查询某款游戏收入曲线
##设入参i_gameid 是游戏标志
##设入参i_postdate是查询曲线日期
##################################
SELECT amount,posttime
FROM `stat_money`
WHERE game_id=i_gameid AND postdate=i_postdate ;


##################################
##查询历史收入曲线（以天为单位）
##设入参i_gameid 是游戏标志
##设入参i_start是开始查询曲线日期
##设入参i_end是结束查询曲线日期
##################################
SELECT game_id,postdate,MAX(amount) AS amount
FROM `stat_money`
WHERE game_id=i_gameid AND postdate BETWEEN i_start AND i_end
GROUP BY game_id,postdate


##每十分钟统计一次注册人数并插入用户统计表中
INSERT INTO `stat_users`(channel,register_amount,postdate,posttime)
SELECT channel,COUNT(1),CURDATE(),CURTIME()
FROM `accountusers` 
WHERE `registertime`>=CURDATE()
GROUP BY channel;

##################################
##查询单日各渠道注册人数
##设入参i_postdate是查询曲线日期
##设入参i_channel是渠道号
##################################

##No.1  一个界面中显示一个渠道
SELECT register_amount,posttime
FROM `stat_users`
WHERE postdate=i_postdate AND channel=i_channel
ORDER BY posttime;
##No.1  一个界面中显示多个渠道
SELECT channel,register_amount,posttime
FROM `stat_users`
WHERE postdate=i_postdate 
ORDER BY channel,posttime;

##################################
##查询单日注册总人数
##设入参i_postdate是查询曲线日期
##################################
SELECT SUM(register_amount),posttime
FROM `stat_users`
WHERE postdate=i_postdate
GROUP BY posttime
ORDER BY posttime;


##################################
##查询历史注册人数（以天为单位）
##设入参i_start是开始查询曲线日期
##设入参i_end是结束查询曲线日期
##################################
SELECT postdate,channel,MAX(register_amount) AS amount
FROM stat_users
WHERE postdate BETWEEN i_start AND i_end
GROUP BY postdate,channel


