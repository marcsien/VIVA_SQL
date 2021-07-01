use synaptic 
declare @id as uniqueidentifier = '097FE454-0FE0-41A0-893D-9CD73AD3002F'

SELECT PD.Name AS PDName
	,'{NewLine}'+PB.Param2 AS PDAM
	, '{NewLine}'+(select cd.Name+':'+ cl.Name
					from ProductDefinitionLogicalProductAdditionalData acd (nolock)
						inner join Classifier cl (nolock) on cl.id= acd.ClassifierId 
						inner join ClassifierDefinition cd (nolock) on cd.Id = cl.ClassifierDefinitionId
						inner join ProductCategoryAdditionalDataView PCAD (nolock) ON acd.ProductCategoryAdditionalDataId=PCAD.Id
					where  acd.Deleted is null
						and  cl.Deleted is null
						and cd.Deleted is null
						and cd.Name = 'tube Dia'
						AND PCAD.ProductCategoryId=PC.Id 
						AND acd.ProductDefinitionId=PD.ID) AS Capdia
	,'{NewLine}'+ (select PCAD.DataName+': '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'height'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Capheight
	,'{NewLine}'+ (select PCAD.DataName+': ' + ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Color'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Capcolor
	,'{NewLine}'+ (select PCAD.DataName+': '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Orifice'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Caporifice
	,'{NewLine}'+(select cd.name+': ' + cl.Name
					from ProductDefinitionLogicalProductAdditionalData acd (nolock)
						inner join Classifier cl (nolock) on cl.id= acd.ClassifierId 
						inner join ClassifierDefinition cd (nolock) on cd.Id = cl.ClassifierDefinitionId
						inner join ProductCategoryAdditionalDataView PCAD (nolock) ON acd.ProductCategoryAdditionalDataId=PCAD.Id
					where  acd.Deleted is null
						and  cl.Deleted is null
						and cd.Deleted is null
						and cd.Name = 'Thread Type'
						AND PCAD.ProductCategoryId=PC.Id 
						AND acd.ProductDefinitionId=PD.ID) AS Capthreadtype
	,'{NewLine}'+ (select PCAD.DataName+': '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Cap type'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Capcaptype
	,'{NewLine}'+ (select PCAD.DataName+': '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Finish'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID
						AND ACD.ProductDefinitionId = PD.ID) AS Capfinish
	,'{NewLine}'+ (select PCAD.DataName+': '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Print Color'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Printing
	,'{NewLine}'+  (select PCAD.DataName+': ' + ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Code'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Code
	,'{NewLine}'+ (select 'Article: '+ ACD.AdditionalColumnShortString 
					from dbo.ProductDefinitionLogicalProductAdditionalData ACD (nolock)
						Inner join dbo.ProductCategoryAdditionalDataView PCAD (nolock) ON ACD.ProductCategoryAdditionalDataId = PCAD.Id
					where PCAD.IsProductDefinition = 1  
						and PCAD.DataName = 'Nazwa towaru u klienta'
						And ACD.Deleted is null
						And PCAD.ProductCategoryId =  PC.ID 
						AND ACD.ProductDefinitionId = PD.ID) AS Art
	,(Case when PB.Param2 is null then '' else '{NewLine}' +PB.Param2 end ) AS PBParam2
	,(Case when PB.Param3 is null then '' else '{NewLine}' + PB.Param3  end ) AS PBParam3
	,PB.Param1 AS PONumber
	,cast(TDPD.CountSum as int) Count 
	,TDPD.CountPerUnit
	,convert(nvarchar, TDPD.CountUnit) + '{NewLine}' +
	 isnull(case when floor(tdpd.CountPerUnit/BDPD.CountInLayer)=0 then '' else cast(floor(tdpd.CountPerUnit/BDPD.CountInLayer) as nvarchar) +' layers' end +
		(case when bdpd.CountInLayer*floor(tdpd.CountPerUnit/BDPD.CountInLayer) < tdpd.CountPerUnit then 
		case when floor(tdpd.CountPerUnit/BDPD.CountInLayer)=0 then '' else ' + ' end +
		convert(nvarchar,cast((tdpd.CountPerUnit -(bdpd.CountInLayer*floor(tdpd.CountPerUnit/BDPD.CountInLayer)))/muls.Denominator as int)) +
		case when (tdpd.CountPerUnit -(bdpd.CountInLayer*floor(tdpd.CountPerUnit/BDPD.CountInLayer)))/muls.Denominator = 1 then ' tray' else ' trays' end else '' end ),'n/a')
	+'{NewLine}'+
	isnull(convert(nvarchar,cast(tdpd.CountPerUnit  as int)) +' pcs/pal{NewLine}' + convert(nvarchar,cast(tdpd.CountPerUnit /muls.Denominator as int) ) + ' trays','n/a') as PalletCount

	,'' AS Client
	, ISNULL(PB.Name,'') AS Batch
	, cast(TDPDS.CountSum as int) SumCount
	, TDPDS.CountUnit SumPalletCount
FROM (select lp.ProductBatchId
			, lp.ProductDefinitionId
			, sum(TILP.Count) CountSum
			, count(tilp.count) CountUnit
			, TILP.Count CountPerUnit 
		from TaskItemLogicalProduct TILP (nolock) 
			inner join LogicalProduct LP with (nolock) on lp.Id = tilp.LogicalProductId
		WHERE TILP.TaskItemId in (select dpdti.TaskItemId 
									from DocumentProductDefinitionTaskItem dpdti (nolock)
									where dpdti.deleted is null
										and dpdti.DocumentProductDefinitionId in (select Id 
																					from DocumentProductDefinition 
																					where DocumentId=@id))
			and ISNULL(TILP.IsNeglected,0)=0
			and ISNULL(TILP.IsReadyToGenerateDocument,0)=1
			and TILP.Created between (select d.Created from Document D where d.id=@id) and (select d.Realizated from Document D where d.id=@id) 
		group by lp.ProductBatchId, lp.ProductDefinitionId, TILP.Count  ) as TDPD
	cross join  (select sum(TILP.Count) CountSum
						, count(tilp.count) CountUnit 
					from TaskItemLogicalProduct TILP (nolock) 
						inner join LogicalProduct LP with (nolock) on lp.Id = tilp.LogicalProductId
					WHERE TILP.TaskItemId in (select dpdti.TaskItemId 
												from DocumentProductDefinitionTaskItem dpdti (nolock)
												where dpdti.deleted is null
													and dpdti.DocumentProductDefinitionId in (select Id 
																								from DocumentProductDefinition 
																								where DocumentId=@id))
						and ISNULL(TILP.IsNeglected,0)=0
						and ISNULL(TILP.IsReadyToGenerateDocument,0)=1
						and TILP.Created between (select d.Created from Document D where d.id=@id) and (select d.Realizated from Document D where d.id=@id) 
				) TDPDS 
	inner join ProductDefinition PD (nolock) ON PD.Id = TDPD.ProductDefinitionId
	inner join ProductCategory PC (nolock) ON PC.Id = PD.ProductCategoryId
	left join ProductBatch PB (nolock) ON PB.Id = TDPD.ProductBatchId 
	inner join dbo.MeasureUnitLogical MUL (nolock) ON MUL.Id = pd.MeasurmentUnitLogicalId
	left join dbo.BoxDefinitionProductDefinition BDPD (nolock) ON BDPD.ProductDefinitionId = PD.Id and BDPD.IsDefault = '1'
	LEFT JOIN MeasureUnitLogicalScaler muls  (nolock) ON MULS.ProductDefinitionId = BDPD.ProductDefinitionId AND MULS.Deleted IS NULL AND MULS.ResultMeasureUnitLogicalId='AEDB4CF0-07B2-4830-B6BB-D6D3F81CF496'

WHERE PB.Deleted is null
	and BDPD.Deleted is NULL
	and (PC.NAME='Tuby' or PC.NAME='Tuby zintegrowane')
	and TDPD.CountSum>0
