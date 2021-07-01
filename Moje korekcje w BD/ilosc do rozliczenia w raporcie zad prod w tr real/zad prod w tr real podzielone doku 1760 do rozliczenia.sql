use Synaptic

-- ft 344 do rozliczenia pokazywa³o 1760 od razu po rozliczeniu 

select * from DocumentProductDefinitionTaskItem dpdti where dpdti.Id ='78F805B0-04FA-466E-B754-4DBB61E3E7BD'


/*
update DocumentProductDefinitionTaskItem
set DocumentProductDefinitionTaskItem.CountSettled = 32824 --31064 bylo
where DocumentProductDefinitionTaskItem.Id = '78F805B0-04FA-466E-B754-4DBB61E3E7BD'
*/