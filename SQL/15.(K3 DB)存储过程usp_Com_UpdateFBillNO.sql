SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Com_UpdateFBillNO]
	@intFtrantype as int
AS
BEGIN   TRANSACTION   
BEGIN
	SET NOCOUNT ON; 
	DECLARE @ERROR INT
	SET @ERROR = 0
	
	UPDATE t_BillCodeRule
	SET    FProjectVal = FProjectVal + 1
	WHERE  FBillTypeID = @intFtrantype
	       AND FClassIndex = 2
	
	SET @ERROR = @ERROR + @@ERROR 
	
	UPDATE ICBillNo
	SET    FCurNo = FCurNo + 1
	WHERE  FBillID = @intFtrantype
	
	SET @ERROR = @ERROR + @@ERROR 
	UPDATE A
	SET    FDesc = A.FPreLetter + '+' + RIGHT(
	           CAST('000000' + CAST((A.FCurNo + 1) AS VARCHAR) AS VARCHAR),
	           6
	       )
	FROM   ICBillNo A
	WHERE  A.FBillID = @intFtrantype
	       AND A.FPreLetter <> ''
	
	SET @ERROR = @ERROR + @@ERROR
END
IF @ERROR = 0
BEGIN
    COMMIT TRANSACTION
END
ELSE
BEGIN
    ROLLBACK TRANSACTION
END   