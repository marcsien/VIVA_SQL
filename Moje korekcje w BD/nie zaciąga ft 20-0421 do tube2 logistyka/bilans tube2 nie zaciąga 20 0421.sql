use Synaptic
declare @LDate as datetime = '2020-01-01 00:00:01'
declare @UDate as datetime = '2020-01-31 23:59:59'
--declare @WHDate as datetime = '2019-09-30 23:59:59'
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*KWERENDA NIE UWZGLÊDNIA WASTÓW - PROTOKO£U ROZIERZNOSCI BAZUJE TYLKO NA FINSHCOUNT CZYLI TO CO RZECZYWISCIE SIÊ ZADZIA£O - DLA TUB WYSTARCZY
Deadline date dla finiszed tubes jest wi¹¿acy*/
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

from
(
select pb.param1 AS ReferenceNo
	, 'Product set' as Reference1Title,PD.Name as Reference1
	, 'Opening balance' as Reference2Title
	, replace(replace(convert(nvarchar,convert(money,isnull((select sum(PDPD1.Quantity) 
																from (select dpd.ProductBatchId
																		, sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
																					then dpd.FinishCount
																			 	   else
																					-dpd.FinishCount
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
																	where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		and ds.IsMM=0 
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																	group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
																where PDPD1.ProductBatchId = pdpd.ProductBatchId  and PDPD1.RealizationDate<@LDate),0)),1), '.00',''),',',' ') as Reference2

	,'Closing balance' as Reference3Title
	, isnull((select sum(PDPD1.Quantity)
																from (select dpd.ProductBatchId
																		, sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
																					then dpd.FinishCount
																				else -dpd.FinishCount
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
																	where d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		and ds.IsMM=0 
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																	group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
																	where PDPD1.ProductBatchId = pdpd.ProductBatchId  
																		and PDPD1.RealizationDate<@UDate /*tutaj upperlimit daty*/)
																											,0) as Reference3
	, isnull((select sum(PDPD1.Quantity) 
																from (select dpd.ProductBatchId
																		, sum(case when ((ds.IsPW=1 or ds.IsPZ=1) 
																							or (ds.ismm=1 and dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334'))
																					then dpd.FinishCount
																				   when (ds.ismm=1 and dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334') 
																				    then -dpd.FinishCount
																				   when ((ds.ismm=1 and (dpd.WarehouseDstId<>'BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.warehousesrcid <>'BE5CB51D-776F-4236-BA89-507CB5571334'))
																							or (ds.isrw=1 and dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334'))
																				    then '0'
																			 	   else
																					-dpd.FinishCount
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
																	where d.Deleted is null and dpd.Deleted is null and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		/*and ds.IsMM=0*/ 
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																	group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
																where PDPD1.ProductBatchId = pdpd.ProductBatchId  and PDPD1.RealizationDate<@UDate),0) as Reference6

	, 'Reference name / description' as Reference4Title
	, pb.Param2 as Reference4
	, 'Document' as Count0Title
	, convert(nvarchar, pdpd.RealizationDate,102) +'{NewLine}'+PDPD.DocumentNumber as Count0
	, 'Quantity' as Count1Title 
	, replace(replace(convert(nvarchar,convert(money, (case when pdpd.QCB<>'' then 0 else pdpd.Quantity end)),1), '.00',''),',',' ') as Count1 
	, 'After operation' as Count2Title
	, replace(replace(convert(nvarchar,convert(money,isnull((select sum(PDPD1.Quantity) 
															from (select dpd.ProductBatchId
																	,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
																				then dpd.FinishCount
																			else -dpd.FinishCount
																		end) as Quantity
																	,d.DeadlineDate as RealizationDate
																	, dpd.DocumentId as DID
																from DocumentProductDefinition dpd (NOLOCK)
																	inner join Document d (NOLOCK) on d.id= dpd.DocumentId
																	inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
																	inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
																where d.Deleted is null and dpd.Deleted is null 
																	and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																	and ds.Name <> 'PWT - PRÓBKI'
																	and ds.IsMM=0 
																	and ds.IsStockChange=0
																	and d.Realizated is not null
																group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
															where PDPD1.ProductBatchId = pdpd.ProductBatchId and PDPD1.RealizationDate<pdpd.RealizationDate
																											),0)+(case when pdpd.QCB<>'' then 0 else pdpd.Quantity end)),1), '.00',''),',',' ') as Count2
	, 'References' as Count3Title
	, ISNULL((select (CASE WHEN RAD.AdditionalColumnShortString IS NULL 
							THEN NULL 
						ELSE RAD.AdditionalColumnShortString
						END)
			from dbo.RequestAdditionalData RAD
				Inner join dbo.RequestSeriesAdditionalDataView PCAD (NOLOCK) ON RAD.RequestSeriesAdditionalDataId = PCAD.Id
			where PCAD.IsRequestParam = 1 
				and RAD.Deleted is null 
				and PCAD.DataName = 'Ref. numer zamówienia' 
				AND RAD.RequestId =(select isnull(dbo.GetFirstRequestInTree(w1.RequestId)
										,w1.requestid)
									from (select top 1 ri.RequestId 
											from DocumentProductDefinition dpd 
												inner join ProductionMaterialsDocumentProductDefinition pmdpd (NOLOCK) on pmdpd.DocumentProductDefinitionId= dpd.Id
												inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pmdpd.ProductionMaterialId
												inner join RequestItemProductionOrderItem ripoi (NOLOCK) on ripoi.ProductionOrderItemId = pmpoi.ProductionOrderItemId
												inner join RequestItems ri (NOLOCK) on ri.Id = ripoi.RequestItemId
											where dpd.Deleted is null and pmdpd.Deleted is null and pmpoi.Deleted is null and ripoi.Deleted is null and ri.Deleted is null
											and dpd.DocumentId=PDPD.DID ) as w1)),'') + PDPD.QCB as Count3
	, PDPD.RealizationDate as DocDate
	, DENSE_RANK() OVER(ORDER BY pb.param1 ASC) as pos
	, 'Cap / Label' as Reference8Title
	, pb.Param5 as Reference8
 from(select dpd.ProductDefinitionId
		, dpd.ProductBatchId
		, (case when (ds.IsPW=1 or ds.IsPZ=1) 
					then d.DocumentNumber
				else D.DocumentPreNumber
			end) As DocumentNumber
		,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
					then dpd.FinishCount
				else -dpd.FinishCount
			end) as Quantity
		,d.DeadlineDate as RealizationDate
		,dpd.DocumentId as DID
		, (case when ds.IsMM=1 and dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'
			then 'QC relased ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			when ds.IsMM=1 and dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334' 
			then 'QC blocked ' + replace(replace(convert(nvarchar,convert(money, sum(dpd.FinishCount)),1), '.00',''),',',' ') +' pcs.'
			else ''
			end) as QCB

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
		inner join DocumentStatus dst(NOLOCK) on dst.id =d.DocumentStatusId
	where d.Deleted is null and dpd.Deleted is null 
		and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
		and ds.Name <> 'PWT - PRÓBKI'
		and (ds.IsMM=0 or (ds.IsMM=1 and (dpd.warehousesrcid ='BE5CB51D-776F-4236-BA89-507CB5571334' or dpd.WarehouseDstId ='BE5CB51D-776F-4236-BA89-507CB5571334'))) 
		and ds.IsStockChange=0
		and d.DeadlineDate >@LDate 
		and d.DeadlineDate<@UDate 
		and d.Realizated is not null
	group by dpd.ProductDefinitionId, dpd.ProductBatchId,d.DocumentNumber,d.DocumentPreNumber, ds.IsPW, ds.IsPZ, ds.IsMM, d.DeadlineDate, dpd.DocumentId, dpd.WarehouseDstId, dpd.WarehouseSrcId
	
	union all

		select nmw.ProductDefinitionId
			, nmw.Id
			,'NO MOVMENTS'
			, 0
			, @LDate
			, nmw.Id
			, ''
		from (select pb.param1, PB.ProductDefinitionId
				, pb.id
				, row_number() over ( partition by pb.param1 order by pb.param1) as rn

			from ProductBatch pb (NOLOCK)
			where pb.Param1 in (select NOMOV.param1
								from (select PDPD1.param1
										, sum(PDPD1.Quantity) as Quantity
										from (select pb1.Param1
												,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
															then dpd.FinishCount
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
													inner join ProductBatch pb1 (NOLOCK) on pb1.Id = dpd.ProductBatchId
													inner join Document d (NOLOCK) on d.id= dpd.DocumentId
													inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
													inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
													inner join ProductDefinition pd1 (NOLOCK) on pd1.id = dpd.ProductDefinitionId
												where d.Deleted is null 
													and dpd.Deleted is null 
													and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
													and pd1.ProductCategoryId='44CE3D33-EA02-4F68-BD1C-8B3E12D58F2E' 
													and ds.IsMM=0 
													and ds.IsStockChange=0 
													and d.Realizated is not null
													and NOT EXISTS (select pb2.Param1
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
																		AND PB2.Param1 = PB1.Param1 
																	GROUP BY PB2.Param1)

												group by pb1.Param1, ds.IsPW, ds.IsPZ, ds.IsRW, d.DeadlineDate, d.RealizationDate, dpd.DocumentId


								) as PDPD1
							where PDPD1.RealizationDate<@LDate /*³¹czy po pb.param2*/
								group by PDPD1.Param1
									) as NOMOV
							where NOMOV.Quantity > 0)
			) as nmw where nmw.rn = 1
	
	) as PDPD
inner join ProductBatch pb (NOLOCK) on pb.id= Pdpd.ProductBatchId
inner join ProductDefinition pd (NOLOCK) on pd.id = Pdpd.ProductDefinitionId
where (pdpd.Quantity<>0 or pdpd.DocumentNumber='NO MOVMENTS')
	and pd.ProductCategoryId='44CE3D33-EA02-4F68-BD1C-8B3E12D58F2E' /*tylko tuby*/
       and left(pb.param1,3)='FT/'
	and ProductBatchId in (select dpd.productbatchid 
							from (select dpd1.Deleted, 
									dpd1.ProductBatchId,
									dpd1.DocumentId, 
									dpd1.ProductDefinitionId 
								  from DocumentProductDefinition DPD1 (NOLOCK)
								  union all
								  select dpd2.Deleted, 
									dpd2.FinalProductBatchId,
									dpd2.DocumentId, 
									dpd2.ProductDefinitionId  
					 			  from DocumentProductDefinition DPD2 (NOLOCK)
									where FinalProductBatchId is not null) dpd
								inner join Document d (NOLOCK) on d.id = dpd.DocumentId
								inner join ProductDefinition pd (NOLOCK) on pd.id = dpd.ProductDefinitionId
								inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
								inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
							where d.DeadlineDate >@LDate and d.DeadlineDate<@UDate
								AND DPD.Deleted IS NULL AND D.Deleted IS NULL
								AND PC.Name= 'TUBY'
								and ds.Name <> 'PWT - PRÓBKI'
							group by dpd.ProductBatchId

							union all

							select PDPD1.ProductBatchId  
								from (select dpd.ProductBatchId
										,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
													then dpd.FinishCount
												else -dpd.FinishCount
											end ) as Quantity
										,d.DeadlineDate as RealizationDate
										,dpd.DocumentId as DID
									from (select dpd1.Deleted, 
											dpd1.FinishCount,
											dpd1.ProductBatchId,
											dpd1.DocumentId, 
											dpd1.ProductDefinitionId 
										  from DocumentProductDefinition DPD1 (NOLOCK)
										  union all
									      select dpd2.Deleted,
								  		    -DPD2.FinishCount, 
											dpd2.FinalProductBatchId,
											dpd2.DocumentId, 
											dpd2.ProductDefinitionId  
					 					  from DocumentProductDefinition DPD2 (NOLOCK)
								 		  where FinalProductBatchId is not null) dpd
										inner join Document d (NOLOCK) on d.id= dpd.DocumentId
										inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
										inner join DocumentStatus dst (NOLOCK) on dst.id =d.DocumentStatusId
										INNER JOIN ProductDefinition PD (NOLOCK) on PD.id = dpd.ProductDefinitionId
									where d.Deleted is null and dpd.Deleted is null 
										and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE' 
										and pd.ProductCategoryId='44CE3D33-EA02-4F68-BD1C-8B3E12D58F2E' /*tylko tuby*/
										and ds.Name <> 'PWT - PRÓBKI'
										and ds.IsMM=0 
										and ds.IsStockChange=0
										and d.Realizated is not null
									group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId) as PDPD1
	
									where PDPD1.RealizationDate<@LDate /*tu lowerlimit*/
									GROUP BY PDPD1.ProductBatchId 
									having sum(PDPD1.Quantity)>0)
	and (select top 1  RS.Name
			from dbo.RequestAdditionalData RAD (NOLOCK)
				Inner join dbo.RequestSeriesAdditionalDataView PCAD (NOLOCK) ON RAD.RequestSeriesAdditionalDataId = PCAD.Id
				inner join Request R (NOLOCK) on r.id = rad.RequestId
				inner join RequestSeries RS (NOLOCK) on RS.id = R.RequestSeriesId

			where PCAD.IsRequestParam = 1 
				and RAD.Deleted is null and R.deleted is null
				and PCAD.DataName = 'Ref. numer zamówienia' 
				and rad.AdditionalColumnShortString=pb.Param1
				and pb.ProductDefinitionId in (select top 1 ri.ProductDefinitionId from RequestItems ri where ri.RequestId= r.id)
				) <>'Zamówienie testowe'
) as w

where w.ReferenceNo like '%20-0421%'
order by pos asc, ReferenceNo, DocDate