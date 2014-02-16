#当用户登录时，根据UID查询用户连续登录天数和最后更新时间
#1、如果最后更新时间是昨天，连续登录天数加1
#2、如果最后更新时间是昨天以前，连续登录天数置为1
#3、如果最后更新时间是今天，不做操作
#4、如果没有记录，插入一条UID

#######################################
# 根据UID查询用户连续登录天数和最后更新时间
# 设入参i_uid为用户标识
#######################################
SELECT CASE WHEN posttime < CURDATE() THEN days+1 ELSE days END AS days,posttime,CASE WHEN posttime < CURDATE() THEN 0 ELSE is_send END AS is_send
FROM `activity_login_send`
WHERE uid=i_uid

#######################################
# 更新用户登录天数和领取状态
# 设入参i_uid为用户标识
# 设入参i_send为用户领取状态
#######################################
INSERT INTO activity_login_send (uid,is_send) 
VALUES (i_uid,i_send) ON DUPLICATE KEY UPDATE days=CASE WHEN posttime BETWEEN DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) AND DATE_ADD(CURRENT_DATE(),INTERVAL -1 SECOND) AND days<7 THEN days+1 
              WHEN posttime < DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY) THEN 1  
              ELSE days END,is_send=i_send




