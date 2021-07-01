use Synaptic

select poi.finishcount as Proceed, poi.ProductBatchId, poi.ProductDefinitionId, RIPOI.RequestItemId
			from
			 dbo.ProductionOrderItems POI (NOLOCK)
			left join dbo.RequestItemProductionOrderItem RIPOI (NOLOCK) ON RIPOI.ProductionOrderItemId = POI.Id
			where POI.Deleted is null and RIPOI.RequestItemId = '64E95261-CBB1-45BE-A5D5-1E7A4828A831'