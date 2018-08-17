select FCurrencyID,*from t_Currency

select *from t_SupplyEntry where FSupID=204

select top 1 FPrice,per.FNumber,c.FNumber as CNumber from t_chanpinxilie cp left join t_Supply s on cp.childmatID=s.FItemID and cp.supID=s.FSupID 
             left join (select *from t_SupplyEntry where FUsed=1 and FQuoteTime<=GETDATE() and FDisableDate>=GETDATE()) se 
             on se.FItemID=s.FItemID and se.FSupID=s.FSupID left join t_Supplier per on cp.supID=per.FItemID 
             left join t_Item it on cp.xilieID=it.FItemID left join t_ICItem ic on cp.childmatID=ic.FItemID left join t_Currency c on se.FCyID=c.FCurrencyID
             where it.FName='CC6' and ic.FNumber='B.E0.05558BACA-21G29G00'

			 select FNumber,*from t_ICItem where FItemID=12789
			 select FNumber,FName,*from t_Supplier where FItemID=204


select bom.FItemID,ic2.FNumber,bomc.FItemID,*from ICBOM bom
join ICBOMChild bomc on bom.FInterID=bomc.FInterID
join t_ICItem ic on bomc.FItemID=ic.FItemID
join t_ICItem ic2 on bom.FItemID=ic2.FItemID where ic.FNumber='V.B.SA080250000750A-25T'

select *from t_ICItem where FItemID=57524

select *from t_ICItem ic where ic.FNumber='V.B.SA080250000750A-25T'

select *from t_Supply
