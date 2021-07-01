use Synaptic

declare @id uniqueidentifier = 'DEB3AA7F-C7EB-4CA4-9375-EE9946AAA9B2'

SELECT       
(case when  ds.iswz=1 then isnull(DocumentPreNumber,'') else DocumentNumber end) AS DNumber
, (case when  ds.iswz=1 then isnull(DocumentNumber,'') else DocumentPreNumber end)  AS DPreNumber
, cast(convert(date,D.RealizationDate) as nvarchar)  AS RealizationDate
, cast(convert(date,D.Realizated) as nvarchar)  AS RealizatedDate
, cast(convert(date,D.DeadlineDate) as nvarchar)  AS DeadlineDate
--, cast(convert(date,dsd.StartFinish) as nvarchar)  AS FinishRealizationDate
, cast(convert(date,dsd.StartFinish) as nvarchar)  AS StartRealizationDate
,isnull((' Correction to: ' + (select top 1 acd.AdditionalColumnShortString

from dbo.DocumentAdditionalData ACD (nolock)
	inner join dbo.DocumentSeriesAdditionalData DSAD on DSAD.Id = acd.DocumentSeriesAdditionalDataId
where acd.DocumentId = d.Id
	and acd.Deleted is null
and DSAD.AdditionalColumnDefinitionId ='89339DEC-8697-4D81-A637-E99E06A4E136'
)),'') AS CorrectedDoc

,REPLACE((select (W.Description + ', ') 
from dbo.DocumentProductDefinition DPD (NOLOCK)
inner join Warehouse W (NOLOCK) On W.Id = DPD.WarehouseSrcId 
where DPD.DocumentId = D.Id 
Group by DPD.WarehouseDstId,w.Description 
ORDER BY  W.Description
FOR XML PATH (''))  + '@#$%', ', @#$%','')
AS WarehouseName 

, CSupp.Name AS CompanySupplierName
, CSupp.Nip AS CompanySupplierNIP
, ASupp.Street+' '+ASupp.BuildingNumber AS CompanySupplierAddressStreet
, ASupp.ZipCode+' '+ ASupp.City AS CompanySupplierAddressZipCode

, CRec.Name AS CompanyRecipientName
, CRec.Nip AS CompanyRecipientNIP
, ARec.Street+' '+ARec.BuildingNumber AS CompanyRecipientAddressStreet
, ARec.ZipCode+' '+ ARec.City AS CompanyRecipientAddressZipCode

, cast((select top 1 poi.Description from Document d
inner join  ProductionOrderDocument pod  on pod.DocumentId = d.Id
inner join ProductionOrder po on po.Id = pod.ProductionOrderId
inner join ProductionOrderItems poi on poi.ProductionOrderId = po.Id
where d.Id = @id) as nvarchar)  AS REFNUM



FROM  Document D (NOLOCK)
inner join DocumentSeries ds (NOLOCK) on ds.id = d.DocumentSeriesId
LEFT JOIN Company CSupp (NOLOCK) on CSupp.Id = D.CompanySupplierId
left join CompanyDepartment CDSupp (NOLOCK) on CDSupp.CompanyId = CSupp.id and CDSupp.Deleted is null and CDSupp.Central = 1
left join Address ASupp (NOLOCK) on ASupp.Id = CDSupp.AddressId

LEFT JOIN Company CRec (NOLOCK) on CRec.Id = D.CompanyRecipientId
left join CompanyDepartment CDRec (NOLOCK) on CDRec.CompanyId = CRec.id and CDRec.Deleted is null and CDRec.Central = 1
left join Address ARec (NOLOCK) on ARec.Id = CDRec.AddressId

left join
(
SELECT DISTINCT DPDTI.DocumentId , min(TA.Finished) as StartFinish, max(TA.Finished) as EndFinish
FROM         dbo.DocumentProductDefinitionTaskItem AS DPDTI (NOLOCK)  LEFT OUTER JOIN
                          (select TaskItemId, Finished from Activity (NOLOCK)
where IsDone = '1' and IsRefused='0') AS TA ON TA.TaskItemId = DPDTI.TaskItemId
WHERE     (DPDTI.Deleted IS NULL)
group by DPDTI.DocumentId
) as DSD on dsd.DocumentId = d.id
--left join
--(
--SELECT DISTINCT DPDTI.DocumentId , min(TA.Finished) as StartFinish
--FROM         dbo.DocumentProductDefinitionTaskItem AS DPDTI LEFT OUTER JOIN
--                          (select TaskItemId, Finished from Activity 
--where IsDone = '1' and IsRefused='0') AS TA ON TA.TaskItemId = DPDTI.TaskItemId
--WHERE     (DPDTI.Deleted IS NULL)
--group by DPDTI.DocumentId
--) as DSD on dsd.DocumentId = d.id
--left join
--(
--SELECT DISTINCT DPDTI.DocumentId , max(TA.Finished) as StartFinish
--FROM         dbo.DocumentProductDefinitionTaskItem AS DPDTI LEFT OUTER JOIN
--                          (select TaskItemId, Finished from Activity 
--where IsDone = '1' and IsRefused='0') AS TA ON TA.TaskItemId = DPDTI.TaskItemId
--WHERE     (DPDTI.Deleted IS NULL)
--group by DPDTI.DocumentId
--) as DSD on dsd.DocumentId = d.id
WHERE D.Id = @Id