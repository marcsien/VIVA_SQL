use Synaptic

select * from Document d where d.DocumentNumber like '%pwtsur0135/01/2020%' -- tutaj zabieram
select * from DocumentProductDefinition dpd where dpd.DocumentId = '5E1F88C4-91FC-4935-9CD0-93D70AB3A2AA'
select * from Document d where d.DocumentNumber like '%pwtsur0038/02/2020%' -- tutaj dok³adam
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'CD915CF3-5659-4C3A-8182-2BCE9C1F4A9E'


update DocumentProductDefinition
set DocumentId = 'CD915CF3-5659-4C3A-8182-2BCE9C1F4A9E'
where Id = '856C8CE0-6AE9-42CE-9302-ED3A0A874F10' 
