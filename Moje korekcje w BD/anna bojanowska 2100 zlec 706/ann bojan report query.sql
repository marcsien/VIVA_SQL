use Synaptic 
declare @id as uniqueidentifier = (select poi.id from ProductionOrderItems poi where poi.barcode = 'zpc0256/2020/31')

select 
1 as pos
, pc.name as ReferenceNo
, 'Nazwa korka' as Reference1Title
, pd.Name as Reference1
, '' as Reference2Title
, '' as Reference2
, '' as Reference3Title
, '' as Reference3
, '' as Reference4Title
, pd.AdditionalMark as Reference4
, 'W magazynie' as Count0Title
, pb.Name as Count0
, 'Iloœæ' as Count1Title
, lp.Count as Count1
, 'Lokalizacja' as Count2Title
, LPL.BarCode as Count2
, 'Magazyn' as Count3Title
, wh.Name+(case when wh.Name='Surowce - Produkcja (Tuby)' then '{NewLine}surowiec pobrany' else ''  end) as Count3  
, tlp.Created as DocDate



from ProductionMaterials PM (NOLOCK)
inner join ProductDefinition pd (NOLOCK) on pd.id = pm.ProductDefinitionId
inner join ProductCategory pc (NOLOCK) on pc.id = pd.ProductCategoryId
inner join ProductionMaterialsProductionOrderItems pmpoi on pmpoi.ProductionMaterialId = pm.id
left join LogicalProduct lp with(nolock) on lp.ProductDefinitionId = pm.ProductDefinitionId
left join logicalproduct tlp with(nolock) on tlp.id= dbo.GetFirstProductInTransform(lp.id)
left join LogicalPlace LPL (NOLOCK) on LPL.id= lp.LogicalPlaceId
inner join productbatch pb (NOLOCK) on pb.id = lp.ProductBatchId
inner join Warehouse wh (NOLOCK) on wh.id = lp.WarehouseId
left join MeasureUnitLogical MUL (NOLOCK) on mul.id = pd.MeasurmentUnitLogicalId
where pc.Name='Zamkniêcia' and lp.Deleted is null /*and wh.Name<>'Surowce - Produkcja (Tuby)'*/
and pmpoi.ProductionOrderItemId=@id and PM.Deleted is null
