use Synaptic
--select * from Document d where d.DocumentNumber = 'PWT0067/11/2019'


declare @Id uniqueidentifier
set @Id = '14650F25-6A38-4965-B38C-67B38B2CB489' 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 21120 where DocumentProductDefinition.Id = 'F7991817-E69E-48E2-8002-4FA6B421DEFA' -- oryginalnie by³o 16896