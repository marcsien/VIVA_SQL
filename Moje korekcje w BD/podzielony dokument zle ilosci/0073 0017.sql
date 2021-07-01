use Synaptic

select * from DocumentProductDefinition dpd where dpd.DocumentId = (select d.Id from Document d where d.DocumentNumber = 'pwtsur0073/07/2019')
select * from DocumentProductDefinition dpd where dpd.DocumentId = (select d.Id from Document d where d.DocumentNumber = 'pwtsur0017/02/2020')

/*
update DocumentProductDefinition
set FinishCount = 0 -- bylo 20040
where Id = '067A928D-3558-4C18-9043-617C3FEACB1E'
*/
/*
update DocumentProductDefinition
set FinishCount = 20040
where Id = '506804B3-BBEE-4547-92EE-14173073755A'
*/