VIP 这边我的设计的大概是这样的
VIP表记录用户的VIP日期，读取的时候根据用户VIP的过期日期判断这个用户当前是否是VIP
当这个用户成为VIP的时候使用replace语句进行插入/更新操作，如果他的VIP过期了，不需要做任何操作，就放那里就可以了


##如果用户是第一次成为VIP
##uid为主键，如果该用户原有记录已经存在，则直接替换
##i_uid是用户标志入参，i_postdate是VIP过期时间入参
REPLACE INTO vip(uid,postdate) 
VALUES (i_uid,i_postdate)

##查询某用户当前是否为VIP用户
##i_uid是用户标志入参
##返回值is_vip为1则表示是vip，为0则表示不是vip
SELECT COUNT(1) AS is_vip
FROM vip 
WHERE uid=i_uid AND postdate >= CURRENT_DATE()



##查询VIP用户列表
##返回值is_vip为1则表示是vip，为0则表示不是vip
SELECT uid,case when postdate >= CURRENT_DATE() then 1 else 0 end as is_vip
FROM vip 