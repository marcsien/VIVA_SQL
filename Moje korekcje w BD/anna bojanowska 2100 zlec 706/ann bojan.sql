use Synaptic

select * from Document d where d.DocumentNumber like '%mmt0026/05/2020%'

select * from DocumentProductDefinition dpd where dpd.DocumentId = '61677C49-01F7-4FDB-A102-559299D2A2E9'


select * from Document d 
inner join DocumentProductDefinition dpd on dpd.DocumentId =d.Id 
where dpd.ProductDefinitionId = '882F5418-D7F4-4FE2-A524-2F874863B57E'
and dpd.ProductBatchId = 'C2DBBB16-70F3-4656-AFAD-6E04BDBA04D8'