use Synaptic

select * from Document d where d.DocumentNumber = 'pwt0030/04/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId = '739352D1-6BCD-417B-ACE7-3FCE40720187'

/*
update DocumentProductDefinition 
set FinishCount = 0 -- bylo 176
where Id = '72936586-698A-493A-A0A0-E6133720440A'
*/
