use Synaptic
declare @LDate as datetime = '2019-12-01 00:00:01'
declare @UDate as datetime = '2019-12-30 23:59:59'

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
--,w.pbParam2 usun to
--,w.PBparam3 usun to
, w.Count3
, w.DocDate
, w.pos
, w.ReferenceNo
, w.qcb
from
(select pb.param2 AS ReferenceNo
, 'Product set' as Reference1Title
, PD.Name as Reference1
, 'Opening balance' as Reference2Title
, replace(replace(convert(nvarchar,convert(money,isnull((
		select sum(PDPD1.Quantity)
		from (select pb.Param2, pb.param3
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
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
				and ds.IsMM=0 
				and ds.IsStockChange=0 
				and d.Realizated is not null
				and dst.OrderNumber < 70
				and dpd.FinishCount>0
			group by pb.Param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, pb.param3

			union all
	/*obs³uga wastów*/
			select pb.Param2, pb.param3
				, sum(dpd.OriginCount-dpd.FinishCount) as Quantity
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
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 and ds.IsStockChange=0 and d.Realizated is not null and ds.IsPZ=0 and ds.ispw=0 and ds.iswz=0	
				and dpd.FinishCount>0
			group by pb.Param2,  d.DeadlineDate, dpd.DocumentId, pb.param3



			--newest112233
			union all
			select pb.Param2, pb.param3
				, sum(dpd.FinishCount) as Quantity
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
						DPD2.FinishCount, 
						dpd2.WarehouseDstId, 
						dpd2.WarehouseSrcId 
					from DocumentProductDefinition DPD2 (NOLOCK)	
					where FinalProductBatchId is not null) dpd
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 and ds.IsStockChange=0 and d.Realizated is not null and ds.IsPZ=0 and ds.ispw=0 and ds.iswz=0	
				and dpd.FinishCount>0
				and ds.isBatchChange = 1
			group by pb.Param2,  d.DeadlineDate, dpd.DocumentId, pb.param3









			) as PDPD1
		where PDPD1.Param2 = pb.param2 and PDPD1.param3=pb.param3 /*po³¹czone przez inner join wiêc powinien wyci¹gn¹æ wszystko*/ and PDPD1.RealizationDate<@LDate /*³¹czy po pb.param2*/
	),0)),1), '.00',''),',',' ') as Reference2
, 'Closing balance' as Reference3Title
, isnull((
		select sum(PDPD1.Quantity) 
		from (select pb.Param2, pb.param3
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
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and dpd.FinishCount>0
			group by pb.Param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, pb.param3

			union all

			select pb.Param2, pb.param3
				, sum(dpd.OriginCount-dpd.FinishCount) as Quantity
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
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.ispw=0	
				and ds.iswz=0
				and dpd.FinishCount>0
				--and ds.IsBatchChange = 0 
			group by pb.Param2,  d.DeadlineDate, dpd.DocumentId, pb.param3




			
			--ponizsze dodalem zeby zmiany partii dzialaly do closing balance prawidlwo 
			union all
			select pb.Param2, pb.param3
				, sum(dpd.FinishCount) as Quantity
				, d.DeadlineDate as RealizationDate
				, dpd.DocumentId as DID
				from /*DocumentProductDefinition dpd (NOLOCK)*/
					(
					select dpd2.Deleted, 
						dpd2.DocumentId, 
						dpd2.ProductDefinitionId, 
						dpd2.FinalProductBatchId as ProductBatchId, 
						dpd2.origincount, 
						DPD2.FinishCount, 
						dpd2.WarehouseDstId, 
						dpd2.WarehouseSrcId 
					from DocumentProductDefinition DPD2 (NOLOCK)	
					where FinalProductBatchId is not null) dpd

				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.ispw=0	
				and ds.iswz=0
				and dpd.FinishCount>0
				and ds.IsBatchChange = 1
			group by pb.Param2,  d.DeadlineDate, dpd.DocumentId, pb.param3

			



			) as PDPD1
		where PDPD1.Param2 = pb.Param2 and pdpd1.param3=pb.param3  and PDPD1.RealizationDate<@UDate /*tutaj upperlimit daty - i grupuje po pb.param2*/
	),0) as Reference3
