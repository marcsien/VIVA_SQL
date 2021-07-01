use Synaptic
declare @id as uniqueidentifier = (select poi.Id from ProductionOrderItems poi where poi.Barcode = 'ZPP0042/2020/21')

select 1 as pos
, pc.name as ReferenceNo
, 'Rodzaj etykiety' as Reference1Title
, pd.Name as Reference1
, 'Kod etykiety' as Reference2Title
, pb.Param2 as Reference2
, '' as Reference3Title
, '' as Reference3
, 'Tytu³' as Reference4Title
, (Select top 1 pb1.param3 from ProductBatch pb1 where pb1.Param2= pb.Param2 order by pb1.Created desc)  
as Reference4
, 'Partia' as Count0Title
, pb.Name +'{NewLine} od ' + convert(varchar,min(tlp.created), 102) +' do ' + convert(varchar,max(tlp.created), 102) as Count0
, 'Iloœæ' as Count1Title
, CONVERT(varchar,cast(sum(lp.Count) as int))+' szt.{NewLine}'+convert(varchar, cast(lp.Count as int))+' szt. X '+convert(nvarchar, count(lp.Count))+' opak.' as Count1
, 'Lokalizacja' as Count2Title
, LPL.BarCode as Count2
, 'Magazyn' as Count3Title
, wh.Name+(case when wh.Name='Surowce - Produkcja (Tuby)' then '{NewLine}surowiec pobrany'  else '' end) as Count3  
, min(tlp.created) as DocDate
from 
logicalproduct  lp with (nolock)
inner join ProductDefinition pd (NOLOCK) on pd.id = lp.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
left join ProductBatch pb (NOLOCK) on pb.id = lp.ProductBatchId
left join Warehouse wh (NOLOCK) on wh.id = lp.WarehouseId
left join LogicalPlace LPL (NOLOCK) on LPL.id= lp.LogicalPlaceId
left join logicalproduct tlp (NOLOCK) on tlp.id= dbo.GetFirstProductInTransform(lp.id)

where lp.Deleted is null /*and wh.Name<>'Surowce - Produkcja (Tuby)'*/
and pb.Param2 = (select top 1 pb.Param2 from ProductionMaterials PM (NOLOCK)
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductBatch pb (NOLOCK) on pb.id = pm.ProductBatchId
inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pm.id

where pc.Name='etykiety' and pmpoi.ProductionOrderItemId=@Id and pmpoi.deleted is null)
-- poni¿szy warunek ogranicza³ listê do etykiet o takiej samej nazwie wy³aczone wg uzgodnieñ z kelly i adrianem 
/*and pb.Param3 = (select top 1 pb.Param3 from ProductionMaterials PM (NOLOCK)

inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductBatch pb (NOLOCK) on pb.id = pm.ProductBatchId
inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pm.id

where pc.Name='etykiety' and pmpoi.ProductionOrderItemId=@Id and pmpoi.deleted is null)*/
and lp.StockId<>'44AB3758-EF2A-482F-845B-03909D39F4E5' /*wy³¹czony zasób kontroli jakoœci*/
group by wh.Name, lp.Count, pd.Name, pb.Name, pb.Param2, LPL.BarCode, pc.Name

union all

select 
2 as pos
, pc.name as ReferenceNo
, 'Nazwa Barwnika' as Reference1Title
, pd.Name as Refenrence1
, '' as Reference2Title
, '' as Reference2
, '' as Reference3Title
, '' as Reference3
, 'Kod barwnika' as Reference4Title
, pd.AdditionalMark as Reference4
, 'W magazynie' as Count0Title
, 'od ' + convert(varchar,tlp.created, 102) as Count0
, 'Iloœæ' as Count1Title
, CONVERT(varchar,cast(sum(lp.Count) as float))+' kg.' as Count1
, 'Lokalizacja' as Count2Title
, LPL.BarCode as Count2
, 'Magazyn' as Count3Title
, wh.Name+(case when wh.Name='Surowce - Produkcja (Tuby)' then '{NewLine}surowiec pobrany'  end) as Count3  
, tlp.created as DocDate

