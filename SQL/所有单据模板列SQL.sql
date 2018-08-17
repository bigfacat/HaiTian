select * from t_SubMessage

select * from t_SubMesType

SELECT * FROM ICTransactionType AS it  --所有单据的描述

SELECT * FROM ICTemplateEntry AS i WHERE i.FID = 'Z02' --模板表体字段描述

SELECT * FROM ICTemplate AS i WHERE i.FID = 'Z02' --模板表头字段描述

SELECT * FROM t_systemprofile

select * from T_ZhuangXiangInfor

DELETE  FROM  T_BarCodeSerial where FBillNO='CHG007934'

--DELETE FROM T_BarCodeSerial_B WHERE FBillNO='CHG007933'
SELECT  * FROM  T_ZhuangXiangInfor_B


SELECT * FROM T_XiangSerial

select * from T_BarCodeSerial where FBillNO='CHG007934'
select * from T_BarCodeSerial_B where FBillNO='CHG007932'

EXEC sp_addlinkedserver 'KISWMSServer','','SQLOLEDB','121.41.176.47 

,30007'   --对方服务器
EXEC sp_addlinkedsrvlogin 'WMSServer','false',NULL,'sa','GYsoft@123'

