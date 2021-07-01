SELECT 
MP.Name AS IMMtab1 
,SWT.Name AS Shifttab1 
,(case when XX.FormName='' then mp.Description else XX.FormName end) AS Moldtab1 
,ISNULL(PB.Name,'') AS BatchNtab1
,(select ACD.AdditionalColumnShortString 
from dbo.ProductDefinitionLogicalProductAdditionalData ACD (NOLOCK)
Inner join dbo.ProductCategoryAdditionalDataView PCAD (NOLOCK)
ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
where PCAD.IsProductDefinition = 1  
and PCAD.DataName = 'Color' And PCAD.ProductCategoryId = PC.ID AND ACD.ProductDefinitionId = PD.ID and acd.deleted is null) AS Colortab1
,ISNULL(Labelpoi.LABELCODE,'') AS IMLCodetab1

,ISNULL(XX.ProductionCount,0) AS Counttab1

,ISNULL(((XX.MachineWorkingTime/8)*100),0) AS Availibilitytab1 
,ISNULL(((((XX.MachineCounter - XX.PreviousMachineCounter)* (XX.AverageCycleTime))/(8*3600))*100),0) AS Efficiencytab1 
,(((ISNULL(((((XX.MachineCounter - XX.PreviousMachineCounter)* (XX.AverageCycleTime))/(8*3600))*100),0))
/(ISNULL(((XX.MachineWorkingTime/8)*100),1)))*100) AS Utylizationtab1

FROM ManufacturingPosition MP (NOLOCK)
left join ManufacturingPositionType mpt (NOLOCK)
on mpt.Id = mp.ManufacturingPositionTypeId
CROSS JOIN ShiftsWorkTime SWT 
LEFT JOIN ManufacturingOperation MO (NOLOCK) ON  MO.ShiftsWorkTimeId = SWT.Id 
AND CAST(MO.ShiftsWorkTimeDate AS Date) = @CurrentDate
AND MO.ManufacturingOperationTypeId = 
(SELECT Id FROM ManufacturingOperationType (NOLOCK) WHERE Name = 'Rejestracja Produkcji CPM/SSPM'
)and MO.ManufacturingPositionId = MP.Id

left join dbo.VivaManufacturingOperationTableWithPreviousAdditionalDataView XX (NOLOCK)
on xx.Id = MO.Id



LEFT JOIN ProductionOrderItems POI (NOLOCK) ON POI.Id = MO.ProductionOrderItemId
Left join dbo.ProductBatch PB (NOLOCK) ON PB.Id = POI.ProductBatchId
Left join Formula F (NOLOCK) ON F.Id = POI.FormulaId
Left join ProductDefinition PD (NOLOCK) ON PD.Id = F.ProductDefinitionId
Left join ProductCategory PC (NOLOCK) ON PD.ProductCategoryId = PC.Id

left join (
select  pmpoi.ProductionOrderItemId, VPOIWALD.LabelCode
from
ProductionMaterialsProductionOrderItems pmpoi  (NOLOCK)
inner join ProductionMaterials PMT (NOLOCK) on PMT.id = pmpoi.ProductionMaterialId
inner join ProductDefinition PDT (NOLOCK) on PDT.id = PMT.ProductDefinitionId
inner join ProductCategory PCT (NOLOCK) on PCT.id = PDT.ProductCategoryId
inner join VivaProductionOrderItemsWithAdditionalLabelData VPOIWALD (NOLOCK) on VPOIWALD.productbatchid = pmt.ProductBatchId 
where  pct.Name='Tuba-pó³wyrób'
group by pmpoi.ProductionOrderItemId, VPOIWALD.LabelCode
) as Labelpoi on Labelpoi.ProductionOrderItemId = poi.Id


/*left join 
(select PMPOI.ProductionOrderItemId,PB.Param1 AS LABELNZUK
,PB.Param2 AS LABELCODE
,PB.Param3 AS LABELARTICLE
from dbo.ProductionMaterialsProductionOrderItems PMPOI
inner join ProductionMaterials PM ON PM.Id = PMPOI.ProductionMaterialId
inner join ProductDefinition PD ON PD.Id = PM.ProductDefinitionId
inner join ProductCategory PC ON PD.ProductCategoryId = PC.Id
left join ProductBatch PB ON PB.Id = PM.ProductBatchId
where PMPOI.Deleted is null and FormulaItemId IS NOT NULL 
and PC.Name = 'Tuba-pó³wyrób'
group by pmpoi.ProductionOrderItemId, PB.Param2, PB.Param1, PB.Param3
) AS LABELPMPOI ON LABELPMPOI.ProductionOrderItemId = POI.Id
stare teraz poibera z widoku
*/
Where  MO.Deleted IS NULL AND MP.Deleted is null and 
 ((mp.ManufacturingPositionTypeId = '35F7AC91-3C57-4620-A27D-0F60613698CE') or (mp.ManufacturingPositionTypeId='5E9D8423-83FA-4B84-956C-AE90165AD198' or mp.ManufacturingPositionTypeId='4C8E3951-596E-4446-A09C-E872B9C6DBD0'))

ORDER BY MP.Name, SWT.Name