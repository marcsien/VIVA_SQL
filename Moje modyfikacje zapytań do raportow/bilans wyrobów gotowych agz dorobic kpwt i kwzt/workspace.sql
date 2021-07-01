use synaptic
declare @LRangeDate as datetime = '2020-07-01 00:00:00'
declare @URangeDate as datetime = '2020-08-30 23:59:59'
declare @WHDate as datetime = '2020-08-30 23:59:59'

select b.Product as Count1, b.param2 as Count2, b.param1 as Count3
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.DocStock as int),0)),1), '.00',''),',',' ')  as Count4
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToWarehouse as int),0)),1), '.00',''),',',' ')  as Count5
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Returns as int),0)),1), '.00',''),',',' ')  as Count6
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(B.OutWarehouse as int),0)),1), '.00',''),',',' ')  as Count7
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(B.Component as int),0)),1), '.00',''),',',' ')  as Count8 
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Destructive as int),0)),1), '.00',''),',',' ')  as Count9 
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToQC as int),0)),1), '.00',''),',',' ')  as Count10
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Samples as int),0)),1), '.00',''),',',' ')  as Count15
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Revision as int),0)),1), '.00',''),',',' ')  as Count16
, left(UCap.Name,7) as Count11 , b.param1 as Count12, /*ULabel.Param5 as Count13,*/ ULabel.Param2 as Count14 , b.ProductBatchId 
, isnull((select top 1 (case when (rs.Name='Zakoñczone' and r.Realizated<=@WHDate) then rs.Name else 'W realizacji' end) from
request r 
inner join RequestItems ri (NOLOCK) on ri.RequestId = r.id
left join RequestStatus rs (NOLOCK) on rs.id = r.RequestStatusId
where  r.Deleted is null and ri.Deleted is null and ri.ProductBatchId = b.ProductBatchId
order by rs.OrderNumber
),'') as Count13
 from

(select dpd.ProductDefinitionId, dpd.ProductBatchId, pb.Param1, pb.param2, pd.Name as Product, pb.Name as batch, pc.Name as Pcategory

,sum((case when (ds.name='pwt' or ds.name='pwtm' or ds.name='pzt' Or ds.Name='pwt sur') and (d.DeadlineDate <=@LRangeDate) then dpd.FinishCount  
	 /*when ((ds.IsMM=1 and ds.Name='MMT' and ((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823')
										/*or (dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823')*/))
									    and (d.DeadlineDate <=@LRangeDate))
	  then dpd.FinishCount*/
	 /*ze zwrotów na magazyn*/
	 when ((/*(ds.IsMM=1 and ds.Name='MMT' and ((dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' and dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334')
												or (dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' and dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A')
												))
									    or*/ /*ds.Name='RWT - ZAMIANA' or */ds.name='wzt' or ds.Name='RWT' or ds.Name='RWT SCRAP' or ds.Name='RWT SUR' or ds.Name='Zmiana Partii' or ds.name='Korekta PZT'or ds.name='WZT FOC') 
										and (d.DeadlineDate <=@LRangeDate))
	  then -dpd.FinishCount
	else 0 end)) as DocStock

, sum((case when (ds.name='pwt' or ds.name='pwtm' OR ds.Name ='pwt sur') and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
  then dpd.FinishCount  when ds.Name='RWT - ZAMIANA' then -dpd.FinishCount  else 0 end)) as ToWarehouse
, sum(case when /*ds.Name='MMT'*/ ds.Name='PZT' /*AND (dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823')*/
							  and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	then dpd.FinishCount 
	else
	0
	end
	) as Returns
, sum((case when ds.name='wzt' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate) then dpd.FinishCount 
			when ds.name='Korektra WZT' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate) then -dpd.FinishCount
			else 0 end)) as OutWarehouse 
