use Synaptic
declare @LDate as datetime = '2019-12-01 00:00:00'
declare @UDate as datetime = '2019-12-31 23:59:59'

/*wersja sprawdza dokumenty wszêdzie gdzie jest na + finieshed products, no movments nie bilanowany ka¿da wartoœæ powoduje ruch*/

select 
w.Reference1Title
, w.Reference2Title
, w.Reference3Title
, w.Reference4Title
, w.Reference1
, w.Reference2

, replace(replace(convert(nvarchar,convert(money,isnull((w.Reference3),0)),1), '.00',''),',',' ') as Reference3 
, w.Reference4
, '' AS Reference5Title
, 'Availible' AS Reference6Title
, 'Blocked' AS Reference7Title
, w.Reference8Title
, '' AS Reference5

, replace(replace(convert(nvarchar,convert(money,isnull((w.Reference6),0)),1), '.00',''),',',' ') as Reference6
, convert(int,w.Reference3)-convert(int,w.Reference6) AS Reference7
, w.Reference8
, w.Count0Title
, w.Count1Title
, w.Count2Title
, w.Count3Title
, w.Count0
, w.Count1
, w.Count2
, w.Count3
, w.DocDate
, w.pos
, w.ReferenceNo
, w.qcb
from
(select PD.Name AS ReferenceNo
,'Product set' as Reference1Title
, 'Opening balance' as Reference2Title
, 'Closing balance' as Reference3Title
, 'Reference name / description' as Reference4Title

, 'Document' as Count0Title
, 'Quantity' as Count1Title
, 'References' as Count3Title
, '' AS Reference5Title
, 'Availible' AS Reference6Title
, 'Blocked' AS Reference7Title
, '' Reference8Title

, PD.Name as Reference1
, replace(replace(convert(nvarchar,convert(money,isnull((
		select sum(PDPD1.Quantity)
		from (select dpd.ProductDefinitionId
				, sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
								then dpd.FinishCount
							 when (ds.isRW=1 and ds.Name<>'RWT SCRAP')
								then -dpd.OriginCount
							 else
								-dpd.FinishCount
						end) as Quantity
				, (case when (ds.IsRW<>1) 
								then d.DeadlineDate
							else
								d.RealizationDate
					end) as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			group by dpd.ProductDefinitionId, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId

			union all
	/*obs³uga wastów*/
			select dpd.ProductDefinitionId
				, sum(dpd.OriginCount-dpd.FinishCount) as Quantity
				, d.DeadlineDate as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.ispw=0	
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			group by dpd.ProductDefinitionId,  d.DeadlineDate, dpd.DocumentId
			) as PDPD1
		where PDPD1.ProductDefinitionId = pdpd.ProductDefinitionId  
			and PDPD1.RealizationDate<@LDate /*³¹czy po productdefinition*/
	),0)),1), '.00',''),',',' ') as Reference2
, (
		select sum(PDPD1.Quantity) 
		from (select dpd.ProductDefinitionId
				,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
								then dpd.FinishCount
							 when (ds.isRW=1 and ds.Name<>'RWT SCRAP')
								then -dpd.OriginCount
							 else
								-dpd.FinishCount
						end) as Quantity
				,(case when (ds.IsRW<>1) 
								then d.DeadlineDate
							else
								d.RealizationDate
					end) as RealizationDate
				, dpd.DocumentId as DID
			 from DocumentProductDefinition dpd (NOLOCK)
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			 where d.Deleted is null 
				and dpd.Deleted is null 

				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			 group by dpd.ProductDefinitionId, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId

			 union all
	/*obs³uga wastów*/
			 select dpd.ProductDefinitionId
				, sum(dpd.OriginCount-dpd.FinishCount) as Quantity
				, d.DeadlineDate as RealizationDate
				, dpd.DocumentId as DID
			 from DocumentProductDefinition dpd (NOLOCK)
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			where d.Deleted is null 
				and dpd.Deleted is null 

				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.ispw=0	
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			group by dpd.ProductDefinitionId,  d.DeadlineDate, dpd.DocumentId
			) as PDPD1
		where PDPD1.ProductDefinitionId = pdpd.ProductDefinitionId  and PDPD1.RealizationDate<@UDate /*tutaj upperlimit daty - i grupuje po porductdefinitionid*/
	) as Reference3

