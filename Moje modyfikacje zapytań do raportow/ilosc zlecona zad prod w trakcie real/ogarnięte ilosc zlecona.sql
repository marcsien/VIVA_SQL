use Synaptic

select (select top 1 d1.DocumentPreNumber
	from document d1 (NOLOCK)
		inner join DocumentTask DT (NOLOCK) on dt.DocumentId = d1.Id
	where d1.Realizated is null and dt.TaskId = dk.TaskId) as ReferenceNo
/*, replace(replace(convert(nvarchar,convert(money,ISNULL(cast((select sum(dpd2.OriginCount) 
	from DocumentProductDefinition dpd2
	inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
	inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
  where dt1.TaskId = dk.TaskId) as int),0)),1), '.00',''),',',' ') as Count1 */
/* zla wersja
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast((select SUM(c.Count) from  -- do weryfikacji ilosc zlecona, powyzej stara wersja zakomentowana
(select distinct pod.Count from ProductionOrderItems poi 
inner join ProductionOrder po on poi.ProductionOrderId = po.Id
inner join ProductionOrderDocument pod on pod.ProductionOrderId = po.Id
inner join Task t on t.DocumentId = pod.DocumentId
where t.Id = dk.TaskId) as c) as int),0)),1), '.00',''),',',' ') as Count1*/
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast((select SUM(dpd.OriginCount) from DocumentProductDefinition dpd 
inner join Document d on d.Id = dpd.DocumentId 
inner join Task t on t.DocumentId=d.Id
where t.Id = dk.TaskId) as int),0)),1), '.00',''),',',' ') as Count1
--, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(dk.ILgen) as int),0)),1), '.00',''),',',' ') as Count2
--, (CASE WHEN CHARINDEX ( ',' , DK.Name )=0 and SUM(dk.ILgen)=SUM(dk.Tosettle) THEN 0 ELSE (ISNULL(cast(sum(dk.ILgen) as int),0))END) Count2 -- sprawdzic na nowszym sql server
, replace(replace(convert(nvarchar,convert(money,ISNULL((CASE WHEN CHARINDEX ( ',' , DK.Name )=0 and SUM(dk.ILgen)=SUM(dk.Tosettle) THEN 0 ELSE (ISNULL(cast(sum(dk.ILgen) as int),0))END),0)),1), '.00',''),',',' ') as Count2

,(select top 1 pb.Name 
	from DocumentProductDefinition dpd1
	inner join DocumentTask DT (NOLOCK) on DT.DocumentId = dpd1.DocumentId
	inner join ProductBatch pb (NOLOCK) on pb.id = dpd1.ProductBatchId
  where dt.TaskId = dk.TaskId) as Count3

