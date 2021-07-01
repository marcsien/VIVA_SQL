use Synaptic


select ripoi.param2 as ReferenceNo, ripoi.Param1 
 as MoldName
, cast(sum(ripoi.Proceed) as int) as Proceed
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(ripoi.planned) as int),0)),1), '.00',''),',',' ') as TubeRequested
--,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum((case when st.InHouse is null then '0' else st.InHouse end) + (case when STout.OutPcs is null then '0' else STout.OutPcs end)) as int),0)),1), '.00',''),',',' ') as LabelUsed
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(
(case when st.InHouse is null then '0' else st.InHouse end) + (case when STout.OutPcs is null then '0' else STout.OutPcs end)
) as int),0)),1), '.00',''),',',' ') as LabelUsed

,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(st.InHouse)  as int),0)),1), '.00',''),',',' ')  as OrderStatus
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(sum(STout.OutPcs) as int),0)),1), '.00',''),',',' ') 
 as TotalDocWaste
,replace(replace(convert(nvarchar,convert(money,ISNULL(cast(
sum(ripoi.planned-isnull(st.InHouse,0)-isnull(STout.OutPcs,0)
) as int),0)),1), '.00',''),',',' ') as DocPerc

, (select 
	isnull(convert(nvarchar, cast(sum(plp.count) as int)) + ' pallet x ' +
		isnull(case when floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer))=0 then '' else cast(floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer)) as nvarchar) +' layers' end +
		(case when isnull(BDPD.CountInLayer,MBDPD.countinLayer)*floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer)) < sum(lp.count)/sum(plp.count) then 
		case when floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer))=0 then '' else ' + ' end +
		convert(nvarchar,cast((sum(lp.count)/sum(plp.count) -(isnull(BDPD.CountInLayer,MBDPD.countinLayer)*floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer))))/muls.Denominator as int)) +
		case when (sum(lp.count)/sum(plp.count) -(isnull(BDPD.CountInLayer,MBDPD.countinLayer)*floor(sum(lp.count)/sum(plp.count)/isnull(BDPD.CountInLayer,MBDPD.countinLayer))))/muls.Denominator = 1 then ' tray' else ' trays' end else '' end ),'not defined')
	+' ' +
	isnull(convert(nvarchar,cast(sum(lp.count)/sum(plp.count)  as int)) +' pcs/pal'  + convert(nvarchar,cast(sum(lp.count)/sum(plp.count) / muls.Denominator as int) ) + ' trays','')+'{NewLine}','') 
from LogicalProduct LP with (nolock) 	
inner join logicalproduct PLP with (nolock) on PLP.id = LP.parentlogicalproductid
left join BoxDefinitionProductDefinition MBDPD on MBDPD.ProductDefinitionId = lp.ProductDefinitionId and MBDPD.IsDefault = 1
left join BoxDefinition BD on BD.id = PLP.BoxDefinitionId
left join BoxDefinitionProductDefinition BDPD on BDPD.ProductDefinitionId = lp.ProductDefinitionId and BDPD.BoxDefinitionId = PLP.BoxDefinitionId and bdpd.Deleted is null
LEFT JOIN MeasureUnitLogicalScaler muls  (nolock) ON MULS.ProductDefinitionId = lp.ProductDefinitionId AND MULS.Deleted IS NULL AND MULS.ResultMeasureUnitLogicalId='AEDB4CF0-07B2-4830-B6BB-D6D3F81CF496'

where lp.ProductBatchId= ST.ProductBatchId and lp.deleted is null and lp.WarehouseId <>'BE5CB51D-776F-4236-BA89-507CB5571334' and lp.WarehouseId <>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'
group by lp.ProductBatchId, lp.ProductDefinitionId, lp.count , plp.Count, BDPD.countinlayer, muls.Denominator,MBDPD.CountInLayer
for xml path ('')) as Overproduction

FROM 
(select rad2.AdditionalColumnShortString as Param2, rad1.AdditionalColumnShortString as param1, sum(ri.Count) As planned, sum(prepoi.Proceed) as Proceed, prepoi.ProductBatchId, prepoi.ProductDefinitionId
 from
RequestItems ri (NOLOCK)
inner join request r (NOLOCK) on r.id = ri.RequestId
left join RequestAdditionalData rad1 (NOLOCK) on rad1.RequestId=r.Id
Inner join dbo.RequestSeriesAdditionalDataView PCAD1 (NOLOCK)
ON RAD1.RequestSeriesAdditionalDataId = PCAD1.Id

left join RequestAdditionalData rad2 (NOLOCK) on rad2.RequestId=r.Id
Inner join dbo.RequestSeriesAdditionalDataView PCAD2 (NOLOCK)
ON RAD2.RequestSeriesAdditionalDataId = PCAD2.Id

left join
(select sum(poi.finishcount) as Proceed, poi.ProductBatchId, poi.ProductDefinitionId, RIPOI.RequestItemId
from
 dbo.ProductionOrderItems POI (NOLOCK)
left join dbo.RequestItemProductionOrderItem RIPOI (NOLOCK) ON RIPOI.ProductionOrderItemId = POI.Id
where POI.Deleted is null


group by poi.ProductBatchId, poi.ProductDefinitionId,RIPOI.RequestItemId) as prepoi on prepoi.RequestItemId = ri.id
/**/

WHERE RI.Deleted IS NULL and PCAD1.IsRequestParam = 1 and RAD1.Deleted is null and PCAD1.DataName = 'Ref. numer zamówienia'
and PCAD2.IsRequestParam = 1 and RAD2.Deleted is null and PCAD2.DataName = 'Nazwa ref. towaru'
group by rad2.AdditionalColumnShortString, rad1.AdditionalColumnShortString, prepoi.ProductBatchId, prepoi.ProductDefinitionId
) as ripoi
left join (
select lp.productbatchid, SUM(LP.Count) AS InHouse
from logicalproduct lp with (nolock) 
where lp.deleted is null and lp.WarehouseId <>'BE5CB51D-776F-4236-BA89-507CB5571334' and lp.WarehouseId <>'0B26B42E-91E1-42AE-BE4D-17F4619F766A'
group by lp.ProductBatchId
) as ST on st.ProductBatchId = riPOI.ProductBatchId
left join
(
select dpd.ProductBatchId, sum(dpd.FinishCount) OutPcs

from DocumentProductDefinition dpd (NOLOCK)
inner join document d (NOLOCK) on d.id = dpd.DocumentId
INNER JOIN DocumentSeries AS DS ON DS.Id = D.DocumentSeriesId
--left join DocumentProductDefinitionTaskItem dpdti on dpdti.DocumentProductDefinitionId = dpd.Id
where (ds.IsWZ = '1' or ds.IsRW = '1') and d.realizated is not null and d.Status='3' and ds.Id <> 'E956E6E4-5E46-4695-9F40-8C632A23F350'

group by dpd.ProductBatchId
) as STout on STout.ProductBatchId = riPOI.ProductBatchId
inner join ProductDefinition pd (NOLOCK) on ripoi.ProductDefinitionId = pd.Id
inner join ProductCategory pc (NOLOCK) on pc.id= pd.ProductCategoryId

where (st.InHouse<>0 and (pc.name='Tuby' or pc.Name='Tuby zintegrowane'))

group by ripoi.param2, ripoi.Param1, pc.Name, st.ProductBatchId
order by ripoi.Param1