use Synaptic

declare @LDate as datetime = '2020-03-01 00:00:01'
declare @UDate as datetime = '2020-03-31 23:59:59'

select * from (
select * from (
select dpd.ProductDefinitionId
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
	
)	as tmp 
where --tmp.ProductBatchId = 'CB41D4D7-BEAB-4F5A-9D80-0EE5D9A95BF5'
tmp.DID not in (select d.Id from Document d where d.WarehouseDstName = 'Zwroty (Tuby)')
) as pdpd