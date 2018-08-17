SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
DECLARE @FBillNO NVARCHAR(250)
EXEC usp_Com_GetFBillNO 81,@FBillNO OUTPUT
SELECT @FBillNO
*/

CREATE PROCEDURE [dbo].[usp_Com_GetFBillNO]
(
	@FTranType as nvarchar(50),  
	@FBillNO as nvarchar(250) output
)
AS  
BEGIN  

	SET NOCOUNT ON;  
	SET @FBillNO=''  

	DECLARE @FProjectVal nvarchar(2000)  
	SET @FProjectVal = '';

	DECLARE MyCursor_1 CURSOR FOR 
		SELECT RIGHT(cast(power(10,FLength) AS VARCHAR)+FProjectVal,FLength) FProjectVal  
		FROM t_billcoderule a  
		LEFT JOIN t_option e ON a.fprojectid=e.fprojectid and a.fformatindex=e.fid  
		LEFT OUTER JOIN t_checkproject b ON a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield  
		WHERE a.fbilltypeid = @FTranType
		ORDER  BY a.FClassIndex  
	--打开一个游标   
	OPEN MyCursor_1  
	--循环一个游标  
	FETCH NEXT FROM  MyCursor_1 INTO @FProjectVal  
	WHILE @@FETCH_STATUS =0  
	BEGIN  
	  	
		SET @FBillNO= @FBillNO + @FProjectVal  
	     
		FETCH NEXT FROM  MyCursor_1 INTO @FProjectVal  
	END   
	  
	--关闭游标  
	CLOSE MyCursor_1  
	--释放资源  
	DEALLOCATE MyCursor_1  
END