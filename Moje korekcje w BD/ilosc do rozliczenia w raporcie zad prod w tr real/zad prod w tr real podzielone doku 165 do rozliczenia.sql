use Synaptic

-- ft 465 do rozliczenia pokazywa³o 165 od razu po rozliczeniu 

select * from DocumentProductDefinitionTaskItem dpdti where dpdti.Id ='77B970B6-3464-417E-8035-6613D4969EA6'


select * 
	from DocumentProductDefinition dpd1
	inner join DocumentTask DT (NOLOCK) on DT.DocumentId = dpd1.DocumentId
	inner join ProductBatch pb (NOLOCK) on pb.id = dpd1.ProductBatchId
	inner join DocumentProductDefinitionTaskItem dpdti on dpdti.DocumentProductDefinitionId = dpd1.Id
  where dt.TaskId = '77B970B6-3464-417E-8035-6613D4969EA6'


/*
update DocumentProductDefinitionTaskItem
set DocumentProductDefinitionTaskItem.CountSettled = 88275 --88110 bylo
where DocumentProductDefinitionTaskItem.Id = '03A50599-7952-4024-975B-01D7C1D6C33C'
*/