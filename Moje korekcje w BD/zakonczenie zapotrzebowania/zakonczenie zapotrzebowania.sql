use Synaptic


declare	@RequestId  uniqueidentifier = 'DEF5AF0A-7162-458D-9A17-3A0749500DAA'
declare	@Output VARCHAR(100) 

DECLARE @RequestZakonczonyId Uniqueidentifier
DECLARE @RequestItemsZakonczonyId Uniqueidentifier

select * from Request r where r.Number = 'WT3986/2020' or r.Number = 'Z3940/2020' -- stad id do requestid

Select POI.*
					from RequestItems RI
						left join RequestItemProductionOrderItem RIPOI on RIPOI.RequestItemId = RI.id
						left join ProductionOrderItems POI on POI.id = RIPOI.ProductionOrderItemId
						left join ProductionOrderItemsStatus POIS on POIS.id = POI.ProductionOrderItemsStatusId
						left join RequestItemsDocumentProductDefinition RIDPD on RIDPD.RequestItemId = RI.id
						left join DocumentProductDefinition DPD on DPD.id = RIDPD.DocumentProductDefinitionId
						left join Document D on D.id = DPD.DocumentId
						left join DocumentStatus DS on DS.id = D.DocumentStatusId
					where RI.Deleted is null
						and RI.RequestId = @RequestId
						and ((POI.ExecutionEnd is null
								and RIPOI.Deleted is null
								and POI.Deleted is null
								and POIS.OrderNumber < 60
								)  
							or ( RIDPD.Deleted is null 
								and DPD.Deleted is null
								and D.Deleted is null
								and D.Realizated is null
								and DS.OrderNumber < 50
								)
							)
					

--					select * from ProductionOrderItemsStatus --pois where pois.Id = 'B7613166-9BD3-4898-8086-7742C437DD5C'
					--'B6658D25-382D-4415-AC9A-8F55EE2DE97F'

--select * from ProductionOrderItems poi where poi.Id = '66BD05BB-1A16-4AEE-8B60-26A320ADC4A7' 


/*
update ProductionOrderItems 
set ProductionOrderItemsStatusId = '66BD05BB-1A16-4AEE-8B60-26A320ADC4A7', -- bylo 'B7613166-9BD3-4898-8086-7742C437DD5C'
ExecutionStart = '2020-09-30 19:15:34.000', -- bylo null
ExecutionEnd = '2020-09-30 21:39:57.000' -- bylo null
where Id = '66BD05BB-1A16-4AEE-8B60-26A320ADC4A7'
*/

/*
update ProductionOrderItems 
set ProductionOrderItemsStatusId = '66BD05BB-1A16-4AEE-8B60-26A320ADC4A7', -- bylo 'B7613166-9BD3-4898-8086-7742C437DD5C'
ExecutionStart = '2020-10-01 14:18:49.000', -- bylo null
ExecutionEnd = '2020-10-01 16:21:23.000' -- bylo null
where Id = '471AA734-4908-4069-BC18-A6A75C3DCB54'
*/