, sum((case when (ds.IsBatchChange=1 and ds.Name='Zmiana Partii') and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate) then -dpd.FinishCount else 0 end)) as  Component
, sum((case when (ds.Name='RWT SCRAP') and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)then dpd.FinishCount else 0 end)) as Destructive 
, SUM(case when ds.Name='MMT' AND (dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							  and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	then dpd.FinishCount
	when ds.Name='MMT' AND (dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and (dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823' or dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334'))
					   and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	then -dpd.FinishCount
	else
	0
	end
	) AS ToQC

, SUM(case when ds.Name='WZT FOC' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	  then -dpd.FinishCount
	  else
			0
	  end
) AS Samples

, SUM(case when ds.Name='KOREKTA PWT' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	  then -dpd.FinishCount
	  when ds.Name='Korekta WZT' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
	  then dpd.FinishCount
	  else
			0
	  end
) AS Revision 

from document d
inner join /*DocumentProductDefinition dpd on dpd.DocumentId = d.Id*/
			(select dpd1.Deleted, 
					dpd1.DocumentId, 
					dpd1.ProductDefinitionId, 
					dpd1.ProductBatchId, 
					dpd1.origincount, 
					DPD1.FinishCount, 
					dpd1.WarehouseDstId, 
					dpd1.WarehouseSrcId 
			from DocumentProductDefinition DPD1 (NOLOCK)
			union all
			select dpd2.Deleted, 
					dpd2.DocumentId, 
					dpd2.ProductDefinitionId, 
					dpd2.FinalProductBatchId, 
					dpd2.origincount, 
					-DPD2.FinishCount, 
					dpd2.WarehouseDstId, 
					dpd2.WarehouseSrcId 
			from DocumentProductDefinition DPD2 (NOLOCK)
			where FinalProductBatchId is not null) dpd on dpd.DocumentId = d.id
inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
inner join ProductDefinition pd (NOLOCK) on pd.id = dpd.ProductDefinitionId
inner join ProductBatch pb (NOLOCK) on pb.id = dpd.ProductBatchId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId


where (pc.Name='Tuby' or pc.Name='Tuby zintegrowane') and d.Status=3
 and ((ds.IsPW=1 and (ds.Name='pwt' or ds.Name='pwtm')) 
 or (pc.Name='Tuby zintegrowane' and d.Status=3 and ds.IsPW=1 and ds.Name='pwt sur')
 /*zast¹piony przez przesuniêcie mm ze zwrotów na wyroby gotowe*/ 
 /*or  (ds.IsMM=1 and ds.Name='MMT' and 
		(
		(dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823')
		or (dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334')
		or (dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' and dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A')
		or (dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A')
		)
		)
 */
 --select * from DocumentSeries ds where ds.Name = 'KOREKTA PWT'
 or (ds.IsWZ=1 and ds.Name='wzt')
 or (ds.IsPZ=1 and ds.Name='Korekta WZT')
 or (ds.IsRW=1 and ds.Name='KOREKTA PWT')
 or (ds.IsBatchChange=1 and ds.Name='Zmiana Partii')
 or (ds.IsWZ=1 and ds.Name='WZT FOC')
 or ((
    (ds.IsRW=1 and ds.Name='RWT - ZAMIANA' )
 or (ds.IsRW=1 and (ds.Name='RWT SCRAP' or ds.Name='RWT'))
 or (ds.IsRW=1 and ds.Name='RWT SUR')
 or (ds.IsWZ=1 and ds.name='Korekta PZT')
 or (ds.ispz=1 and ds.Name='PZT')

 ) /*and dpd.WarehouseSrcId<>'BE5CB51D-776F-4236-BA89-507CB5571334'*/ /*and dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'*/)
 ) /*wykluczone magazyny kontroli i zwrotów bo wchodz¹ i zchodz¹ dokumentami mm. dodany magazyn kontroli ma byæ jednak widoczny zostaj¹ tylko zwroty jako obce i mm dodany magazyn zwrotów*/ 

 and d.Deleted is null and dpd.Deleted is null and ds.Deleted is null and pd.Deleted is null and pb.Deleted is null and pc.Deleted is null
 and pb.Created > '2016-01-01'
 group by dpd.ProductDefinitionId, dpd.ProductBatchId, pd.Name,pb.Name, pb.Param1,pb.Param2, pc.Name
) as B

left join (select parentpd.Name,parentpb.Param2, parentpb.Param5, poi.ProductBatchId
 from ProductionOrderItems poi
inner join ProductionMaterialsProductionOrderItems ppmpoi (NOLOCK) on ppmpoi.ProductionOrderItemId = poi.Id
inner join ProductionMaterials pm (NOLOCK) on pm.id=ppmpoi.ProductionMaterialId
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductionOrderItems Parentpoi (NOLOCK) on Parentpoi.ProductBatchId = pm.ProductBatchId
inner join ProductionMaterialsProductionOrderItems ParentPMPOI (NOLOCK) on ParentPMPOI.ProductionOrderItemId= Parentpoi.id 
inner join ProductionMaterials parentpm (NOLOCK) on parentpm.id=ParentPMPOI.ProductionMaterialId
inner join ProductDefinition parentpd (NOLOCK) on parentpd.id=parentpm.ProductDefinitionId
inner join ProductCategory parentpc (NOLOCK) on parentpc.id = parentpd.ProductCategoryId
inner join ProductBatch parentpb (NOLOCK) on parentpb.id = parentpm.ProductBatchId
where pc.Name='Tuba-pó³wyrób' and parentpc.Name='Etykiety' and parentpb.Deleted is null  and ParentPMPOI.Deleted is null and pm.Deleted is null and ppmpoi.Deleted is null
group by parentpd.Name,parentpb.Param2, parentpb.Param5, poi.ProductBatchId
) as ULabel on ULabel.ProductBatchId = b.ProductBatchId

left join (select pd.Name, poi.ProductBatchId
 from ProductionOrderItems poi
inner join ProductionMaterialsProductionOrderItems ppmpoi (NOLOCK) on ppmpoi.ProductionOrderItemId = poi.Id
inner join ProductionMaterials pm (NOLOCK) on pm.id=ppmpoi.ProductionMaterialId
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
where pc.Name='Zamkniêcia' and pm.Deleted is null and ppmpoi.deleted is null

group by pd.Name, poi.ProductBatchId
) as UCap on UCap.ProductBatchId = b.ProductBatchId


 where (b.DocStock>0 or b.ToWarehouse>0 or b.Returns>0 or b.OutWarehouse>0 or b.Component>0 or b.Destructive>0 or b.ToQC>0 ) 
		--and b.Product = 'T500_1820_110_SC_NC_C11+6000' and b.Param1 = 'FT/20-0240/01'
		and b.Param1 = 'FT/20-0790/01'
order by b.pcategory, b.Param1