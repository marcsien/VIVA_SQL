use synaptic



select * from Document d where d.DocumentNumber = 'rwtsur0089/02/2021'

select * from DocumentProductDefinition dpd where dpd.DocumentId = '198118A3-BA3D-472E-90B2-908458B55F18'


/*
update DocumentProductDefinition
set ProductBatchId = '7C89FD97-386B-4E71-B7AA-065FD2E7EFAD' -- bylo null 
where Id = 'BB048C46-9D11-4DA3-A8F9-231A9801730C'
*/