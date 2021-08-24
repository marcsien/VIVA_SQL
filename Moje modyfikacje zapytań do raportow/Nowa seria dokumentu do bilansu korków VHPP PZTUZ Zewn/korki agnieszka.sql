use SynapticTest

declare @LRangeDate as datetime = '2021-08-01 00:00:00.547'
declare @URangeDate as datetime = '2021-08-30 23:59:18.547'


select b.Product as Count1
	, b.param1 as Count2
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.DocStock as int),0)),1), '.00',''),',',' ')  as Count3
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToWarehouse as int),0)),1), '.00',''),',',' ')  as Count4
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Returns as int),0)),1), '.00',''),',',' ')   as Count5
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(B.OutWarehouse as int),0)),1), '.00',''),',',' ')   as Count6
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast( B.Component as int),0)),1), '.00',''),',',' ')  as Count7
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Destructive as int),0)),1), '.00',''),',',' ')  as Count8
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToQC as int),0)),1), '.00',''),',',' ')  as Count9
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast( b.ToMet as int),0)),1), '.00',''),',',' ')   as Count10
	, b.batch as Count11
	, isnull(Rqst.Rseries,'') as Count12
	, isnull(Rqst.IsProduction,0) as IsProduction 
	, b.OnPz as Count13
	, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.FinStock as int),0)),1), '.00',''),',',' ')  as Count14
	, b.oi
 from ( select dpd.ProductDefinitionId
			, dpd.ProductBatchId
			, pb.Param1
			, pb.param2
			, pd.Name as Product
			, pb.Name as batch
			, pc.Name as Pcategory
			, sum((case when (ds.name='PWT SUR' or ds.Name='pzt'
								or (ds.name='PZTC SUR' 
								or (ds.name='PZTE SUR'
								or ds.name='PWTC SUR'
								OR DS.NAME='PZT US£UGA'
								OR DS.NAME='KOREKTA RWT'
								or DS.NAME='PWT - Zamiana'
								OR DS.NAME='PZTUZ Zewn'
									))
							 ) and (d.DeadlineDate <=@LRangeDate) 
						then dpd.FinishCount  
/*zwroty zaliczam do naszego magazynu bêd¹ liczyæ siê jako coœ co wesz³o ju¿*/
						/*when ((ds.IsMM=1 
								and ds.Name='MMT' 
								and ((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A'
									and (dpd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
									OR (dpd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' 
									or dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334' 
										))
									 ) /*Z ZWROTÓW NA SURWCE PRODUKCJA I SUROWCE TUBY i kontrolê jakoœci*/
									 )
								)
								and (d.DeadlineDate <=@LRangeDate)
							 )
						then dpd.FinishCount*/
	 /*ze zwrotów na magazyn*/
						when ((
								/*(ds.IsMM=1 
								and ds.Name='MMT' 
								and ((dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' 
										or (dpd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' 
										or (dpd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
										or dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'
											))
									 ) and (dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' )
									)
							   )
							    or */
									ds.name='WZT SUR' 
								or (ds.name='wzt' /*by³a jedna pozycja*/ 
									OR DS.NAME='WZT US£UGA'
									or ds.name='KOREKTA PZT') 
								or ((ds.Name='RWT' 
									or ds.Name='RWT SCRAP' 
									or ds.Name='RWT SUR'
									or ds.Name='RWT - ZAMIANA'
									) 
								/*AND DPD.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'*/
								   )
							 ) 
							and (d.DeadlineDate <=@LRangeDate)
						  )
						then -dpd.FinishCount
						else 0 end)) as DocStock

			, sum(case when dpd.WarehouseDstId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2'/*magazyn zewnêtrzny*/  
							and (ds.name='PWT SUR' or ds.name='PWTC SUR' or DS.NAME='PWT - Zamiana') 
							and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
							    )
						then dpd.FinishCount  
						when ds.Name='RWT - ZAMIANA' 
							and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								) 
						then -dpd.FinishCount  else 0 end) as ToWarehouse

			, sum(case when dpd.WarehouseDstId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2'/*magazyn zewnêtrzny*/ 
							and (ds.name='PZTC SUR' or ds.name='PZTE SUR') --------------------------------------------------

								
							and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)

						then dpd.FinishCount 

						when ds.Name = 'PZTUZ Zewn' and (d.DeadlineDate >@LRangeDate and d.DeadlineDate <=@URangeDate)
						then dpd.FinishCount
						


						when ds.Name='RWT - ZAMIANA' 
							and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								) 
						then -dpd.FinishCount  
						else 0 end) as Returns

			, sum((case when (ds.name='WZT SUR' or ds.name='WZT') 

							and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								) 
						then dpd.FinishCount 
						else 0 end)) as OutWarehouse 

			, sum(case when (ds.Name='RWT SCRAP' 
								and (dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
								or dpd.WarehouseSrcId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2'
									)
							 ) 
								and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
									) 
						then dpd.FinishCount 
						else 0 end) as Destructive 
			, sum(case when ( dpd.WarehouseSrcId<>'E2B1B94A-823B-42E5-BAD5-7F7925697EB2' 
								and (ds.Name='RWT SUR')
								and dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'
							 ) and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								   )
						then dpd.FinishCount
						when (	DS.NAME='KOREKTA RWT'
							    and d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								   )
						then -dpd.FinishCount

						else 0 end) as Component

			, sum(case  when (  DS.NAME='KOREKTA RWT'
								and d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								   )
						then -dpd.FinishCount

						else 0 end) oi
