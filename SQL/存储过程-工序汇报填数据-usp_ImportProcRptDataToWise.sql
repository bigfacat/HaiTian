SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE usp_ImportProcRptDataToWise
	-- Add the parameters for the stored procedure here
	@FBillNo varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


declare @FInterID varchar(20),@FTranType varchar(20),@FDate varchar(20),@FBillerID varchar(20),@FCheckerID varchar(20),@FCheckDate varchar(20),@FStatus varchar(20),@FICMOInterID varchar(20),@FCancellation varchar(20),@FItemID varchar(20),@FUnitID varchar(20),@FQtyPlan varchar(20),@FAuxQtyPlan varchar(20),@FPlanStartDate varchar(20),@FPlanEndDate varchar(20),@FOperID varchar(20),@FWorkCenterID varchar(20),@FWBInterID varchar(20),@FTaskDispBillID varchar(20),@FQualityChkID varchar(20),@FWBNO varchar(20),@FICMONO varchar(20),@FGMPBatchNo varchar(20),@FCoefficient varchar(20),@FConversion varchar(20),@FOperAuxQtyPlan varchar(20),@FOperAuxQtyFinishTotal varchar(20),@FAutoTD varchar(20),@FAutoOF varchar(20),@FOperMoveNo varchar(20),@FOrderInterID varchar(20),@FOrderEntryID varchar(20),@FOrderBillNo varchar(20),@FMTONo varchar(20),@FCheckStatus varchar(20),@FClassTypeID varchar(20),@FScanWorker1 varchar(20),@FScanWorker2 varchar(20),@FScanFlowCard1 varchar(20),@FScanFlowCard2 varchar(20),@FScanOperSN1 varchar(20),@FScanOperSN2 varchar(20)
		

select 
@FInterID=g.FInterID,@FTranType=g.FTranType,@FDate=g.FDate,@FBillerID=g.FBillerID,@FUnitID=FUnitID,@FItemID=wb.FitemID,@FAuxQtyPlan=g.FAuxQtyPlan,@FPlanStartDate=FPlanStartDate,@FPlanEndDate=FPlanEndDate,@FOperID=FOperID,@FWorkCenterID=FWorkCenterID,@FWBInterID=FWBInterID,@FQualityChkID=FqualityChkID,@FWBNO=FWorkBillNO,@FICMONO=FICMONO,@FICMOInterID=FICMOInterID,@FGMPBatchNo=FGMPBatchNo,@FCoefficient=FCoefficient,@FConversion=FConversion,@FAutoTD=FAutoTD,@FAutoOF=FAutoOF,@FOrderInterID=FOrderInterID,@FOrderEntryID=FOrderEntryID,@FOrderBillNo=FOrderBillNo,@FMTONo=FMTONo 
from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID join SHWorkBillEntry wbe on g.FWBNO=wbe.FWorkBillNO join SHWorkBill wb on wb.FInterID=wbe.FinterID
where g.FCancellation='0' and wbe.FCancellation='0' and wbe.FStatus in (1) and g.FBillNo=@FBillNo
--[FTaskDispBillID] 派工单，[FOperAuxQtyFinishTotal]
--FIsLastReport=1058 and FClassTypeID=1002520 工序流转卡汇报
--FIsLastReport=1059 and FClassTypeID=52 工序汇报
--FAuxQtyfinish,Fqtyfinish,FOperAuxQtyFinish(工序) 单据建立时三个实作数量都会更新
--FAuxQtyPlan,FQtyPlan,FOperAuxQtyPlan(工序),FOperAuxQtyFinishTotal 审核时更新四个数量为所有行号的实作数量之和，反审核时只恢复前三个
--FAuxQtyPlan 工序计划单里有相同字段，不过这里似乎更新的是实作数量而不是工序计划单里的计划数量
insert into SHProcRptMain([FBrNo],[FInterID],[FBillNo],[FTranType],[FDate],[FBillerID],[FCheckerID],[FCheckDate],[FStatus],[FICMOInterID],[FCancellation],[FItemID],[FUnitID],[FQtyPlan],[FAuxQtyPlan],[FPlanStartDate],[FPlanEndDate],[FOperID],[FWorkCenterID],[FWBInterID],[FTaskDispBillID],[FQualityChkID],[FWBNO],[FICMONO],[FGMPBatchNo],[FCoefficient],[FConversion],[FOperAuxQtyPlan],[FOperAuxQtyFinishTotal],[FAutoTD],[FAutoOF],[FOperMoveNo],[FOrderInterID],[FOrderEntryID],[FOrderBillNo],[FMTONo],[FCheckStatus],[FClassTypeID],[FScanWorker1],[FScanWorker2],[FScanFlowCard1],[FScanFlowCard2],[FScanOperSN1],[FScanOperSN2])
values(0,@FInterID,@FBillNo,582,@FDate,@FBillerID,@FBillerID,GETDATE(),1,@FICMOInterID,0,
@FItemID,@FUnitID,@FAuxQtyPlan,@FAuxQtyPlan,@FPlanStartDate,@FPlanEndDate
,@FOperID,@FWorkCenterID,@FWBInterID,0,@FQualityChkID,@FWBNO,@FICMONO,@FGMPBatchNo,@FCoefficient,@FConversion,@FAuxQtyPlan,@FAuxQtyPlan,@FAutoTD,@FAutoOF,'',@FOrderInterID,@FOrderEntryID,@FOrderBillNo,@FMTONo,1059,52,0,0,null,null,0,0)


