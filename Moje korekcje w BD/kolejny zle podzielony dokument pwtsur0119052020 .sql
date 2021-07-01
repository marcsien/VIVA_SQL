use Synaptic


select * from Document d where d.DocumentNumber = 'pwtsur0119/05/2020'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'FA0A7994-766E-480A-B9EC-36FC8B386381'


select * from DocumentProductDefinitionTaskItem dpdti where dpdti.DocumentId = 'FA0A7994-766E-480A-B9EC-36FC8B386381'

/*
update DocumentProductDefinitionTaskItem
set CountSettled = 204120
where Id = 'B566FE84-3678-4EC7-9C63-0EE6DE964AF8'
*/