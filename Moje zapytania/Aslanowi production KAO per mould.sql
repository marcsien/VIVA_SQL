use Synaptic

--uwaga tylko z dwóch ostatnich lat

declare @LD as datetime = '2019-09-01 00:00:00'
declare @UD as datetime = '2020-08-01 23:59:59'



select 
SUBSTRING(STRING_AGG(dd.Product,';'),0,CHARINDEX(';',STRING_AGG(dd.Product,';')+';')) as Product_Name
,sum(dd.Quantity) as Quantity
--,dd.ExecutionEndTime
,max(dd.ExecutionEndTime) as Execution_End_Time
,dd.Description as FT_Number
--,dd.FormName
,STRING_AGG(dd.FormName,';') as Form_Name

from
(
select po.Comment as Product
--,po.ProductionOrderNumber as InternalOrderNumber
,poi.FinishCount as Quantity
,poi.ExecutionEnd as ExecutionEndTime
,poi.Description
,(
select top 1 d.FormName from (
SELECT        MO.Id, MO.ManufacturingOperationTypeId, MO.ManufacturingPositionId, MO.StartDate, MO.EndDate, ISNULL(MO.Count, 0) AS ProductionCount, ISNULL(MC.AdditionalColumnDecimal, 0) AS MachineCounter, 
                         ISNULL(ACT.AdditionalColumnDecimal, 0) AS AverageCycleTime, ISNULL(MWT.AdditionalColumnDecimal, 0) AS MachineWorkingTime, ISNULL(FORMS.FormName, '') AS FormName, LTRIM(RTRIM(REPLACE(REPLACE(PDAD.Dia, 
                         'm', ''), ',', '.'))) AS Dia, PD.Id AS ProductDefinitionId, mo.ProductionOrderItemId, mo.ShiftsWorkTimeDate, ISNULL(ISG.AdditionalColumnDecimal, 0) AS ISG, ROW_NUMBER() OVER (PARTITION BY 
                         MO.ManufacturingPositionId
ORDER BY MO.StartDate, ISNULL(MC.AdditionalColumnDecimal, 0)) AS OrderNumber, MONTH(MO.StartDate) AS StartDateMonth, Year(MO.StartDate) AS StartDateYear
FROM            ManufacturingOperation MO(NOLOCK) INNER JOIN
                         ProductionOrderItems POI(NOLOCK) ON POI.Id = MO.ProductionOrderItemId INNER JOIN
                         ProductDefinition PD(NOLOCK) ON POI.ProductDefinitionId = PD.Id LEFT JOIN
                             (SELECT        PD.Id, CL.Name AS Dia
                               FROM            ProductDefinition PD(NOLOCK) INNER JOIN
                                                         ProductCategoryAdditionalData PCAD(NOLOCK) ON PD.ProductCategoryId = PCAD.ProductCategoryId INNER JOIN
                                                         ProductDefinitionLogicalProductAdditionalData PDLPAD(NOLOCK) ON PDLPAD.ProductDefinitionId = PD.Id AND PDLPAD.ProductCategoryAdditionalDataId = PCAD.Id INNER JOIN
                                                         Classifier CL ON CL.Id = PDLPAD.ClassifierId INNER JOIN
                                                         ClassifierDefinition CD ON CD.Id = CL.ClassifierDefinitionId AND CD.Name = 'Tube Dia'
                               WHERE        PCAD.Deleted IS NULL AND Cl.Deleted IS NULL AND PDLPAD.Deleted IS NULL AND CD.Deleted IS NULL
                               GROUP BY PD.Id, CL.Name) AS PDAD ON PDAD.Id = PD.Id LEFT JOIN
                             (SELECT        MOAD.ManufacturingOperationId, MOAD.AdditionalColumnDecimal
                               FROM            ManufacturingOperationAdditionalData MOAD INNER JOIN
                                                         ManufacturingOperationTypeAdditionalData MOTAD ON MOTAD.Id = MOAD.ManufacturingOperationTypeAdditionalDataId INNER JOIN
                                                         AdditionalColumnDefinition ACD ON MOTAD.AdditionalColumnDefinitionId = ACD.Id
                               WHERE        MOAD.Deleted IS NULL AND ACD.Name = 'Licznik g³ówny maszyny') AS MC ON MC.ManufacturingOperationId = MO.Id LEFT JOIN
                             (SELECT        MOAD.ManufacturingOperationId, MOAD.AdditionalColumnDecimal
                               FROM            ManufacturingOperationAdditionalData MOAD INNER JOIN
                                                         ManufacturingOperationTypeAdditionalData MOTAD ON MOTAD.Id = MOAD.ManufacturingOperationTypeAdditionalDataId INNER JOIN
                                                         AdditionalColumnDefinition ACD ON MOTAD.AdditionalColumnDefinitionId = ACD.Id
                               WHERE        MOAD.Deleted IS NULL AND ACD.Name = 'Œredni czas cyklu (sek.)') AS ACT ON ACT.ManufacturingOperationId = MO.Id LEFT JOIN
                             (SELECT        MOAD.ManufacturingOperationId, MOAD.AdditionalColumnDecimal
                               FROM            ManufacturingOperationAdditionalData MOAD INNER JOIN
                                                         ManufacturingOperationTypeAdditionalData MOTAD ON MOTAD.Id = MOAD.ManufacturingOperationTypeAdditionalDataId INNER JOIN
                                                         AdditionalColumnDefinition ACD ON MOTAD.AdditionalColumnDefinitionId = ACD.Id
                               WHERE        MOAD.Deleted IS NULL AND ACD.Name = 'Czas pracy na maszynie (godz.)') AS MWT ON MWT.ManufacturingOperationId = MO.Id LEFT JOIN
                             (SELECT        MOAD.ManufacturingOperationId, C.Name AS FormName
                               FROM            ManufacturingOperationAdditionalData MOAD INNER JOIN
                                                         Classifier C ON C.Id = MOAD.ClassifierId INNER JOIN
                                                         ManufacturingOperationTypeAdditionalData MOTAD ON MOTAD.Id = MOAD.ManufacturingOperationTypeAdditionalDataId INNER JOIN
                                                         ClassifierDefinition CD ON MOTAD.ClassifierDefinitionId = CD.Id
                               WHERE        MOAD.Deleted IS NULL AND CD.Name = 'Formy') AS FORMS ON FORMS.ManufacturingOperationId = MO.Id LEFT JOIN
                             (SELECT        MOAD.ManufacturingOperationId, MOAD.AdditionalColumnDecimal
                               FROM            ManufacturingOperationAdditionalData MOAD INNER JOIN
                                                         ManufacturingOperationTypeAdditionalData MOTAD ON MOTAD.Id = MOAD.ManufacturingOperationTypeAdditionalDataId INNER JOIN
                                                         AdditionalColumnDefinition ACD ON MOTAD.AdditionalColumnDefinitionId = ACD.Id
                               WHERE        MOAD.Deleted IS NULL AND ACD.Name = 'Iloœæ sprawnych gniazd') AS ISG ON ISG.ManufacturingOperationId = MO.Id
WHERE        MO.Deleted IS NULL AND MO.ManufacturingOperationTypeId = 'D9433EE6-6179-4630-9DE3-2F991B4C2AAA' AND (year(mo.StartDate) = DATEPART(year,GETDATE()) or year(mo.StartDate) = (DATEPART(year,GETDATE())-1)) 
) d 
where d.ProductionOrderItemId = poi.Id
) as FormName
from ProductionOrder po 
inner join ProductionOrderItems poi on poi.ProductionOrderId = po.Id 
inner join ProductBatch pb on pb.Id = poi.ProductBatchId
where po.Comment like '%KAO%' 
and po.ProductionOrderNumber like '%ZPP%'
and poi.ExecutionEnd between @LD and @UD
and poi.Description like 'FT/%'
and pb.Name like 'TUBE/%'
and poi.FinishCount <> 0
--order by poi.Description, poi.ExecutionEnd desc
) dd
group by dd.Description