, '' as Reference4
, '' as Reference5
, isnull((select sum(PDPD1.Quantity) 
																from (select dpd.ProductDefinitionId
																		,sum(case when (dpd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' or dpd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' 
																						or dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823' or dpd.warehousedstid='E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
																						and ((dpd.WarehouseSRCId<>'D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' and dpd.WarehouseSrcId<>'874285B6-5CA8-4577-94E9-57E322CE1171' 
																						and dpd.WarehouseSrcId<>'5AE54771-CA23-4363-9847-6AF7436E2823' and dpd.WarehouseSrcId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
																								or dpd.WarehouseSrcId is null)
																					then dpd.FinishCount
																				   when (dpd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' or dpd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' 
																						or dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' or dpd.warehouseSrcid='E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
																						and ((dpd.WarehouseDstId<>'D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' and dpd.WarehouseDstId<>'874285B6-5CA8-4577-94E9-57E322CE1171' 
																						and dpd.WarehouseDstId<>'5AE54771-CA23-4363-9847-6AF7436E2823' and dpd.WarehouseDstId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
																								or dpd.WarehouseDstId is null)
																				    then -dpd.FinishCount

																			 	   else
																					0
																				end) as Quantity
																		, d.DeadlineDate as RealizationDate
																		, dpd.DocumentId as DID
																	from /*DocumentProductDefinition dpd (NOLOCK)*/
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
																			where FinalProductBatchId is not null) dpd
																		inner join Document d (NOLOCK) on d.id= dpd.DocumentId
																		inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
																		inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
																		inner join ProductBatch pb on pb.id = dpd.ProductBatchId
																	where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		and left(pb.param1,3)='CAP'
																		/*and ds.IsMM=0*/ 
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																	group by dpd.ProductDefinitionId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
																where PDPD1.ProductDefinitionId = pdpd.ProductDefinitionId and PDPD1.RealizationDate<@UDate),0) as Reference6
,'' Reference7
,'' Reference8
, convert(nvarchar, pdpd.RealizationDate,102) +'{NewLine}'+PDPD.DocumentNumber as Count0

, replace(replace(convert(nvarchar,convert(money,(case when pdpd.QCB<>'' then 0 else pdpd.Quantity end)),1), '.00',''),',',' ') as Count1
, PDPD.QCB as ddddd
,'After operation' as Count2Title
, replace(replace(convert(nvarchar,convert(money,isnull((
		select sum(PDPD1.Quantity) 
		from (select dpd.OrderNumber
				, dpd.ProductDefinitionId
				, sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
								then dpd.FinishCount
							 when (ds.isRW=1 and ds.Name<>'RWT SCRAP')
								then -dpd.OriginCount
							 else
								-dpd.FinishCount
						end) as Quantity
				, (case when (ds.IsRW<>1) 
								then d.DeadlineDate
							else
								d.RealizationDate
					end) as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			group by dpd.ProductDefinitionId, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber

			union all

			select dpd.OrderNumber
				, DPD.ProductDefinitionId
				, sum(dpd.OriginCount - dpd.FinishCount) as Quantity
				, (d.DeadlineDate) as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
				inner join productbatch PB on pb.id = dpd.productbatchid
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.IsPW=0
				and left(pb.param1,3)='CAP'
				and dpd.FinishCount>0
			group by dpd.ProductDefinitionId, d.DeadlineDate, dpd.DocumentId, dpd.OrderNumber
			) as PDPD1
		where PDPD1.ProductDefinitionId = pdpd.ProductDefinitionId and (PDPD1.RealizationDate<pdpd.RealizationDate or (PDPD1.RealizationDate=pdpd.RealizationDate and PDPD1.OrderNumber<=pdpd.OrderNumber))
	),0)),1), '.00',''),',',' ') as Count2

, (case when pb.Param1 is null or PDPD.QCB<>'' then '' else pb.Param1 + ( ' to ') end ) + 
		ISNULL((select (CASE WHEN RAD.AdditionalColumnShortString IS NULL 
								THEN NULL 
							ELSE 
								RAD.AdditionalColumnShortString
						END)
				from dbo.RequestAdditionalData RAD (NOLOCK)
					Inner join dbo.RequestSeriesAdditionalDataView PCAD (NOLOCK) ON RAD.RequestSeriesAdditionalDataId = PCAD.Id
				where PCAD.IsRequestParam = 1 
				and RAD.Deleted is null 
				and PCAD.DataName = 'Ref. numer zamówienia' 
				AND RAD.RequestId = (select isnull(dbo.GetFirstRequestInTree(w1.RequestId),w1.requestid)
									from (select top 1 ri.RequestId 
											from DocumentProductDefinition dpd 
												inner join ProductionMaterialsDocumentProductDefinition pmdpd (NOLOCK) on pmdpd.DocumentProductDefinitionId= dpd.Id
												inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pmdpd.ProductionMaterialId
												inner join RequestItemProductionOrderItem ripoi (NOLOCK) on ripoi.ProductionOrderItemId = pmpoi.ProductionOrderItemId
												inner join RequestItems ri (NOLOCK) on ri.Id = ripoi.RequestItemId
									where dpd.Deleted is null 
										and pmdpd.Deleted is null 
										and pmpoi.Deleted is null 
										and ripoi.Deleted is null 
										and ri.Deleted is null
										and dpd.DocumentId=PDPD.DID ) as w1)

	),'') + PDPD.QCB as Count3
, PDPD.RealizationDate as DocDate
, DENSE_RANK() OVER(ORDER BY pd.name ASC) as pos
, pdpd.QCB
from (select dpd.OrderNumber
		, dpd.ProductDefinitionId
		, dpd.ProductBatchId
		, (case when (ds.IsPW=1 or ds.IsPZ=1) 
					then d.DocumentNumber
				else
					D.DocumentPreNumber
			end) As DocumentNumber
		, sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
						then dpd.FinishCount
					 when (ds.isRW=1 and ds.Name<>'RWT SCRAP')
						then -dpd.OriginCount
					 else
						-dpd.FinishCount
				end) as Quantity
		, (case when (ds.IsRW<>1) 
					then d.DeadlineDate
				else
					d.RealizationDate
			end) as RealizationDate
		, dpd.DocumentId as DID
		, (case when ds.IsMM=1 and dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'
			then 'QC relased ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			when ds.IsMM=1 and dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334' 
			then 'QC blocked ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			else ''
			end) as QCB
	from DocumentProductDefinition dpd (NOLOCK)
		inner join Document d (NOLOCK) on d.id= dpd.DocumentId
		inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
		inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
		inner join productbatch PB on pb.id = dpd.productbatchid
	where d.Deleted is null 
		and dpd.Deleted is null
		and pb.deleted is null 
		and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
		and (ds.IsMM=0 or (ds.IsMM=1 and (dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334'))) 
		and ds.IsStockChange=0
		and d.Realizated is not null
		and left(pb.param1,3)='CAP'
		and (( d.RealizationDate >@LDate and d.RealizationDate<@UDate and ds.IsPZ=0) or (d.DeadlineDate >@LDate and d.DeadlineDate<@UDate and ds.IsPZ=1))
		and dpd.FinishCount >0 /*tylko tam gdzie by³a realizacja*/
/*ogranicza tylko do dokumentów z tego okresu*/
	group by dpd.ProductDefinitionId, dpd.ProductBatchId,d.DocumentNumber,d.DocumentPreNumber, ds.IsPW, ds.IsPZ, ds.IsRW, ds.IsMM, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber, dpd.WarehouseSrcId, dpd.WarehouseDstId

	union all

	select dpd.OrderNumber
		, dpd.ProductDefinitionId
		, dpd.ProductBatchId
		, (d.DocumentNumber) As DocumentNumber
		, sum(dpd.OriginCount- dpd.FinishCount) as Quantity
		, (d.DeadlineDate) as RealizationDate
		, dpd.DocumentId as DID
		, ''
	from DocumentProductDefinition dpd (NOLOCK)
		inner join Document d (NOLOCK) on d.id= dpd.DocumentId
		inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
		inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
		inner join productbatch PB on pb.id = dpd.productbatchid
	where d.Deleted is null 
		and dpd.Deleted is null 
		and pb.deleted is null 
		and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
		and (ds.IsMM=0 or (ds.IsMM=1 and (dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334'))) 
		and ds.IsStockChange=0
		and d.Realizated is not null
		and d.DeadlineDate >@LDate 
		and d.DeadlineDate<@UDate 
		and ds.IsPZ=0 
		and ds.IsPW=0
		and left(pb.param1,3)='CAP'
		and dpd.FinishCount >0 /*tylko tam gdzie by³a realizacja*/
/*ogranicza tylko do dokumentów z tego okresu*/
	group by dpd.ProductDefinitionId, dpd.ProductBatchId,d.DocumentNumber,d.DocumentPreNumber, d.DeadlineDate, dpd.DocumentId, dpd.OrderNumber

	union all

	select 0
		, pd.id
		, pd.id
		, 'NO MOVMENTS'
		, 0
		, @UDate
		, PD.Id  
		, ''
	from ProductDefinition pd (NOLOCK)
	where pd.id in (select NOMOV.ProductDefinitionId
					from (select dpd.ProductDefinitionId
							, sum(dpd.FinishCount) as Quantity

						from DocumentProductDefinition dpd (NOLOCK)
							inner join Document d (NOLOCK) on d.id= dpd.DocumentId
							inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
							inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
							INNER JOIN ProductDefinition PD (NOLOCK) on PD.id = dpd.ProductDefinitionId
						where d.Deleted is null 
							and dpd.Deleted is null 
							and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' 
							and pd.ProductCategoryId='7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' /*tylko tuby*/
							and (ds.IsMM=0 or (ds.IsMM=1 and (dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334'))) 
							and ds.IsStockChange=0
							and d.Realizated is not null
							and d.RealizationDate <@LDate /*lowerlimit*/
							and dpd.ProductDefinitionId not in (select dpd2.ProductDefinitionId 
																from DocumentProductDefinition dpd2 (NOLOCK)
																inner join document d2 (NOLOCK) on d2.id = dpd2.DocumentId 
																inner join DocumentSeries ds2 (NOLOCK) on ds2.id = d2.DocumentSeriesId
																inner join ProductBatch pb on pb.Id = dpd2.ProductBatchId
																where d2.RealizationDate between @LDate and @UDate 
																and d2.Realizated is not null 
																and dpd2.finishcount>0
																and ds2.Name<>'PWT - PRÓBKI' 
																and ds2.IsMM=0
																and ds2.IsStockChange=0
																and pb.Param1 not like 'W/%') -- jesli w daynm miesiacu bedzie doku z parti¹ W/ to tutaj siê nie zaci¹gnie ¿eby wskoczy³o jako nomov
						group by dpd.ProductDefinitionId) as NOMOV
					where NOMOV.Quantity > 0)
	) as PDPD

	LEFT JOIN ProductBatch pb (NOLOCK) on pb.id= Pdpd.ProductBatchId
	LEFT join ProductDefinition pd (NOLOCK) on pd.id = Pdpd.ProductDefinitionId

where (pdpd.Quantity<>0 OR PDPD.DocumentNumber ='NO MOVMENTS')
	and pd.ProductCategoryId='7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' /*tylko korki*/
	and pb.deleted is null

	and pd.id in (select dpd.ProductDefinitionId 
				from DocumentProductDefinition dpd (NOLOCK)
					inner join Document d (NOLOCK) on d.id = dpd.DocumentId
					inner join ProductDefinition pd (NOLOCK) on pd.id = dpd.ProductDefinitionId
					inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
					inner join productbatch PB on pb.id = dpd.productbatchid
/*tu zamieniæ od daty do daty */
				where d.RealizationDate >@LDate 
					and d.RealizationDate<@UDate 
					AND DPD.Deleted IS NULL 
					AND D.Deleted IS NULL 
					AND PC.Name= 'Zamkniêcia'
					and left(pb.param1,3)='CAP'
				group by dpd.ProductDefinitionId

				union all

				select PDPD1.ProductDefinitionId  
				from (select dpd.ProductDefinitionId
						, sum(dpd.FinishCount) as Quantity
						, (case when (/*ds.IsPW=1 or*/ ds.IsPZ=1) 
									then cast(d.Realizated as date)
								else
									d.RealizationDate
							end) as RealizationDate
						, dpd.DocumentId as DID
					from DocumentProductDefinition dpd (NOLOCK)
						inner join Document d (NOLOCK) on d.id= dpd.DocumentId
						inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
						inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
						INNER JOIN ProductDefinition PD (NOLOCK) on PD.id = dpd.ProductDefinitionId
						inner join productbatch PB on pb.id = dpd.productbatchid
					where d.Deleted is null 
						and dpd.Deleted is null 
						and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' 
						and pd.ProductCategoryId='7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' /*tylko korki*/
						and ds.IsMM=0 
						and ds.IsStockChange=0
						and d.Realizated is not null
						and left(pb.param1,3)='CAP'
					group by dpd.ProductDefinitionId, ds.IsPW, ds.IsPZ, ds.IsRW, d.Realizated, d.RealizationDate, dpd.DocumentId
					) as PDPD1
				where PDPD1.RealizationDate<@LDate /*tu lowerlimit*/
				GROUP BY PDPD1.ProductDefinitionId
				having sum(PDPD1.Quantity)>0
				)

) as w
where ((w.Reference6 > 0 and Reference7 = 0) or (w.Reference6 > 0 and Reference7 >0) or (w.Reference6 = 0 and Reference7 > 0) or (Reference6=0 and Reference7=0 and Count0 not like '%NO MOVMENTS'))
order by pos asc, ReferenceNo, DocDate