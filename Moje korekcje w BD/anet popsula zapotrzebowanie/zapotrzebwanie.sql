use SynapticTest 


select * from Request r where r.Number = @requestnumber
select * from RequestItems ri where ri.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB'
select * from RequestAdditionalData rad where rad.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB'
select * from RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from RequestItems ri where ri.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB')




use Synaptic
declare @requestnumber nvarchar(10) = 'Z4043/2020'


select * from Request r where r.Number = @requestnumber
select * from RequestItems ri where ri.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB'
select * from RequestAdditionalData rad where rad.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB'
select * from RequestItemProductionOrderItem ripd where ripd.RequestItemId in (select ri.Id from RequestItems ri where ri.RequestId = 'BE74FB60-E7FB-40C0-83F1-65DD4ABFF9EB')



