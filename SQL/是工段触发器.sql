alter  TRIGGER [dbo].[SHWorkBill_Update] ON [dbo].[SHWorkBill]
FOR Update
AS
if Update(FStatus)
--增加判断，此触发器只有在修改FStatus字段时才需要触发。
Begin
    Declare @insFStatus int,
	        @DelFstatus int
	select @InsFstatus=FStatus from  INSERTED
	select @DelFstatus=FStatus from  DELETED
  
	IF @insFStatus = 1 AND @DelFstatus =0
	BEGIN
		SET XACT_ABORT ON
		DECLARE @intTranCount INT
		SET @intTranCount = 0;
		SET @intTranCount = @@TRANCOUNT;
		
		BEGIN TRY
		
		BEGIN TRAN;
			DECLARE @intFInterID INT,@FOperID int ,@var01 int,@FICMOInterID int ,@FRoutingID int,@var02 int,@FEntry int

			SELECT @intFInterID = FInterID,@FICMOInterID=FICMOInterID FROM INSERTED

			select @FRoutingID=FRoutingID from icmo where FInterID =@FICMOInterID
			--print @intFInterID
			--print @FRoutingID
			--print @FICMOInterID
		    -- print @InsFstatus
            -- print @DelFstatus
			--	ROLLBACK TRAN;
			--return

		DECLARE C CURSOR LOCAL FORWARD_ONLY FAST_FORWARD READ_ONLY FOR  		
  			select FOperID,isnull(FEntrySelfz0374,0),FEntryID from SHWorkBillEntry  where FinterID = @intFInterID
  		OPEN C
  		FETCH NEXT FROM C INTO @FOperID,@var01,@FEntry
  		WHILE @@FETCH_STATUS = 0
  		BEGIN
		       if(@var01=0 ) 
			   begin 
	
			     select @var02=isnull(FEntrySelfZ0236,0)  from t_RoutingOper where FInterID=@FRoutingID and FOperID=@FOperID
				 update SHWorkBillEntry set FEntrySelfz0374=@var02 where FinterID=@intFInterID and FEntryID=@FEntry
			   end 
		
		       FETCH NEXT FROM C INTO @FOperID,@var01,@FEntry
  		END
  		CLOSE C
  		DEALLOCATE C
				COMMIT TRAN;
				
		END TRY
		BEGIN CATCH

				ROLLBACK TRAN;
			
		END CATCH
	END

End
