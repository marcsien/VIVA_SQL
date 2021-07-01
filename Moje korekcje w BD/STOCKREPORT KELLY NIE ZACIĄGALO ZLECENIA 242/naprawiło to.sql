use Synaptic

select sum(poi.finishcount) as Proceed, poi.ProductBatchId, poi.ProductDefinitionId, RIPOI.RequestItemId
			from
			 dbo.ProductionOrderItems POI (NOLOCK)
			left join dbo.RequestItemProductionOrderItem RIPOI (NOLOCK) ON RIPOI.ProductionOrderItemId = POI.Id
			where POI.Deleted is null and RIPOI.RequestItemId = '1DDF12DC-B250-4096-8BBB-40E170AE4961'


			group by poi.ProductBatchId, poi.ProductDefinitionId,RIPOI.RequestItemId
			
			--as prepoi on prepoi.RequestItemId = ri.id
			--select * from ProductionOrderItems

			------------------------------------------------------------------------------------old--------------------------------------------test
			select * from RequestItemProductionOrderItem huj where huj.RequestItemId = '64E95261-CBB1-45BE-A5D5-1E7A4828A831' --02B4342C-F145-4BD7-8AD6-A97F977A69C9
			select * from RequestItemProductionOrderItem huj where huj.RequestItemId = '1A58B4F2-C5D7-4E3B-A727-7063BC0835AE' --08E14DCE-1522-4E01-BBD3-F7BFE0C1AF06
			select * from RequestItemProductionOrderItem huj where huj.RequestItemId = 'C27508B2-BB9F-4F2C-BCDD-FEBE2D10F844' --1DDF12DC-B250-4096-8BBB-40E170AE4961

			--update RequestItemProductionOrderItem set RequestItemProductionOrderItem.RequestItemId = '02B4342C-F145-4BD7-8AD6-A97F977A69C9' where RequestItemProductionOrderItem.Id = '7308F7DB-6B24-43F0-B464-04C37414D234'
			--update RequestItemProductionOrderItem set RequestItemProductionOrderItem.RequestItemId = '08E14DCE-1522-4E01-BBD3-F7BFE0C1AF06' where RequestItemProductionOrderItem.Id = '14DFC402-BFDD-45C1-AF8E-671BF4C4CBA9'
			--update RequestItemProductionOrderItem set RequestItemProductionOrderItem.RequestItemId = '1DDF12DC-B250-4096-8BBB-40E170AE4961' where RequestItemProductionOrderItem.Id = 'DDD8FAD6-C606-4BA0-86AF-5449A3144275'