use Synaptic



declare @Id uniqueidentifier
set @Id = (select d.Id from Document d where d.DocumentNumber = 'PWT0009/12/2019') 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 14000 where DocumentProductDefinition.Id = '464841A8-357F-469C-98F1-4C63EE3B7BC2' -- oryginalnie by³o 8540
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 140 where DocumentProductDefinition.Id = '94A0DB2A-C55A-4739-9896-F815A60FF86B' -- oryginalnie by³o 2660
