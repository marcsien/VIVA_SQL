use Synaptic
declare @LDate as datetime = '2019-12-01 00:00:01'
declare @UDate as datetime = '2019-12-15 23:59:59'

select PDPD1.Id
										, sum(PDPD1.Quantity) as Quantity
										from (select pb1.id
												,sum(case when (ds.IsPW=1 or ds.IsPZ=1) 
															then dpd.FinishCount
														 when (ds.isRW=1 and ds.Name<>'RWT SCRAP')
															then -dpd.OriginCount----------------------------------------------------
													else
														-dpd.FinishCount
														end) as Quantity---------------------------------
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
													and dpd.FinishCount > 0 
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
									