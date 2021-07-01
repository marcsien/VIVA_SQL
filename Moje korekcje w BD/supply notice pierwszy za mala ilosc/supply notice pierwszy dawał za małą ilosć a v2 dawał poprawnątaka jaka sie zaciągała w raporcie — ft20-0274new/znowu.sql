use Synaptic

use Synaptic
--select * from Document d where d.DocumentNumber = 'PWT0067/11/2019'


declare @Id uniqueidentifier
set @Id = '14650F25-6A38-4965-B38C-67B38B2CB489' 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 28512 where DocumentProductDefinition.Id = '12FAB0DC-9B7F-4182-A59B-31AC6D6A1731' -- oryginalnie by³o 28512
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 19712 where DocumentProductDefinition.Id = 'F7991817-E69E-48E2-8002-4FA6B421DEFA' -- oryginalnie by³o 21120
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 1408 where DocumentProductDefinition.Id = '5DFFA9E4-1A38-49ED-B3EF-D44AD67D484D' -- oryginalnie by³o 4224