, 'Reference name / description' as Reference4Title
, pb.param3 as Reference4
, '' AS Reference5Title
, 'Availible' AS Reference6Title
, 'Blocked' AS Reference7Title
, '' Reference8Title
, '' as Reference5
, isnull((select sum(PDPD1.Quantity) 
																from (select pb.Param2, pb.Param3, d.DeadlineDate as realizationdate
																		,sum(case when (ds.ispz=1 or ds.ispw=1 or (ds.ismm=1 and (dpd.warehousedstid<>'BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.warehousedstid<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2'))
																							)
																					then dpd.FinishCount
																				   when (ds.IsWZ=1 or ds.IsRW=1 or (ds.ismm=1 and (dpd.warehousedstid='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.warehousedstid='E2B1B94A-823B-42E5-BAD5-7F7925697EB2'))
																							)
																				    then -dpd.FinishCount

																					when (ds.IsBatchChange = 1)
																					then dpd.FinishCount

																			 	   else
																					0
																				end) as Quantity
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
																			where DPD1.FinalProductBatchId is null
																			union all
																			select dpd2.Deleted, 
																				dpd2.DocumentId, 
																				dpd2.ProductDefinitionId, 
																				dpd2.FinalProductBatchId as ProductBatchId, 
																				dpd2.origincount, 
																				DPD2.FinishCount, 
																				dpd2.WarehouseDstId, 
																				dpd2.WarehouseSrcId 
																			from DocumentProductDefinition DPD2 (NOLOCK)
																			where FinalProductBatchId is not null
																			union all
																			select dpd2.Deleted, 
																				dpd2.DocumentId, 
																				dpd2.ProductDefinitionId, 
																				dpd2.ProductBatchId as ProductBatchId, 
																				dpd2.origincount, 
																				-DPD2.FinishCount, 
																				dpd2.WarehouseDstId, 
																				dpd2.WarehouseSrcId 
																			from DocumentProductDefinition DPD2 (NOLOCK)
																			where FinalProductBatchId is not null
																			--ponizej dodalem zeby ref6 dobrze zaciagalo zmiany partii
																			/*union all
																			select dpd2.Deleted, 
																				dpd2.DocumentId, 
																				dpd2.ProductDefinitionId, 
																				dpd2.FinalProductBatchId as ProductBatchId, 
																				dpd2.origincount, 
																				DPD2.FinishCount, 
																				dpd2.WarehouseDstId, 
																				dpd2.WarehouseSrcId 
																			from DocumentProductDefinition DPD2 (NOLOCK)
																			where dpd2.FinalProductBatchId is not null*/) dpd -- to sprawdz w drugi mmiejscu gdzie dales as product batchh id czy poprawnie sprawdza is not null
																		inner join Document d (NOLOCK) on d.id= dpd.DocumentId
																		inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
																		inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
																		inner join ProductBatch pb on pb.id = dpd.ProductBatchId

																	where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		and left(pb.param1,5)='LABEL'

																		and (ds.IsMM=1 and ((dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.WarehouseDstId <>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2') 
																							or (dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334' and dpd.WarehouseSrcId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
																							or (dpd.WarehouseDstId ='E2B1B94A-823B-42E5-BAD5-7F7925697EB2' and dpd.WarehouseSrcId<>'BE5CB51D-776F-4236-BA89-507CB5571334')
																							or (dpd.WarehouseSrcId ='E2B1B94A-823B-42E5-BAD5-7F7925697EB2' and dpd.WarehouseDstId<>'BE5CB51D-776F-4236-BA89-507CB5571334')
																							)
																			or ((ds.IsPZ=1 or  ds.IsPW=1 ) and (dpd.WarehouseDstId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2' and dpd.WarehouseDstId<>'BE5CB51D-776F-4236-BA89-507CB5571334'))
																			or ((ds.IsWZ=1 or ds.IsRW=1) and (dpd.WarehouseSrcId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2' and dpd.WarehouseSrcId<>'BE5CB51D-776F-4236-BA89-507CB5571334'))								
																			or (ds.IsBatchChange = 1 and dpd.WarehouseDstId = dpd.WarehouseSrcId)) 
																			
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																	group by pb.Param2, pb.Param3, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId, ds.IsMM, dpd.WarehouseDstId, dpd.WarehouseSrcId) as PDPD1
																where PDPD1.Param2 = pb.Param2 and PDPD1.Param3= pb.Param3 and PDPD1.RealizationDate<@UDate),0) as Reference6
,'' Reference7
,'' Reference8
, 'Document' as Count0Title
, convert(nvarchar, pdpd.RealizationDate,102) +'{NewLine}'+PDPD.DocumentNumber as Count0
, 'Quantity' as Count1Title
, replace(replace(convert(nvarchar,convert(money,(case when pdpd.QCB<>'' then 0 else pdpd.Quantity end)),1), '.00',''),',',' ') as Count1
, 'After operation' as Count2Title
, replace(replace(convert(nvarchar,convert(money,isnull((
		select sum(PDPD1.Quantity) 
		from (select dpd.OrderNumber
				, pb.Param2, pb.param3
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
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and dpd.FinishCount>0
			group by pb.param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber, pb.param3

			union all

			
			--zmiany partii minus
			select dpd.OrderNumber
				, pb.Param2
				, pb.param3
				, sum(dpd.OriginCount - dpd.FinishCount) as Quantity
				, (case when (ds.IsRW<>1) 
								then d.DeadlineDate
							else
								d.RealizationDate
					end) as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and dpd.FinishCount>0
				and ds.IsBatchChange = 1
			group by pb.param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber, pb.param3


			union all 
			--zmiany partii plus
				select dpd.OrderNumber
				, pb.Param2
				, pb.param3
				, sum( dpd.FinishCount) as Quantity -- tutaj zle sumuje powinno byc sum(dpd.OriginCount + dpd.FinishCount) ale dpd origin z dokumentu na ktorym ta liczba count zeszla 
				, (case when (ds.IsRW<>1) 
								then d.DeadlineDate
							else
								d.RealizationDate
					end) as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.FinalProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null
				and dpd.FinishCount>0
				and ds.IsBatchChange = 1
			group by pb.param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber, pb.param3






			union all

			select dpd.OrderNumber
				, pb.Param2, pb.param3
				, sum(dpd.OriginCount - dpd.FinishCount) as Quantity
				, d.DeadlineDate as RealizationDate
				, dpd.DocumentId as DID
			from DocumentProductDefinition dpd (NOLOCK)
				inner join ProductBatch pb (NOLOCK) on pb.Id = dpd.ProductBatchId
				inner join Document d (NOLOCK) on d.id= dpd.DocumentId
				inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
				inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			where d.Deleted is null 
				and dpd.Deleted is null 
				and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
				and ds.IsMM=0 
				and ds.IsStockChange=0
				and d.Realizated is not null 
				and ds.IsPZ=0 
				and ds.IsPW=0
				and ds.iswz=0
				and dpd.FinishCount>0
			group by pb.Param2, d.DeadlineDate, dpd.DocumentId, dpd.OrderNumber, pb.param3
			) as PDPD1
		where PDPD1.Param2 = pb.Param2 and PDPD1.Param3 = PB.param3 and (PDPD1.RealizationDate<pdpd.RealizationDate or (PDPD1.RealizationDate=pdpd.RealizationDate and PDPD1.OrderNumber<=pdpd.OrderNumber))
	),0)/*+pdpd.Quantity*/),1), '.00',''),',',' ') as Count2







, 'References' as Count3Title
, (case when pb.Param1 is null or PDPD.QCB<>'' then '' else pb.Param1 + ( ' to ') end ) + 
		ISNULL((select (CASE WHEN RAD.AdditionalColumnShortString IS NULL 
								THEN NULL 
								ELSE RAD.AdditionalColumnShortString
						END)
				from dbo.RequestAdditionalData RAD
					Inner join dbo.RequestSeriesAdditionalDataView PCAD (NOLOCK) ON RAD.RequestSeriesAdditionalDataId = PCAD.Id
				where PCAD.IsRequestParam = 1 
					and RAD.Deleted is null 
					and PCAD.DataName = 'Ref. numer zamówienia' 
					AND RAD.RequestId = (select isnull(dbo.GetFirstRequestInTree(w1.RequestId),w1.requestid)
										from (select top 1 ri.RequestId 
												from DocumentProductDefinition dpd (NOLOCK)
													inner join ProductionMaterialsDocumentProductDefinition pmdpd (NOLOCK) on pmdpd.DocumentProductDefinitionId= dpd.Id
													inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pmdpd.ProductionMaterialId
													inner join RequestItemProductionOrderItem ripoi (NOLOCK) on ripoi.ProductionOrderItemId = pmpoi.ProductionOrderItemId
													inner join RequestItems ri (NOLOCK) on ri.Id = ripoi.RequestItemId
												where dpd.Deleted is null 
													and pmdpd.Deleted is null 
													and pmpoi.Deleted is null 
													and ripoi.Deleted is null 
													and ri.Deleted is null
													and dpd.DocumentId=PDPD.DID 
											) as w1
			)),'') + PDPD.QCB as Count3
, PDPD.RealizationDate as DocDate
, DENSE_RANK() OVER(ORDER BY pb.param2, pb.param3 ASC) as pos
, pdpd.QCB












from (select dpd.OrderNumber
		, dpd.ProductDefinitionId
		, dpd.ProductBatchId
		, (case when (ds.IsPW=1 or ds.IsPZ=1) 
					then d.DocumentNumber
					when (ds.IsBatchChange = 1) 
					then d.DocumentNumber
				else D.DocumentPreNumber
					end
		  ) As DocumentNumber
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
			when ds.IsMM=1 and dpd.WarehouseSrcId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2'
			then 'Back from supplier ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			when ds.IsMM=1 and dpd.WarehouseDstId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2' 
			then 'Claim to supplier ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			else ''
			end) as QCB
		from DocumentProductDefinition dpd (NOLOCK)
			inner join Document d (NOLOCK) on d.id= dpd.DocumentId
			inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
			inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
			left Join (select Cl.Name, dad.DocumentId
									from DocumentAdditionalData dad 
									inner join Classifier Cl on Cl.Id = dad.ClassifierId
									where Cl.Name= 'Reklamacja' and dad.Deleted is null) as MMR on MMR.DocumentId = d.Id
		where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
			and (ds.IsMM=0 or (ds.IsMM=1 and (dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334'
												or dpd.warehousesrcid ='E2B1B94A-823B-42E5-BAD5-7F7925697EB2' or dpd.WarehouseDstId ='E2B1B94A-823B-42E5-BAD5-7F7925697EB2'
												)
								and	isnull(MMR.name,'')='Reklamacja') )

			and ds.IsStockChange=0
			and d.Realizated is not null
			and (( d.RealizationDate >@LDate and d.RealizationDate<@UDate and ds.IsPZ=0) or (d.DeadlineDate >@LDate and d.DeadlineDate<@UDate and ds.IsPZ=1))
			and dpd.FinishCount >0 /*tylko tam gdzie by³a realizacja*/
/*ogranicza tylko do dokumentów z tego okresu*/
		group by dpd.ProductDefinitionId, dpd.ProductBatchId,d.DocumentNumber,d.DocumentPreNumber, ds.IsPW, ds.IsPZ, ds.IsRW,ds.IsBatchChange, d.DeadlineDate, d.RealizationDate, dpd.DocumentId, dpd.OrderNumber, ds.IsMM, dpd.WarehouseDstId, dpd.WarehouseSrcId

		union all

		select dpd.OrderNumber
			, dpd.ProductDefinitionId
			, dpd.ProductBatchId
			, d.DocumentNumber As DocumentNumber
			, sum(dpd.OriginCount- dpd.FinishCount) as Quantity
			, d.DeadlineDate as RealizationDate
			, dpd.DocumentId as DID
			, ''
		from DocumentProductDefinition dpd (NOLOCK)
			inner join Document d (NOLOCK) on d.id= dpd.DocumentId
			inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
			inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
		where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
			and ds.IsMM=0 
			and ds.IsStockChange=0
			and d.Realizated is not null
			and d.DeadlineDate >@LDate and d.DeadlineDate<@UDate
			and ds.IsPZ=0 
			and ds.IsPW=0
			and ds.iswz=0
			and dpd.FinishCount >0 /*tylko tam gdzie by³a realizacja*/
/*ogranicza tylko do dokumentów z tego okresu*/
		group by dpd.ProductDefinitionId, dpd.ProductBatchId,d.DocumentNumber,d.DocumentPreNumber, d.DeadlineDate, dpd.DocumentId, dpd.OrderNumber


		--tutaj zeby z plusem zmiany partii(zaciaga finalproductbatch)
		union all

		select dpd.OrderNumber
			, dpd.ProductDefinitionId
			, dpd.FinalProductBatchId
			, d.DocumentNumber As DocumentNumber
			, sum(dpd.FinishCount) as Quantity
			, d.DeadlineDate as RealizationDate
			, dpd.DocumentId as DID
			, ''
		from DocumentProductDefinition dpd (NOLOCK)
			inner join Document d (NOLOCK) on d.id= dpd.DocumentId
			inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
			inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
		where d.Deleted is null 
			and dpd.Deleted is null 
			and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
			and ds.IsMM=0 
			and ds.IsStockChange=0
			and d.Realizated is not null
			and d.DeadlineDate >@LDate --zakomentowac zeby zaciagalo R-22919400001
			and d.DeadlineDate<@UDate 
			and ds.IsPZ=0 
			and ds.IsPW=0
			and ds.iswz=0
			and ds.IsBatchChange = 1
			and dpd.FinishCount >0 /*tylko tam gdzie by³a realizacja*/
/*ogranicza tylko do dokumentów z tego okresu*/
		group by dpd.ProductDefinitionId, dpd.FinalProductBatchId,d.DocumentNumber,d.DocumentPreNumber, d.DeadlineDate, dpd.DocumentId, dpd.OrderNumber

		union all 


/*tutaj zmieniæ jak nie by³o jakiegoœ coda */
		select 0
			, nmw.ProductDefinitionId
			, nmw.Id
			,'NO MOVMENTS'
			, 0
			, @LDate
			, nmw.Id
			, ''
		from (select pb.param2, PB.ProductDefinitionId
				, pb.id
				, row_number() over ( partition by pb.param2, pb.param3 order by pb.param2, pb.param3) as rn

			from ProductBatch pb (NOLOCK)
			where pb.Deleted is null
				and pb.id in (select NOMOV.id
								from (select PDPD1.Id
										, sum(PDPD1.Quantity) as Quantity
										from (select pb1.id
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
												from DocumentProductDefinition dpd
													inner join ProductBatch pb1 (NOLOCK) on pb1.Id = dpd.ProductBatchId
													inner join Document d (NOLOCK) on d.id= dpd.DocumentId
													inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
													inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
													inner join ProductDefinition pd1 (NOLOCK) on pd1.id = dpd.ProductDefinitionId
												where d.Deleted is null 
													and dpd.Deleted is null 
													and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
													and pd1.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' 
													and ds.IsMM=0 
													and ds.IsStockChange=0
													and d.Realizated is not null
													and dpd.FinishCount>0
													and NOT EXISTS (select pb2.id 
																	from DocumentProductDefinition dpd2 (NOLOCK) 
																		inner join ProductBatch pb2 (NOLOCK) on pb2.id = dpd2.ProductBatchId 
																		inner join document d2 (NOLOCK) on d2.id = dpd2.DocumentId 
																		inner join DocumentSeries ds2 (NOLOCK) on ds2.id = d2.DocumentSeriesId
																	where d2.RealizationDate between @LDate and @UDate
																		and d2.Realizated is not null 
																		and dpd2.finishcount>0 
																		and ds2.Name<>'PWT - PRÓBKI' 
																		and ds2.IsMM=0 
																		and ds2.IsStockChange=0
																		and dpd2.FinishCount>0
																		AND PB2.Param2 = PB1.Param2 and pb2.Param3 = pb1.Param3 
																	GROUP BY PB2.id)

												group by pb1.id, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId

								union all -- do zmian partii na plus ma doliczaæ

								select pb1.id
												,sum(case when (ds.IsBatchChange = 1) 
															then dpd.FinishCount
													else
														0
														end) as Quantity
												,(case when (ds.IsRW<>1) 
														then d.DeadlineDate
													else
														d.RealizationDate
													end) as RealizationDate
												, dpd.DocumentId as DID
												from DocumentProductDefinition dpd
													inner join ProductBatch pb1 (NOLOCK) on pb1.Id = dpd.FinalProductBatchId
													inner join Document d (NOLOCK) on d.id= dpd.DocumentId
													inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
													inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
													inner join ProductDefinition pd1 (NOLOCK) on pd1.id = dpd.ProductDefinitionId
												where d.Deleted is null 
													and dpd.Deleted is null 
													and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
													and pd1.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' 
													and ds.IsMM=0 
													and ds.IsStockChange=0
													and d.Realizated is not null
													and dpd.FinishCount>0
													and NOT EXISTS (select pb2.id 
																	from DocumentProductDefinition dpd2 (NOLOCK) 
																		inner join ProductBatch pb2 (NOLOCK) on pb2.id = dpd2.ProductBatchId 
																		inner join document d2 (NOLOCK) on d2.id = dpd2.DocumentId 
																		inner join DocumentSeries ds2 (NOLOCK) on ds2.id = d2.DocumentSeriesId
																	where d2.RealizationDate between @LDate and @UDate
																		and d2.Realizated is not null 
																		and dpd2.finishcount>0 
																		and ds2.Name<>'PWT - PRÓBKI' 
																		and ds2.IsMM=0 
																		and ds2.IsStockChange=0
																		and dpd2.FinishCount>0
																		AND PB2.Param2 = PB1.Param2 and pb2.Param3 = pb1.Param3 
																	GROUP BY PB2.id)

												group by pb1.id, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId

								union all
									/*obs³uga wastów*/
								select pb1.id
									, sum(dpd.OriginCount-dpd.FinishCount) as Quantity
									, d.DeadlineDate as RealizationDate
									, dpd.DocumentId as DID
								from DocumentProductDefinition dpd
									inner join ProductBatch pb1 (NOLOCK) on pb1.Id = dpd.ProductBatchId
									inner join Document d (NOLOCK) on d.id= dpd.DocumentId
									inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
									inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
									inner join ProductDefinition pd1 (NOLOCK) on pd1.id = dpd.ProductDefinitionId
								where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
									and ds.IsMM=0 and ds.IsStockChange=0 and d.Realizated is not null and ds.IsPZ=0 and ds.ispw=0	
									and pd1.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' 
									and dpd.FinishCount>0
								    and NOT EXISTS (select pb2.id 
														from DocumentProductDefinition dpd2  
															inner join ProductBatch pb2 (NOLOCK) on pb2.id = dpd2.ProductBatchId 
															inner join document d2 (NOLOCK) on d2.id = dpd2.DocumentId 
															inner join DocumentSeries ds2 (NOLOCK) on ds2.id = d2.DocumentSeriesId
														where d2.RealizationDate between @LDate and @UDate
															and d2.Realizated is not null 
															and dpd2.finishcount>0 
															and ds2.Name<>'PWT - PRÓBKI' 
															and ds2.IsMM=0 
															and ds2.IsStockChange=0
															and dpd2.FinishCount>0
															AND PB2.Param2 = PB1.Param2 and pb2.Param3 = pb1.Param3 
														GROUP BY PB2.id)
								group by pb1.id,  d.DeadlineDate, dpd.DocumentId

								) as PDPD1
							where PDPD1.RealizationDate<@LDate /*³¹czy po pb.param2*/
								group by PDPD1.id
									) as NOMOV
							where (NOMOV.Quantity > 0)-- or NOMOV.Id = 'A27D9470-948B-43FA-B088-FAA600D5EE77')--wyjatek zeby zaciagalo r2291940000
								and NOMOV.Id not in --warunek zeby nie zaciagalo nomovment ze zmian partii tutej222
								(select pb.Id 
								from Document d
								inner join DocumentSeries ds on d.DocumentSeriesId = ds.Id
								inner join DocumentProductDefinition dpd on dpd.DocumentId = d.Id
								inner join ProductBatch pb on dpd.FinalProductBatchId = pb.Id
								where ds.Id = '4429E817-44C7-4348-B090-CCD8E6FC4760'
								and d.RealizationDate > @LDate))


			) as nmw where nmw.rn = 1

	) as PDPD
	inner JOIN ProductBatch pb (NOLOCK) on pb.id= Pdpd.ProductBatchId
	LEFT join ProductDefinition pd (NOLOCK) on pd.id = Pdpd.ProductDefinitionId
where ((PDPD.DocumentNumber ='NO MOVMENTS' and pd.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' /*tylko etykiety*/)
		OR ((pdpd.Quantity<>0) and pd.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' /*tylko etykiety*/
			and EXISTS (select pb2.Param2 
						from DocumentProductDefinition dpd (NOLOCK)
							inner join ProductBatch pb2 (NOLOCK) on pb2.id = dpd.ProductBatchId
							inner join Document d (NOLOCK) on d.id = dpd.DocumentId
							inner join ProductDefinition pd (NOLOCK) on pd.id = dpd.ProductDefinitionId
							inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
/*tu zamieniæ od daty do daty */
						where d.RealizationDate >@LDate
							and d.RealizationDate<@UDate 
							AND DPD.Deleted IS NULL 
							AND D.Deleted IS NULL 
							AND PC.Name= 'Etykiety'
							AND PB.Param2 = PB2.Param2
							and dpd.FinishCount>0
						group by pb2.Param2
						
						union all

						select PDPD2.Param2  
						from(select pb.Param2
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
								inner join ProductBatch pb (NOLOCK) on pB.id = dpd.ProductBatchId
								inner join Document d (NOLOCK) on d.id= dpd.DocumentId
								inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
								inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
								INNER JOIN ProductDefinition PD (NOLOCK) on PD.id = dpd.ProductDefinitionId
							where d.Deleted is null 
								and dpd.Deleted is null 
								and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
								and pd.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' 
								and ds.IsMM=0 
								and ds.IsStockChange=0
								and d.Realizated is not null
								and dpd.FinishCount>0
							group by pb.Param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.Realizated, d.RealizationDate, dpd.DocumentId, d.DeadlineDate
							) as PDPD2
						where PDPD2.RealizationDate<@LDate /*tu lowerlimit*/
							AND PDPD2.Param2 = PB.Param2
						GROUP BY PDPD2.Param2
						having sum(PDPD2.Quantity)>0

						union all

						select PDPD2.Param2  
						from(select pb.Param2
								, sum(dpd.FinishCount) as Quantity
								, d.DeadlineDate as RealizationDate
								, dpd.DocumentId as DID
							from DocumentProductDefinition dpd (NOLOCK)
								inner join ProductBatch pb (NOLOCK) on pB.id = dpd.FinalProductBatchId
								inner join Document d (NOLOCK) on d.id = dpd.DocumentId
								inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
								inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
								INNER JOIN ProductDefinition PD (NOLOCK) on PD.id = dpd.ProductDefinitionId
							where d.Deleted is null 
								and dpd.Deleted is null 
								and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' and dst.OrderNumber <70
								and pd.ProductCategoryId='253CC25D-8D59-4EF8-B73E-F87784AD5B65' 
								and ds.IsMM=0 
								and ds.IsStockChange=0
								and d.Realizated is not null
								and dpd.FinishCount>0
								and ds.IsBatchChange = 1
							group by pb.Param2, ds.IsPW, ds.IsPZ, ds.IsRW, d.Realizated, d.RealizationDate, dpd.DocumentId, d.DeadlineDate
							) as PDPD2
						where PDPD2.RealizationDate<@LDate /*tu lowerlimit*/
							AND PDPD2.Param2 = PB.Param2
						GROUP BY PDPD2.Param2
						having sum(PDPD2.Quantity)>0
						)
		)
	)
/*wycina wszystkie partie etykiet które nie maj¹ w nazwie LABEL - raport tylko dla Belgii*/
and left(pb.param1,5)='LABEL'
) as w
--where w.ReferenceNo = 'R-22919400001'
-- w.Reference4 like '%meiyume%'
--or w.Reference4 like '%lf beauty%'
order by pos asc, ReferenceNo, DocDate