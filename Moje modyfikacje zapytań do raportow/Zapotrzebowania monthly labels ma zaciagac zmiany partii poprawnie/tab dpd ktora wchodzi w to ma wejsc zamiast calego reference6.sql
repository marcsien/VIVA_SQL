use Synaptic

--select * from Document d 
select * from
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
																			where dpd2.FinalProductBatchId is not null*/) dpd
inner join ProductBatch pb on dpd.ProductBatchId = pb.Id
inner join Document d on dpd.DocumentId = d.Id
where pb.Param2 = 'R-22847730001' and pb.Param3 = 'LF BEAUTY PZ CUSSONS FUDGE XPANDER GELEE SHAMPOO 250ML'