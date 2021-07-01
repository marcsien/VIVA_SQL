use Synaptic
--select * from Document d where d.DocumentNumber = 'PWT0103/11/2019'


declare @Id uniqueidentifier
set @Id = '7DAC5681-7E22-4049-8AF9-0CBD247165C7' 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 2660 where DocumentProductDefinition.Id = '3869C447-C639-4087-97EC-7E96C8658787' -- oryginalnie by³o 2940
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 8400 where DocumentProductDefinition.Id = 'C5A10BA2-4625-4C72-BD40-A22A24DC71F9' -- oryginalnie by³o 11060