declare
@FEntryID varchar(20),@Fserial varchar(20),@FworkerID varchar(20),@FdeviceID varchar(20),@FteamID varchar(20),@FstartWorkDate varchar(20),@FEndWorkDate varchar(20),@Fqtyfinish varchar(20),@FAuxQtyfinish int,@FQtypass varchar(20),@FAuxQtyPass varchar(20),@Fqtylost varchar(20),@FAuxQtylost varchar(20),@FQtyback varchar(20),@FAuxQtyBack varchar(20),@FQtyBackPass varchar(20),@FAuxQtyBackPass varchar(20),@FQtyscrap varchar(20),@FAuxQtyscrap varchar(20),@FqtyForItem varchar(20),@FAuxQtyForItem varchar(20),@FqtyHandOver varchar(20),@FAuxQtyHandOver varchar(20),@FqtyReceive varchar(20),@FAuxQtyReceive varchar(20),@FtotalFee varchar(20),@FTimeUnit varchar(20),@FTimeRun varchar(20),@FWorkQty varchar(20),@FTimeMachine varchar(20),@FTimeSetUp varchar(20),@FfinishTime varchar(20),@FreadyTime varchar(20),@FPowerCutTime varchar(20),@FfixTime varchar(20),@FwaitItemTime varchar(20),@FwaitTooltime varchar(20),@Fmemo varchar(20),@FReprocessedQty varchar(20),@FAuxReprocessedQty varchar(20),@FTeamtimeID varchar(20),@FOperAuxQtyFinish varchar(20),@FOperAuxQtyPass varchar(20),@FOperAuxQtyScrap varchar(20),@FOperAuxQtyForItem varchar(20),@FOperAuxReprocessedQty varchar(20),@FAuxRelateQty varchar(20),@FRelateQty varchar(20),@FPlanMode varchar(20),@FHRReadyTime varchar(20),@FEntryIndex varchar(20),@FOperSN varchar(20),@FIsOut varchar(20),@FUniID varchar(20),@FAuxQualifiedReprocessedQty varchar(20),@FOperAuxQualifiedRepQty varchar(20),@FQualifiedReprocessedQty varchar(20),@FOperAuxQtyHandOver varchar(20),@FAuxQtyStockCommit varchar(20),@FQtyStockCommit varchar(20),@FIsLastReport varchar(20),@FFlowCardNO varchar(20),@FFlowCardInterID varchar(20),@FFlowCardEntryID varchar(20),@FMOPlanStartDate varchar(20),@FMOPlanFinishDate varchar(20),@FSourceClassTypeID varchar(20),@FFlowCardNo_Filter varchar(20),@FOperGroupID varchar(20)


