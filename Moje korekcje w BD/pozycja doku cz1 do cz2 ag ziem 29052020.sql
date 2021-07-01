use Synaptic


select * from Document d where d.DocumentNumber = 'pwtsur0103/05/2020'--cz1
select *  from DocumentProductDefinition dpd where dpd.DocumentId = '9B0CBF98-E7D4-4563-B469-DC64F625B104'

select * from Document d where d.DocumentNumber = 'pwtsur0110/05/2020'--cz2
select *  from DocumentProductDefinition dpd where dpd.DocumentId = 'A227DACB-D28B-4923-9368-B0B90C6BCAEE'

/*
update DocumentProductDefinition 
set DocumentId = 'A227DACB-D28B-4923-9368-B0B90C6BCAEE'
where Id = '7C56A824-EA66-47BC-A7E0-06A3EC4B72C6'
*/