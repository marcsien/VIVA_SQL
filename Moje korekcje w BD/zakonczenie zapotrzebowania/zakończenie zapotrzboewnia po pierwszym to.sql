use Synaptic

declare	@RequestId  uniqueidentifier = 'DEF5AF0A-7162-458D-9A17-3A0749500DAA'
declare	@Output VARCHAR(100) 

DECLARE @RequestZakonczonyId Uniqueidentifier
DECLARE @RequestItemsZakonczonyId Uniqueidentifier



IF @RequestId IN (Select ri.RequestId 
					from RequestItems RI
						left join RequestItemProductionOrderItem RIPOI on RIPOI.RequestItemId = RI.id
						left join ProductionOrderItems POI on POI.id = RIPOI.ProductionOrderItemId
						left join ProductionOrderItemsStatus POIS on POIS.id = POI.ProductionOrderItemsStatusId
						left join RequestItemsDocumentProductDefinition RIDPD on RIDPD.RequestItemId = RI.id
						left join DocumentProductDefinition DPD on DPD.id = RIDPD.DocumentProductDefinitionId
						left join Document D on D.id = DPD.DocumentId
						left join DocumentStatus DS on DS.id = D.DocumentStatusId
					where RI.Deleted is null
						and RI.RequestId =@RequestId
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
					)
BEGIN
set @Output = 'Istniej¹ niezakoñczone zadania' 
END

ELSE

BEGIN

set @requestZakonczonyId = (select top 1 id from RequestStatus where name='Zakoñczone')
set @requestItemsZakonczonyId = (select Top 1 id from RequestItemsStatus where name='Zakoñczone')

/*aktualizuje bazê request items w pozycjach gdzie status jest niezrealizowany*/
		update RequestItems
			set RequestItemsStatusId = @requestItemsZakonczonyId
			, Realizated='1'
		where RequestId = @RequestId 
			and RequestItemsStatusId in ( select id 
											from RequestItemsStatus 
											where OrderNumber < 40 )

/*aktualizuje bazê request  w pozycji gdzie status jest niezrealizowany*/
		update Request
			set RequestStatusId = @requestZakonczonyId 
			, Realizated= GETDATE()
		where Id = @RequestId 
			and RequestStatusId in ( select id 
											from RequestStatus 
											where OrderNumber < 40 )
 
set @Output = 'Zakoñczono zlecenie.'
END



select @Output 