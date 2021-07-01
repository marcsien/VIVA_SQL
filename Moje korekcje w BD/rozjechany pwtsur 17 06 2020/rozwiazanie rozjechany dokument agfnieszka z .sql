use Synaptic


select * from Document d where d.DocumentNumber = 'pwt0027/06/2020' 

select * from DocumentProductDefinition dpd where dpd.DocumentId = '097FE454-0FE0-41A0-893D-9CD73AD3002F'

select * from TaskItemLogicalProduct tilp  where tilp.Count = 1056 and tilp.OriginCount = 880

select * from TaskItems ti

select * from Task t where t.Name = 'PrePWT0015/06/2020'


/*
update DocumentProductDefinition 
set FinishCount = 108768
where Id = '8504CA71-C85B-4363-B144-5B26D0B557DF'
*/

/*
update DocumentProductDefinitionTaskItem
set CountSettled = 108768
where Id = '3EC0EC90-0536-4AFC-948E-5C5C02E6601B'
*/

--jeszcze task item logical product

/*
update TaskItemLogicalProduct
set TaskItemId = '83718EEE-DF0E-4D42-8FCB-921F1F866399' -- bylo C19E7AE5-9CAD-419E-949F-72414017EAEB
where Id = '7D48070E-E2F7-4E7E-92FB-6621CC7DC4E9'
*/