use Synaptic

declare @Id uniqueidentifier
set @Id = '3ACDAA73-B3F1-43D8-A3BB-69A9CA7A8CDF' 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 23940 where DocumentProductDefinition.Id = 'C5C2C488-3344-459F-8DB4-9879190BFAB3' -- oryginalnie by³o 22960