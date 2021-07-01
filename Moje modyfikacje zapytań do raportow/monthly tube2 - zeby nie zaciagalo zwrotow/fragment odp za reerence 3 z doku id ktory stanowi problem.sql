use Synaptic

declare @LDate as datetime = '2020-03-01 00:00:01'
declare @UDate as datetime = '2020-03-31 23:59:59'

select dpd.ProductBatchId
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
																	where d.Deleted is null and dpd.Deleted is null 
																		and d.DocumentStatusId <>'95D50618-26B8-4B48-9146-BC983A8E8EDE'
																		and ds.Name <> 'PWT - PRÓBKI'
																		and ds.IsMM=0 
																		and ds.IsStockChange=0
																		and d.Realizated is not null
																		and dpd.WarehouseDstId <> '0B26B42E-91E1-42AE-BE4D-17F4619F766A'
																		and dpd.DocumentId = '05647D97-33E4-4362-BE6F-2B5640234CD9'
																	group by dpd.ProductBatchId, ds.IsPW, ds.IsPZ, d.DeadlineDate, dpd.DocumentId