from ProductionMaterials PM (NOLOCK)
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pm.id
left join LogicalProduct lp (NOLOCK) on lp.ProductDefinitionId = pm.ProductDefinitionId
left join logicalproduct tlp (NOLOCK) on tlp.id= dbo.GetFirstProductInTransform(lp.id)
left join LogicalPlace LPL (NOLOCK) on LPL.id= lp.LogicalPlaceId
inner join Warehouse wh (NOLOCK) on wh.id = lp.WarehouseId
where pc.Name='Barwniki tuby' and lp.Deleted is null /*and wh.Name<>'Surowce - Produkcja (Tuby)'*/
and pmpoi.ProductionOrderItemId=@Id and pm.deleted is null and pmpoi.deleted is null
group by pc.Name, pd.Name,pd.AdditionalMark,lpl.BarCode,wh.Name, tlp.Created
union all
select 1 as pos
, pc.name as ReferenceNo
, 'Rodzaj etykiety' as Reference1Title
, pd.Name as Reference1
, 'Kod etykiety' as Reference2Title
, pb.Param2 as Reference2
, '' as Reference3Title
, '' as Reference3
, 'Tytu³' as Reference4Title
, pb.Param3 as Reference4
, 'Partia' as Count0Title
, 'Brak etykiet w magazynie' as Count0
, 'Iloœæ' as Count1Title
, '' as Count1
, 'Lokalizacja' as Count2Title
, '' as Count2
, 'Magazyn' as Count3Title
, '' as Count3  
, '' as DocDate
from 
ProductionMaterials PM (NOLOCK)
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductBatch pb (NOLOCK) on pb.id = pm.ProductBatchId
inner join ProductionMaterialsProductionOrderItems pmpoi (NOLOCK) on pmpoi.ProductionMaterialId = pm.id
where pmpoi.deleted is null and pc.Name='etykiety' and pmpoi.ProductionOrderItemId=
(case when 0=isnull(
(select sum(lpk.count) SumCount
from 
logicalproduct  lpk with (nolock) 
inner join ProductBatch PBk (NOLOCK) on PBk.id = lpk.ProductBatchId
left join Warehouse whk (NOLOCK) on whk.id = lpk.WarehouseId
left join LogicalPlace LPLk (NOLOCK) on LPLk.id= lpk.LogicalPlaceId
left join logicalproduct tlpk (NOLOCK) on tlpk.id= dbo.GetFirstProductInTransform(lpk.id)

where pm.deleted is null and pmpoi.deleted is null and lpk.Deleted is null /*and whk.Name<>'Surowce - Produkcja (Tuby)'*/ and lpk.ProductDefinitionId=pd.id and pbk.Param2=pb.Param2
group by lpk.ProductDefinitionId, PBk.Param2)
,'0'
)
then @Id
else pb.id
end
)

union all

SELECT 
'3' AS pos
, 'Przewidywane zu¿ycie surowców w danym etapie' AS ReferenceNo
,'Obliczone na podstawie' AS Reference1Title
, 'Technologii' AS Reference1
, '' AS Reference2Title
, '' AS Reference2
, '' AS Reference3Title
, '' AS Reference3
, '' AS Reference4Title
, '' AS Reference4
, 'Surowiec' AS Count0Title
, pd.Name AS Count0
, 'Iloœæ' AS Count1Title
, convert(varchar, cast(sum(pm.Count) as float))+' ' + MUL.Abbreviation AS Count1
, '' AS Count2Title
, '' AS Count2
, 'Partia' AS Count3Title
, pb.Name AS Count3
, pd.Created AS DocDate
FROM  
ProductionMaterials pm (NOLOCK)
INNER JOIN ProductionMaterialsProductionOrderItems PMPOI (NOLOCK) ON PMPOI.ProductionMaterialId = pm.Id
INNER JOIN ProductDefinition PD (NOLOCK) ON PD.ID = PM.ProductDefinitionId
LEFT JOIN ProductBatch PB (NOLOCK)  ON PB.Id = PM.ProductBatchId
left join MeasureUnitLogical MUL (NOLOCK) on MUL.id = pd.MeasurmentUnitLogicalId
WHERE PMPOI.deleted is null and
WarehouseFactor ='-1'
and pm.ManufacturingPositionSchedulerId is not null -- zla ilosc sie zaciagala do drugiego etapu 14 02 2020 poprawka ---------------------------

and PMPOI.ProductionOrderItemId IN (
	SELECT POI.ID FROM
		productionorderitems poi
		where poi.ProductionOrderId IN ( 
			select poi1.productionorderid from 
				ProductionOrderItems Poi1
				where poi.id =@id
			)	
)
group by pd.Name, pb.Name, pd.Created, MUL.Abbreviation
order by pos, count3, DocDate

