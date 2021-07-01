declare @requestnumber nvarchar(10) = 'Z4043/2020'


begin transaction 



--select * from Synaptic..Request r where r.Number = @requestnumber
--union all
--select * from SynapticTest..Request r where r.Number = @requestnumber

update Synaptic..Request
set Synaptic..Request.Created = (select r.Created from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.Deleted = (select r.Deleted from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.RequestSeriesId = (select r.RequestSeriesId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.Number = (select r.Number from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.PersonId = (select r.PersonId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.AcceptanceDate = (select r.AcceptanceDate from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.Realizated = (select r.Realizated from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.Description = (select r.Description from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.CompanyId = (select r.CompanyId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.StructureClassifierId = (select r.StructureClassifierId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.CompanyDepartmentId = (select r.CompanyDepartmentId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.ExternalSystemId = (select r.ExternalSystemId from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.Deadline = (select r.Deadline from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.RealizationDate = (select r.RealizationDate from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.DeadlineAnchor = (select r.DeadlineAnchor from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.RealizationDateAnchor = (select r.RealizationDateAnchor from SynapticTest..Request r where r.Number = @requestnumber),
Synaptic..Request.RequestStatusId = (select r.RequestStatusId from SynapticTest..Request r where r.Number = @requestnumber)
where Id = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)

select * from Synaptic..Request r where r.Number = @requestnumber
union all
select * from SynapticTest..Request r where r.Number = @requestnumber


--rollback transaction


/*
begin transaction
select * from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)
union all
select * from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber)
*/

update Synaptic..RequestItems
set Synaptic..RequestItems.Created = (select ri.Created from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.Deleted = (select ri.Deleted from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.OrderNumber = (select ri.OrderNumber from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.ProductDefinitionId = (select ri.ProductDefinitionId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.MeasureUnitLogicalId = (select ri.MeasureUnitLogicalId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.Count = (select ri.Count from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.InCount = (select ri.InCount from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.OutCount = (select ri.OutCount from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.Realizated = (select ri.Realizated from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.Description = (select ri.Description from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.ProductBatchId = (select ri.ProductBatchId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.FormulaId = (select ri.FormulaId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.ExternalSystemId = (select ri.ExternalSystemId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.BoxDefinitionId = (select ri.BoxDefinitionId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.BoxCount = (select ri.BoxCount from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)),
Synaptic..RequestItems.RequestItemsStatusId = (select ri.RequestItemsStatusId from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber))
where Id = (select ri.Id from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber))

select * from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)
union all
select * from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber)

/*
rollback transaction 
*/

/*
begin transaction
select * from Synaptic..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber))
union all
select * from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))
*/

update Synaptic..RequestItemProductionOrderItem
set Synaptic..RequestitemProductionOrderItem.Created = (select ripd.Created from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.Deleted = (select ripd.Deleted from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.RequestItemId = (select ripd.RequestItemId from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.ProductionOrderItemId = (select ripd.ProductionOrderItemId from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.Count = (select ripd.Count from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.RealizatedCount = (select ripd.RealizatedCount from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))),
Synaptic..RequestitemProductionOrderItem.ProductionMaterialId = (select ripd.ProductionMaterialId from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber)))
where Id = (select ripd.Id from Synaptic..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber)))


select * from Synaptic..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from Synaptic..RequestItems ri where ri.RequestId = (select r.Id from Synaptic..Request r where r.Number = @requestnumber))
union all
select * from SynapticTest..RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from SynapticTest..RequestItems ri where ri.RequestId = (select r.Id from SynapticTest..Request r where r.Number = @requestnumber))



rollback transaction 