declare @MinEntryID int,@MaxEntryID int,@SumFinishQty decimal(8,2)=0
select @FEntryID=MIN(FEntryID),@MaxEntryID=MAX(FEntryID) from t_GXHB g join t_GXHBEntry ge on g.FInterID=ge.FinterID where g.FBillNo=@FBillNo
while (@FEntryID<=@MaxEntryID)
begin
select 
@FworkerID=ge.FworkerID,@FdeviceID=ge.FdeviceID,@FteamID=ge.FteamID,@FTeamtimeID=ge.FTeamtimeID,@FOperGroupID=ge.FOperGroupID,@FstartWorkDate=ge.FstartWorkDate,@FEndWorkDate=ge.FEndWorkDate,@FAuxQtyfinish=ge.FAuxQtyfinish,@FtotalFee=FTotalFee,@FTimeUnit=FTimeUnit,@FTimeRun=FTimeRun,@FWorkQty=FWorkQty,@FTimeMachine=@FAuxQtyfinish*FTimeRun+FTimeSetup,@FTimeSetUp=FTimeSetUp,@FIsOut=FIsOut
from SHWorkBill wb join SHWorkBillEntry wbe on wb.FInterID=wbe.FinterID
join t_GXHB g on g.FWBNO=wbe.FWorkBillNO join t_GXHBEntry ge on g.FInterID=ge.FinterID
where g.FCancellation='0' and wbe.FCancellation='0' and wbe.FStatus in (1) and g.FBillNo=@FBillNo and ge.FEntryID=@FEntryID
--[FstartWorkDate]实际开工时间 [FAuxQtyfinish]实作数量 [FfinishTime] 人工实作工时 [FreadyTime] 机台准备工时
--[FfixTime]机台实作工时 [FHRReadyTime]人工准备工时 [FMTONo]计划跟踪号 [FOperAuxQtyHandOver]移交数量(工序)
--[FFlowCardNO]工序流转卡
--FTaskDispBillID 审核时会自动产生派工单，反审核时变为0
--反审核时Fstatus变0，FCheckStatus没变
INSERT INTO dbo.SHProcRpt([FinterID],[FEntryID],[FBRNO],[FItemID],[FUnitID],[FWBinterID],[Fserial],[FbillerID],[Fdate],[Fstatus],[FCheckerID],[FworkerID],[FdeviceID],[FteamID],[FstartWorkDate],[FEndWorkDate],[Fqtyfinish],[FAuxQtyfinish],[FQtypass],[FAuxQtyPass],[Fqtylost],[FAuxQtylost],[FQtyback],[FAuxQtyBack],[FQtyBackPass],[FAuxQtyBackPass],[FQtyscrap],[FAuxQtyscrap],[FqtyForItem],[FAuxQtyForItem],[FqtyHandOver],[FAuxQtyHandOver],[FqtyReceive],[FAuxQtyReceive],[FtotalFee],[FTimeUnit],[FTimeRun],[FWorkQty],[FTimeMachine],[FTimeSetUp],[FfinishTime],[FreadyTime],[FPowerCutTime],[FfixTime],[FwaitItemTime],[FwaitTooltime],[FcheckDate],[Fmemo],[FReprocessedQty],[FAuxReprocessedQty],[FTeamtimeID],[FOperAuxQtyFinish],[FOperAuxQtyPass],[FOperAuxQtyScrap],[FOperAuxQtyForItem],[FOperAuxReprocessedQty],[FAuxRelateQty],[FRelateQty],[FPlanMode],[FMTONo],[FHRReadyTime],[FOperSN],[FOperID],[FIsOut],[FUniID],[FConversion],[FAuxQualifiedReprocessedQty],[FOperAuxQualifiedRepQty],[FQualifiedReprocessedQty],[FOperAuxQtyHandOver],[FAuxQtyStockCommit],[FQtyStockCommit],[FIsLastReport],[FWorkCenterID],[FQualityChkID],[FFlowCardNO],[FFlowCardInterID],[FFlowCardEntryID],[FICMOBillNO],[FICMOInterID],[FMOPlanStartDate],[FMOPlanFinishDate],[FOrderBillNO],[FSourceClassTypeID],[FOrderInterID],[FOrderEntryID],[FFlowCardNo_Filter],[FOperGroupID])
VALUES
(@FInterID,@FEntryID,0,@FItemID,@FUnitID,@FWBInterID,0,16394,null,0,null,@FworkerID,@FdeviceID,@FteamID,@FstartWorkDate,@FEndWorkDate,@FAuxQtyfinish,@FAuxQtyfinish,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,@FtotalFee,@FTimeUnit,@FTimeRun,@FWorkQty,@FTimeMachine,@FTimeSetUp,0,0,null,0,null,null,null,null,0,0,@FTeamtimeID,@FAuxQtyfinish,0,0,0,0,0,0,14036,@FMTONo,0,0,@FOperID,@FIsOut,null,@FConversion,0,0,0,0,0,0,1059,@FWorkCenterID,@FQualityChkID,'',0,0,@FICMONO,@FICMOInterID,null,null,'',0,0,0,'',@FOperGroupID)

set @FEntryID=@FEntryID+1

set @SumFinishQty+=@FAuxQtyfinish--求实作数量之和
end

--反写工序计划单
update SHWorkBillEntry set FAuxQtyFinish=FAuxQtyFinish+@SumFinishQty,
FAuxQtyTaskDispAck=FAuxQtyTaskDispAck+@SumFinishQty,
FAuxQtyTaskDispSel=FAuxQtyTaskDispSel+@SumFinishQty,
FQtyFinish=FQtyFinish+@SumFinishQty,
FQtyTaskDispAck=FQtyTaskDispAck+@SumFinishQty,
FQtyTaskDispSel=FQtyTaskDispSel+@SumFinishQty
where FWorkBillNO=@FWBNO

--更新已抛转列
update t_GXHB set IsThrown=1 where FBillNo=@FBillNo

END
GO