/*odpad z metalizacji*/
			, SUM(case when ds.Name='RWT SCRAP'
							AND (dpd.WarehouseSrcId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2') 
							and (d.DeadlineDate >@LRangeDate 
								and d.DeadlineDate <=@URangeDate
								)
						then dpd.FinishCount
						else 0 end) AS ToQC

			, SUM(case when (DS.NAME='PZT US£UGA'
							) AND (dpd.WarehouseDstId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
							  and (d.DeadlineDate >@LRangeDate 
									and d.DeadlineDate <=@URangeDate
								  )
						then dpd.FinishCount
						when (ds.name='WZT US£UGA'
							 ) AND (dpd.WarehouseSrcId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
							  and (d.DeadlineDate >@LRangeDate 
							  and d.DeadlineDate <=@URangeDate
								  )
						then -dpd.FinishCount
						else 0 end) AS ToMet
	/*metalizacja skodzi WZ wchodzi pz  */
			, sum(case when (ds.name='PZTC SUR' 
								or ds.name='PZTE SUR'
							) and (d.DeadlineDate <=@LRangeDate 
									and dpd.FinishCount >0 
								  ) 
						then 1 
						else 0 end ) as OnPz

			,sum((case when (ds.name='PWT SUR' 
								or ((ds.name='PZTC SUR' 
									or ds.name='PZTE SUR'
									) or ds.name='PWTC SUR'
									OR DS.NAME='PZT US£UGA'
									OR DS.NAME='PZT'
									OR DS.NAME='KOREKTA RWT'
									or DS.NAME='PWT - Zamiana'
									or ds.Name = 'PZTUZ Zewn'
								   )
							) and (d.DeadlineDate <=@URangeDate) 
						then dpd.FinishCount  
						when ((ds.IsMM=1 
								and ds.Name='MMT' 
								and ((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
										and (dpd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
											OR (dpd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' 
												or dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334'
											   )
											)
									 ) /*Z ZWROTÓW NA SURWCE PRODUKCJA I SUROWCE TUBY*/
									)
							  ) and (d.DeadlineDate <=@URangeDate)
							 )
						then dpd.FinishCount
	 /*ze zwrotów na magazyn*/
						when ((/*(ds.IsMM=1 
								and ds.Name='MMT' 
								and ((dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' 
									or dpd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' 
									or (dpd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
										or dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'
									   ) 
									 ) and (dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' )
									)
							   ) or*/ ds.name='WZT SUR' 
								 OR DS.NAME='WZT US£UGA'
								 or (ds.name='wzt' 
									or ds.name='KOREKTA PZT'
									) or ((ds.Name='RWT' 
											or ds.Name='RWT SCRAP' 
											or ds.Name='RWT SUR'
											or ds.Name='RWT - ZAMIANA'
										  ) /*AND DPD.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'*/
										 )
							  ) and (d.DeadlineDate <=@URangeDate)
							 ) 
						then -dpd.FinishCount
						else 0 end)) as FinStock

		from document d
			inner join DocumentProductDefinition dpd (NOLOCK) on dpd.DocumentId = d.Id
			inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
			inner join ProductDefinition pd (NOLOCK) on pd.id = dpd.ProductDefinitionId
			inner join ProductBatch pb (NOLOCK) on pb.id = dpd.ProductBatchId
			inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
		where (pc.Name='zamkniêcia') 
			and d.Status=3
			and ((((ds.IsPW=1 
					  and (ds.Name='PWT SUR' 
					  or ds.Name='PWTC SUR'
					  or ds.Name='KOREKTA RWT'
					  or ds.name='PWT - Zamiana'
					  )
					) or (ds.IsPZ=1 
							and (ds.name='PZTC SUR' 
							or ds.name='PZTE SUR'
							OR DS.NAME='PZT US£UGA'
							or ds.name='PZT'
							or ds.Name = 'PZTUZ Zewn'
								)
						 )
				   ) /*and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'*/
				  ) /* or (ds.IsMM=1 
						and ds.Name='MMT' 
						and ((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
								and (dpd.WarehouseDstId='5AE54771-CA23-4363-9847-6AF7436E2823'
									or  (dpd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171'
											or (dpd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E'
												or  dpd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334')
										)
									)
							 ) or (dpd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A'
		/*na zwroty*/				and (dpd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' 
											or (dpd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334' 
												or (dpd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E'
													or (dpd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171')
												   )
												)
										 )
								   )		 
							)
						)*/ 
					 or (ds.IsWZ=1 
								and (ds.Name='WZT SUR' 
										or ds.Name='WZT' 
										or ds.Name='KOREKTA PZT'
										OR DS.NAME='WZT US£UGA'
									)
							) or (((ds.IsRW=1 and ds.Name='RWT - ZAMIANA')
									or (ds.IsRW=1 and (ds.Name='RWT SCRAP' or ds.Name='RWT'))
									or (ds.IsRW=1 and ds.Name='RWT SUR')
									
								  ) /*and  dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'*/
								 )
				) /*ju¿ nie wykluczony magazyn zwrotów bo wchodz¹ i zchodz¹ dokumentami pz pw wz itd*/
			and d.Deleted is null and dpd.Deleted is null and ds.Deleted is null and pd.Deleted is null and pb.Deleted is null and pc.Deleted is null

		group by dpd.ProductDefinitionId, dpd.ProductBatchId, pd.Name,pb.Name, pb.Param1,pb.Param2, pc.Name
	) as B
	left join (select rs.Name as Rseries
				, RS.InSettlementProductionOrder AS IsProduction
				, isnull((select RAD.AdditionalColumnShortString 
							from dbo.RequestAdditionalData RAD (NOLOCK)
								Inner join dbo.RequestSeriesAdditionalDataView PCAD (NOLOCK) ON RAD.RequestSeriesAdditionalDataId = PCAD.Id
							where PCAD.IsRequestParam = 1 
								and RAD.Deleted is null 
								and PCAD.DataName = 'Ref. numer zamówienia'
								And PCAD.RequestSeriesId = RS.ID 
								AND RAD.RequestId = R.ID),rs.Name
						) as Ref
				from request r
					inner join RequestSeries rs (NOLOCK) on rs.id = r.RequestSeriesId
				where r.Deleted is null and rs.Deleted is null
			 ) as Rqst on Rqst.ref=b.Param1 
	left join ( select rs.Name as rsn
					, ri.ProductBatchId
				from requestitems ri 
					inner join request r (NOLOCK) on r.id = ri.RequestId
					inner join RequestSeries rs (NOLOCK) on rs.id = r.RequestSeriesId
				group by rs.Name, ri.ProductBatchId
			  ) as ts on ts.ProductBatchId = b.ProductBatchId
where (b.DocStock<>0 or b.ToWarehouse<>0 or b.Returns<>0 or b.OutWarehouse<>0 or b.Component<>0 or b.Destructive<>0 or b.ToQC<>0 or b.FinStock<>0)

and B.Product = '385_197_000_SC_SC_WT_G_A'

group by b.Product 
	, b.param1 
	, b.DocStock
	, b.ToWarehouse 
	, b.Returns
	, B.OutWarehouse
	, B.Component
	, b.Destructive
	, b.ToQC
	, b.ToMet
	, b.batch
	, Rqst.Rseries
	, Rqst.IsProduction
	, b.OnPz
	, b.FinStock
	, ts.rsn
	, b.Pcategory
	, b.oi
order by /*Rqst.IsProduction desc, */ b.Product, b.pcategory