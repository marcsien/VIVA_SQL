use Synaptic 

declare @id as uniqueidentifier = '23548658-F6ED-4596-A1DC-41E4749B4593'

select * from Document d where d.Id = @id
select * from DocumentProductDefinition dpd where dpd.DocumentId = (select d.Id from Document d where d.Id = @id)
select * from DocumentSeries ds where ds.Id = (select d.DocumentSeriesId from Document d where d.Id = @id)
