##查找钻石计费点
##设入参为i_channel
SELECT `index` 
FROM `sys_config_zuanshi` 
WHERE channel = (CASE WHEN 0 = (SELECT COUNT(1) FROM `sys_config_zuanshi` WHERE channel = i_channel) THEN 101 ELSE i_channel END)