--,(select COUNT(DK.TaskId) as liczbapodzialowzlecen) lpodz
--,DK.Name nejm
--,(select COUNT(STRING_SPLIT(DK.Name, ','))  lpodzv2 -- powinno zadzia�a� po wymianie serv synap i sql serv do 2019
--,(CHARINDEX ( ',' , DK.Name )) lpodzviles 
,
(case 
	when	 (CHARINDEX ( ',' , DK.Name )=0)
	then 	(case 
			when	 (select sum(dpd2.OriginCount) 
					 from DocumentProductDefinition dpd2
					 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
					 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
					 where dt1.TaskId = dk.TaskId) = cast(sum(dk.Tosettle) as int)
			then 'Aqua'
			when	 (select sum(dpd2.OriginCount) 
					 from DocumentProductDefinition dpd2
					 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
					 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
					 where dt1.TaskId = dk.TaskId) < cast(sum(dk.Tosettle) as int)
			then 'Lime'
			else 'No Color' 
			end)
	else	(case 
			when	 (select sum(dpd2.OriginCount) 
					 from DocumentProductDefinition dpd2
					 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
					 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
					 where dt1.TaskId = dk.TaskId) - sum(dk.ILgen)  = cast(sum(dk.Tosettle) as int)
			then 'Aqua'
			when	 (select sum(dpd2.OriginCount) 
					 from DocumentProductDefinition dpd2
					 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
					 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
					 where dt1.TaskId = dk.TaskId) - sum(dk.ILgen)  <= cast(sum(dk.Tosettle) as int)
			then 'Lime'
			else 'No Color' 
			end) 
	end) as RowColor 
 /*,
(case 
	when	 (select sum(dpd2.OriginCount) 
			 from DocumentProductDefinition dpd2
			 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
			 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
			 where dt1.TaskId = dk.TaskId) = sum(dk.ILgen)  + cast(sum(dk.Tosettle) as int)
	then 'Aqua'
	when	 (select sum(dpd2.OriginCount) 
			 from DocumentProductDefinition dpd2
			 inner join DocumentTask DT1 (NOLOCK) on DT1.DocumentId = dpd2.DocumentId
			 inner join ProductBatch pb1 (NOLOCK) on pb1.id = dpd2.ProductBatchId
			 where dt1.TaskId = dk.TaskId) < sum(dk.ILgen)  + cast(sum(dk.Tosettle) as int)
	then 'Lime'
	else 'No Color' 
 end) 
 as RowColor
 */
, replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(dk.Tosettle) as int),0)),1), '.00',''),',',' ') as Count4
--, (CASE WHEN (CHARINDEX ( ',' , DK.Name )=0) THEN 0 ELSE (ISNULL(cast(sum(dk.Tosettle) as int),0)) END) Count4 -- spr na nowszym sql server
 , (select top 1 TILP.Created as date from TaskItemLogicalproduct TILP (NOLOCK) 
	inner join TaskItems TI (NOLOCK) on TI.Id = TILP.TaskItemId
	inner join Task T (NOLOCK) on T.Id = TI.TaskId
	where T.Id = dk.TaskId
	order by date desc) as data


from(SELECT t.Name,
t.RealizationDate,
			ti.TaskId,
			ti.ReadyToGenerateDocumentCount  as ILgen,
			ti.ReadyToGenerateDocumentCount-   (select sum(dpdti.CountSettled) as CS 
												from DocumentProductDefinitionTaskItem dpdti
												where dpdti.TaskItemId= ti.Id
												group by dpdti.TaskItemId )  as Tosettle

		FROM TaskItems ti WITH (NOLOCK)
		inner join Task t on t.id = ti.TaskId
		where t.Realizated is null
			and t.Id in (select tski.TaskId 
							from TaskItems TSKI with(nolock)
							inner join DocumentProductDefinitionTaskItem DPDTI (NOLOCK) on DPDTI.TaskItemId = tski.Id
							inner join DocumentProductDefinition dpd (NOLOCK) on dpd.id = dpdti.DocumentProductDefinitionId
							where dpd.DocumentId in ( select dpd1.DocumentId 
														from DocumentProductDefinition dpd1 (NOLOCK)
														inner join Document d1 (NOLOCK) on d1.id = dpd1.DocumentId
														inner join documentseries ds1 (nolock) on ds1.id = d1.DocumentSeriesId
														inner join ProductionMaterialsDocumentProductDefinition PMDPD1 (NOLOCK) on PMDPD1.DocumentProductDefinitionId = dpd1.Id
														inner join ProductionMaterialsProductionOrderItems PMPOI1 (NOLOCK) on pmpoi1.ProductionMaterialId = PMDPD1.ProductionMaterialId
														inner join ProductionOrderItems poi1 (NOLOCK) on poi1.id = PMPOI1.ProductionOrderItemId
														where (poi1.executionend is null or (poi1.executionend is not null and d1.DocumentNumber is null and d1.Deleted is null )) 
															and poi1.Deleted is null
															and ds1.IsPW=1
													)
						)
		) DK
where dk.ILgen<>0
--and DK.Name = 'PrePWT0009/01/2020, PrePWT0049/11/2019'
group by dk.Name, dk.TaskId
order by data asc