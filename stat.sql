##每十分钟统计一次收入并插入收入统计表中
INSERT INTO `stat_money`(game_id,amount,postdate,posttime)
SELECT 100,
       IF(0=(SELECT COUNT(1) FROM `charge` WHERE buytime>=CURDATE() AND buyresult=3),
          0,
          (SELECT IFNULL(SUM(buyprice)/100,0) FROM `charge` WHERE buytime>=CURDATE() AND buyresult=3 GROUP BY gameid)),
       CURDATE(),
       CURTIME()

##定点0点之后统计前一天数据
INSERT INTO `stat_money`(game_id,amount,postdate,posttime)
SELECT 100,
       IF(0=(SELECT COUNT(1) FROM `charge` WHERE buytime>=CURDATE() AND buyresult=3),
          0,
          (SELECT IFNULL(SUM(buyprice)/100,0) 
           FROM `charge` 
           WHERE buytime BETWEEN DATE_ADD(CURDATE(),INTERVAL -1 DAY) AND DATE_ADD(CURDATE(),INTERVAL -1 SECOND) AND buyresult=3 
           GROUP BY gameid)),
       DATE_ADD(CURDATE(),INTERVAL -1 DAY),
       '23:59:59'


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


INSERT INTO `stat_users`(channel,register_amount,postdate,posttime)
SELECT channel,COUNT(1) AS register_amount,CURDATE() AS postdate,CURTIME() AS posttime
FROM `accountusers` 
WHERE `registertime` >=CURDATE()
GROUP BY channel
UNION 
SELECT 0,0,CURDATE(),CURTIME()

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
##查询每日渠道总计
SELECT channel,SUM(register_amount) AS register_amount
FROM `stat_users`
WHERE postdate=i_postdate
GROUP BY channel;

##################################
##查询单日注册总人数
##设入参i_postdate是查询曲线日期
##################################
SELECT SUM(register_amount) AS register_amount,posttime
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




##统计昨日付费用户情况
INSERT INTO stat_pay(amount1,amount2,amount3,amount4,amount5,postdate)
SELECT COUNT(1),
  SUM(CASE WHEN buyprice>=500 THEN 1 ELSE 0 END),
  SUM(CASE WHEN buyprice>=1000 THEN 1 ELSE 0 END),
  SUM(CASE WHEN buyprice>=5000 THEN 1 ELSE 0 END),
  SUM(CASE WHEN buyprice>=10000 THEN 1 ELSE 0 END),
  DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY)
FROM
(SELECT uid,IFNULL(SUM(buyprice),0) AS buyprice
 FROM `charge`
 WHERE buytime BETWEEN DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) AND DATE_ADD(CURRENT_DATE(),INTERVAL -1 SECOND)
   AND buyresult=3
 GROUP BY uid) t

##################################
##查询某时间段付费用户统计情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##################################
SELECT amount1,amount2,amount3,amount4,amount5,postdate
FROM stat_pay
WHERE postdate BETWEEN i_start AND i_end


##统计昨日各渠道付费情况

INSERT INTO stat_pay_channel(channel,typeid,price,amount,postdate)
 SELECT c.channel,CASE WHEN d.buytype=9999 THEN 1 ELSE 0 END,c.buyprice,COUNT(1) AS amount
   ,DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) 
 FROM `charge` c JOIN dispatch d ON c.orderno=d.orderno
 WHERE c.buytime BETWEEN DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) AND DATE_ADD(CURRENT_DATE(),INTERVAL -1 SECOND)
   AND c.buyresult=3
   GROUP BY c.channel,CASE WHEN d.buytype=9999 THEN 1 ELSE 0 END,c.buyprice



##################################
##查询某渠道某时间段付费情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##设入参i_channel是渠道号
##################################
SELECT typeid,price,amount,postdate
FROM stat_pay_channel
WHERE channel=i_channel AND postdate BETWEEN i_start AND i_end


##################################
##查询某时间段各渠道付费情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##################################
SELECT channel,typeid,price,amount,postdate
FROM stat_pay_channel
WHERE postdate BETWEEN i_start AND i_end

##################################
##查询某时间段总付费情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##################################
SELECT typeid,price,SUM(amount) AS amount,postdate
FROM stat_pay_channel
WHERE postdate BETWEEN i_start AND i_end
GROUP BY typeid,price,postdate


##统计昨日用户游戏局数
INSERT INTO stat_play_count(amount1,amount2,amount3,amount4,amount5,postdate)
SELECT 
  SUM(CASE WHEN allcount>=5 THEN 1 ELSE 0 END),
  SUM(CASE WHEN allcount>=20 THEN 1 ELSE 0 END),
  SUM(CASE WHEN allcount>=50 THEN 1 ELSE 0 END),
  SUM(CASE WHEN allcount>=100 THEN 1 ELSE 0 END),
  SUM(CASE WHEN allcount>=300 THEN 1 ELSE 0 END),
  DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY)
FROM
(SELECT uid,COUNT(1) AS allcount
 FROM `one_game_log`
 WHERE posttime BETWEEN DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) AND DATE_ADD(CURRENT_DATE(),INTERVAL -1 SECOND)
 GROUP BY uid) t


##################################
##查询某时间段用户游戏局数统计情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##################################
SELECT amount1,amount2,amount3,amount4,amount5,postdate
FROM stat_play_count
WHERE postdate BETWEEN i_start AND i_end


##统计昨日钻石消耗情况
INSERT INTO stat_zuanshi_pay(type_id,amount,postdate)
SELECT typeid,IFNULL(SUM(usezuanshi),0)/usezuanshi,DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY)
 FROM `use_zuanshi_log`
 WHERE posttime BETWEEN DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) AND DATE_ADD(CURRENT_DATE(),INTERVAL -1 SECOND)
   AND typeid IN (2,3,50,51,52,53,54,55,56,57,58,100,101,102,103) AND `status`=0
 GROUP BY usezuanshi

##################################
##查询某时间段用户钻石消耗统计情况
##设入参i_start是开始日期
##设入参i_end是结束日期
##################################
SELECT type_id,amount,postdate
FROM stat_zuanshi_pay
WHERE postdate BETWEEN i_start AND i_end


