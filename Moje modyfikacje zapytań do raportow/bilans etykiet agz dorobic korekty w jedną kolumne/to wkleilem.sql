select 
	 b.Product Count1 
	,ISNULL((select TOP 1 PB1.Param1 from ProductBatch pb1 (NOLOCK)
				INNER JOIN RequestItems ri1 (NOLOCK) ON ri1.ProductBatchId = PB1.Id
				INNER JOIN Request r1 (NOLOCK) ON r1.ID = RI1.RequestId
				INNER JOIN RequestRelations rr1 (NOLOCK) ON rr1.ParentRequestId = r1.Id
				inner join RequestRelations RR2 (NOLOCK) on rr2.ParentRequestId = RR1.REQUESTID
				INNER JOIN RequestItems Ri2 (NOLOCK) ON ri2.RequestId = rr2.RequestId
				WHERE RI2.ProductBatchId=B.ProductBatchId
				and ri1.Deleted is null and rr1.Deleted is null and rr2.Deleted is null and ri2.Deleted is null),b.batch) as Count2

	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.DocStock as int),0)),1), '.00',''),',',' ') Count3
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToWarehouse as int),0)),1), '.00',''),',',' ') Count4
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Returns as int),0)),1), '.00',''),',',' ') Count5
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(B.OutWarehouse as int),0)),1), '.00',''),',',' ') Count6
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(B.Component as int),0)),1), '.00',''),',',' ') Count7
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Destructive as int),0)),1), '.00',''),',',' ') Count8
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToQC as int),0)),1), '.00',''),',',' ') Count9 
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.ToMet as int),0)),1), '.00',''),',',' ') Count10
	, b.Param2 Count11
	
	/*,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.InStock as int),0)),1), '.00',''),',',' ')*/
	,ISNULL((select TOP 1 (case when rsa.Name='Zakoñczone' then convert(nvarchar, ra.Realizated,121) else rsa.name end) from 
				Request ra 
				inner join RequestStatus RSa (NOLOCK) on RSa.Id = Ra.RequestStatusId
				INNER JOIN RequestRelations rra (NOLOCK) ON rra.ParentRequestId = ra.Id
				inner join RequestRelations RRb (NOLOCK) on rrb.ParentRequestId = RRa.REQUESTID
				INNER JOIN RequestItems Rib (NOLOCK) ON rib.RequestId = rrb.RequestId
				WHERE RIb.ProductBatchId = B.ProductBatchId 
				and ra.deleted is null and rra.Deleted is null and rrb.Deleted is null and rib.Deleted is null),
				isnull((select TOP 1 (case when rs3.Name='Zakoñczone' then convert(nvarchar,r3.realizated,121) else rs3.name end)  from 
				Request r3 (NOLOCK)
				inner join RequestStatus RS3 (NOLOCK) on RS3.Id = R3.RequestStatusId
				inner join RequestItems RI3 (NOLOCK) on RI3.RequestId = R3.id
				where RI3.ProductBatchId=B.ProductBatchId
				and r3.Deleted is null and rs3.Deleted is null and ri3.Deleted is null
				),'')) Count12
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.QCInStock as int),0)),1), '.00',''),',',' ') Count13
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.FinStock as int),0)),1), '.00',''),',',' ') Count14
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.BatchChange as int),0)),1), '.00',''),',',' ') Count15
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.FreeSamples as int),0)),1), '.00',''),',',' ') Count16
	,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(b.Revision as int),0)),1), '.00',''),',',' ') Count17
	from ( 
		select 
		ddd.ProductDefinitionId
		, ddd.ProductBatchId
		, ddd.Param1
		, ddd.param2
		, ddd.Param3
		, ddd.Name1 as Product
		, ddd.Name2 as batch
		, ddd.Name3 as Pcategory
		, '' as InStock
		, ddd.WHstock + ddd.QCstock AS QCInStock
		, sum(case when (((ddd.name='PWT SUR' or ddd.name='PZTE SUR') or ddd.name='PZT SUR') OR ddd.Name='PZT US£UGA' or  ddd.name='PWTE SUR') and (ddd.DeadlineDate <=<LRangeDate>) 
						then ddd.FinishCount  
				    when ((ddd.IsMM=1 and ddd.Name='MMT' and ((ddd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and (ddd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
							OR (ddd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' OR ddd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334'))) /*Z ZWROTÓW NA SURWCE PRODUKCJA I SUROWCE TUBY I KONTROLE JAKOSCI*/
							))and (ddd.DeadlineDate <=<LRangeDate>))
						then ddd.FinishCount
/*ze zwrotów na magazyn*/
					when (((ddd.IsMM=1 and ddd.Name='MMT' and ((ddd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' or (ddd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' or (ddd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' or ddd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'))) and (ddd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' )))
						    or /*ds.Name='RWT - ZAMIANA' or */ddd.name='WZT SUR' or ddd.Name='WZT FOC' or (ddd.name='wzt' or ddd.name='KOREKTA PZT') /*by³a jedna pozycja*/ or ((ddd.Name='RWT' or ddd.Name='RWT SCRAP' or ddd.Name='RWT SUR') AND ddd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')) 
							and (ddd.DeadlineDate <=<LRangeDate>))
						then -ddd.FinishCount

					when (ddd.Name = 'Zmiana Partii') and (ddd.DeadlineDate <=<LRangeDate>)
						then ddd.FinishCount

						when (ddd.Name = 'WZT FOC') and (ddd.DeadlineDate <=<LRangeDate>)
						then ddd.FinishCount
				
					else 0 end) as DocStock

		, sum((case when (ddd.name='PZTE SUR' or ddd.name='PZT SUR' OR ddd.Name='PZT US£UGA' ) and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount  
					when (ddd.Name='RWT - ZAMIANA' or (ddd.name='wzt' or ddd.name='KOREKTA PZT')) and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>) 
						then -ddd.FinishCount  
					else 0 end)) as ToWarehouse

		, sum((case when (ddd.name='PWT SUR') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount 
					else 0 end)) as Returns

		, sum(case when (ddd.IsBatchChange = 1) and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount 
					else 0 end) as BatchChange

		, sum(case when (ddd.Name = 'WZT FOC') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
			  then -ddd.FinishCount 
			  else 0 end) as FreeSamples

		, sum(case when (ddd.Name = 'KOREKTA RWT') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
			  then ddd.FinishCount
				   when (ddd.Name = 'Korekta WZT') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
			  then ddd.FinishCount
			  else 0 end) as Revision

		, sum((case when (ddd.name='WZT SUR') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>) 
						then ddd.FinishCount 
						else 0 end)) as OutWarehouse 
/*waste*/
		, sum((case when ((ddd.Name='RWT SCRAP') and ddd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>) 
						then ddd.FinishCount 
					else 0 end)) as Destructive 
/*do produkcji*/
		, sum((case when ((ddd.Name='RWT SUR' )  and ddd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A') and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount 
					WHEN (ddd.Name='PWTE SUR' AND ddd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>) ) 
						THEN -ddd.FinishCount 
					else 0 end)) as Component
		, SUM(case when ddd.Name='MMT' AND ( (ddd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' 
								or (ddd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' or ddd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334')) and ddd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							    and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount
					when ddd.Name='MMT' AND ((ddd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
								) and (ddd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' or (ddd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334' or ddd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E'))/*zwrot na magazynyn surowców*/
								and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>))
						then -ddd.FinishCount
					else 0 end) AS ToQC

		, SUM(case when ddd.Name='MMT' AND (ddd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' and ddd.WarehouseDstId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2')
							  and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount
					when ddd.Name='MMT' AND (ddd.WarehouseSrcId='E2B1B94A-823B-42E5-BAD5-7F7925697EB2' and ddd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171')
								and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>)
						then -ddd.FinishCount
					else 0 end) AS ToMet

		, sum(case when (ddd.name='PZTE SUR'  OR ddd.Name='PZT US£UGA') and (ddd.DeadlineDate <=<LRangeDate> and ddd.FinishCount >0 ) 
						then 1 
					else 0 end ) as OnPz

		,sum((case when (((ddd.name='PWT SUR' or ddd.name='PZTE SUR') or ddd.name='PZT SUR')  OR ddd.Name='PZT US£UGA'  or  ddd.name='PWTE SUR') and (ddd.DeadlineDate <=<URangeDate>) 
						then ddd.FinishCount  
					when ((ddd.IsMM=1 and ddd.Name='MMT' and ((ddd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' and (ddd.WarehouseDstId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' OR (ddd.WarehouseDstId='874285B6-5CA8-4577-94E9-57E322CE1171' or ddd.WarehouseDstId='BE5CB51D-776F-4236-BA89-507CB5571334'))) /*Z ZWROTÓW NA SURWCE PRODUKCJA I SUROWCE TUBY*/
										)) /*Z zwrotów NA SURWCE PRODUKCJA I SUROWCE TUBY i na kontrol*/
									    and (ddd.DeadlineDate <=<URangeDate>))
						then ddd.FinishCount
 /*ze zwrotów na magazyn*/
					when (((ddd.IsMM=1 and ddd.Name='MMT' and ((ddd.WarehouseSrcId='5AE54771-CA23-4363-9847-6AF7436E2823' or (ddd.WarehouseSrcId='874285B6-5CA8-4577-94E9-57E322CE1171' or (ddd.WarehouseSrcId='D6AFC5DA-ACCB-47E9-A1EA-0635D1976B4E' or ddd.WarehouseSrcId='BE5CB51D-776F-4236-BA89-507CB5571334'))) and (ddd.WarehouseDstId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' )))
									    or /*ds.Name='RWT - ZAMIANA' or */ ((ddd.name='WZT SUR' or ddd.Name='WZT FOC' or (ddd.name='wzt' or ddd.name='KOREKTA PZT'))) or ((ddd.Name='RWT' or ddd.Name='RWT SCRAP' or ddd.Name='RWT SUR') AND ddd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')) 
										and (ddd.DeadlineDate <=<URangeDate>))
						then -ddd.FinishCount
						--when(ddd.IsBatchChange = 1 and (ddd.DeadlineDate ><LRangeDate> and ddd.DeadlineDate <=<URangeDate>))
						--then -ddd.FinishCount

						when (ddd.Name = 'Zmiana Partii') and (ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount

						when (ddd.Name = 'WZT FOC') and (ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount

						when (ddd.Name='KOREKTA RWT' or ddd.Name='Korekta WZT') and (ddd.DeadlineDate <=<URangeDate>)
						then ddd.FinishCount



					else 0 end)) as FinStock

				

	

		from
		(select --tu sie zaczyna ddd  tu sie zaczyna ddd tu sie zaczyna ddd tu sie zaczyna ddd tu sie zaczyna ddd tu sie zaczyna ddd tu sie zaczyna ddd
			dpd.ProductDefinitionId
			, dpd.ProductBatchId
			, pb.Param1
			, pb.param2
			, pb.Param3
			, pd.Name as Name1
			, pb.Name as Name2
			, pc.Name as Name3
			, wst.WHstock 
			, WST.QCstock
			, ds.Name
			, d.DeadlineDate
			, (case when (ds.Name='Zmiana Partii') 
						then -dpd.FinishCount 
					else dpd.FinishCount end ) as FinishCount
			--, dpd.FinishCount -- tutaj mozna kiedys dac case i z minussem jeœli zmiana partii 
			, ds.IsMM
			, dpd.WarehouseSrcId
			, dpd.WarehouseDstId
			,ds.IsBatchChange
		
		
			from document d with(nolock)
			inner join DocumentProductDefinition dpd with(nolock) on dpd.DocumentId = d.Id
			inner join DocumentSeries ds with(nolock) on ds.id = d.DocumentSeriesId
			inner join ProductDefinition pd with(nolock) on pd.id = dpd.ProductDefinitionId
			inner join ProductBatch pb with(nolock) on pb.id = dpd.ProductBatchId
			inner join ProductCategory pc with(nolock) on pc.id = pd.ProductCategoryId
			left join (
						select pb.id
						, SUM(case when (lp.WarehouseId='BE5CB51D-776F-4236-BA89-507CB5571334' or lp.WarehouseId='0B26B42E-91E1-42AE-BE4D-17F4619F766A') 
										then lp.Count 
									else 0 end)  as QCstock 
						, SUM(case when (lp.WarehouseId<>'BE5CB51D-776F-4236-BA89-507CB5571334' AND lp.WarehouseId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A') 
										then lp.Count 
									else 0 end)  as WHstock 

						from logicalproduct lp with(nolock) 
							inner join ProductBatch pb with(nolock) on pb.id = lp.ProductBatchId 
							inner join ProductDefinition pd with(nolock) on pd.id = lp.ProductDefinitionId
							inner join ProductCategory pc with(nolock) on pc.id = pd.ProductCategoryId 

						where (lp.Deleted is null or lp.deleted><WHDate>) and pc.Name='etykiety' and pb.deleted is null
						group by pd.Id , pb.Id) as wst on wst.id = pb.Id


						where (pc.Name='Etykiety') and d.Status=3
							and (((ds.IsPW=1 and ds.Name='PWT SUR') 
							or (ds.IsPW=1 and dS.Name='PWTE SUR')
							or (ds.IsPW=1 and dS.Name='KOREKTA RWT')
							or (ds.IsPz=1 and dS.Name='Korekta WZT')
							or (ds.IsBatchChange=1 and ds.Name = 'Zmiana Partii') 
 /*zast¹piony przez przesuniêcie mm ze zwrotów na wyroby gotowe*/ 
							or ((ds.IsPZ=1 and ds.Name='PZTE SUR') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or ((ds.IsPZ=1 and ds.Name='PZT SUR') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or ((ds.IsPZ=1 and ds.Name='PZT US£UGA') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or  (ds.IsMM=1 and ds.Name='MMT' and 
								((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
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
								)
 
							or ((ds.IsWZ=1 and (ds.Name='WZT SUR' or ds.Name='WZT' or ds.Name='KOREKTA PZT' or ds.Name='WZT FOC') 
								or (ds.IsRW=1 
									and (ds.Name='RWT - ZAMIANA' 
											or  (ds.Name='RWT SCRAP' 
												or (ds.Name='RWT'
													or  ds.Name='RWT SUR')
												)
										)
								)
								) and (dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A' or dpd.warehousesrcid is null))
								) /*wykluczone magazyn zwrotów bo wchodz¹ i zchodz¹ dokumentami mm*/
								)
							and d.Deleted is null and dpd.Deleted is null and ds.Deleted is null and pd.Deleted is null and pb.Deleted is null and pc.Deleted is null
							and pb.Created > '2016-01-01' --ten waruneczek zeby nie zaci¹galo starych partii do rozkminienia czemu wgl zaciaga

								group by ds.name ,ds.IsBatchChange, d.DeadlineDate, dpd.FinishCount,ds.IsMM,dpd.WarehouseSrcId,dpd.WarehouseDstId,
								dpd.ProductDefinitionId, dpd.ProductBatchId, pd.Name,pb.Name, pb.Param1,pb.Param2, pc.Name, pb.Param3, wst.WHstock, wst.QCstock
								
							union 
							








			select 
			  dpd.ProductDefinitionId
			, dpd.FinalProductBatchId as ProductBatchId
			, pb.Param1
			, pb.param2
			, pb.Param3
			, pd.Name as Name1
			, pb.Name as Name2
			, pc.Name as Name3
			, wst.WHstock 
			, WST.QCstock
			, ds.Name
			, d.DeadlineDate
			, dpd.FinishCount
			, ds.IsMM
			, dpd.WarehouseSrcId
			, dpd.WarehouseDstId
			,ds.IsBatchChange
		
		
			from document d with(nolock)
			inner join DocumentProductDefinition dpd with(nolock) on dpd.DocumentId = d.Id
			inner join DocumentSeries ds with(nolock) on ds.id = d.DocumentSeriesId
			inner join ProductDefinition pd with(nolock) on pd.id = dpd.ProductDefinitionId
			inner join ProductBatch pb with(nolock) on pb.id = dpd.FinalProductBatchId
			inner join ProductCategory pc with(nolock) on pc.id = pd.ProductCategoryId
			left join (
						select pb.id
						, SUM(case when (lp.WarehouseId='BE5CB51D-776F-4236-BA89-507CB5571334' or lp.WarehouseId='0B26B42E-91E1-42AE-BE4D-17F4619F766A') 
										then lp.Count 
									else 0 end)  as QCstock 
						, SUM(case when (lp.WarehouseId<>'BE5CB51D-776F-4236-BA89-507CB5571334' AND lp.WarehouseId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A') 
										then lp.Count 
									else 0 end)  as WHstock 

						from logicalproduct lp with(nolock) 
							inner join ProductBatch pb with(nolock) on pb.id = lp.ProductBatchId 
							inner join ProductDefinition pd with(nolock) on pd.id = lp.ProductDefinitionId
							inner join ProductCategory pc with(nolock) on pc.id = pd.ProductCategoryId 

						where (lp.Deleted is null or lp.deleted><WHDate>) and pc.Name='etykiety' and pb.deleted is null
						group by pd.Id , pb.Id) as wst on wst.id = pb.Id


						where (pc.Name='Etykiety') and d.Status=3
							and (((ds.IsPW=1 and ds.Name='PWT SUR') 
							or (ds.IsPW=1 and dS.Name='PWTE SUR')
							or (ds.IsBatchChange=1 and ds.Name = 'Zmiana Partii') 
 /*zast¹piony przez przesuniêcie mm ze zwrotów na wyroby gotowe*/ 
							or ((ds.IsPZ=1 and ds.Name='PZTE SUR') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or ((ds.IsPZ=1 and ds.Name='PZT SUR') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or ((ds.IsPZ=1 and ds.Name='PZT US£UGA') and dpd.WarehouseDstId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A')
							or  (ds.IsMM=1 and ds.Name='MMT' and 
								((dpd.WarehouseSrcId='0B26B42E-91E1-42AE-BE4D-17F4619F766A' 
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
								)
 
							or ((ds.IsWZ=1 and (ds.Name='WZT SUR' or ds.Name='WZT' or ds.Name='KOREKTA PZT' or ds.Name='WZT FOC') 
								or (ds.IsRW=1 
									and (ds.Name='RWT - ZAMIANA' 
											or  (ds.Name='RWT SCRAP' 
												or (ds.Name='RWT'
													or  ds.Name='RWT SUR')
												)
										)
								)
								) and (dpd.WarehouseSrcId<>'0B26B42E-91E1-42AE-BE4D-17F4619F766A' or dpd.warehousesrcid is null))
								) /*wykluczone magazyn zwrotów bo wchodz¹ i zchodz¹ dokumentami mm*/
								)
							and d.Deleted is null and dpd.Deleted is null and ds.Deleted is null and pd.Deleted is null and pb.Deleted is null and pc.Deleted is null
							/*and pb.Created > '2016-01-01'*/

								group by ds.name , d.DeadlineDate, dpd.FinishCount,ds.IsMM,dpd.WarehouseSrcId,dpd.WarehouseDstId,
								dpd.ProductDefinitionId, dpd.ProductBatchId, pd.Name,ds.IsBatchChange,pb.Name, pb.Param1,pb.Param2, pc.Name, pb.Param3, wst.WHstock, wst.QCstock, dpd.FinalProductBatchId
								
						
								) as ddd
								group by  ddd.ProductDefinitionId
										, ddd.ProductBatchId
										, ddd.Param1
										, ddd.param2
										, ddd.Param3
										, ddd.Name1
										, ddd.Name2
										, ddd.Name3
										, ddd.WHstock
										, ddd.QCstock 
								) as B


		where (b.DocStock>0 or b.ToWarehouse>0 or b.Returns<>0 or b.OutWarehouse>0 or b.Component>0 or b.Destructive>0 or b.ToQC>0 or b.FinStock<>0)
		order by b.batch