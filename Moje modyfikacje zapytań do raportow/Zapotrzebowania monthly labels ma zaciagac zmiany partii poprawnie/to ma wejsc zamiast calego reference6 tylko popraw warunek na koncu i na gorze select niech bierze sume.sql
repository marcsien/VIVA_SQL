use Synaptic
declare @LDate as datetime = '2019-11-01 00:00:00'
declare @UDate as datetime = '2019-11-30 23:59:59'


select sum(PDPD1.Quantity) 
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
																where PDPD1.Param2 = 'R-22847730001' and PDPD1.Param3= 'LF BEAUTY PZ CUSSONS FUDGE XPANDER GELEE SHAMPOO 250ML' and PDPD1.RealizationDate<@UDate