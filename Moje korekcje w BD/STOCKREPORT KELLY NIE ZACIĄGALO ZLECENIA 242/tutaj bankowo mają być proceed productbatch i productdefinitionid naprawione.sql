use Synaptic

select 
 rad2.AdditionalColumnShortString as Param2
,rad1.AdditionalColumnShortString as param1
,sum(ri.Count) As planned
,sum(prepoi.Proceed) as Proceed
,prepoi.ProductBatchId
,prepoi.ProductDefinitionId
,ri.Id
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


			group by poi.ProductBatchId, poi.ProductDefinitionId,RIPOI.RequestItemId) 
			
			as prepoi on prepoi.RequestItemId = ri.id -- tutaj laczy po requestitemid
/**/

WHERE  PCAD1.IsRequestParam = 1 and RAD1.Deleted is null and PCAD1.DataName = 'Ref. numer zamówienia' --------------------------------------- RI.Deleted IS NULL
and PCAD2.IsRequestParam = 1 and RAD2.Deleted is null and PCAD2.DataName = 'Nazwa ref. towaru'
and rad1.AdditionalColumnShortString = 'FT/20-0242/01' --or rad1.AdditionalColumnShortString = 'FT/20-0241/01'
group by rad2.AdditionalColumnShortString, rad1.AdditionalColumnShortString, prepoi.ProductBatchId, prepoi.ProductDefinitionId, ri.Id