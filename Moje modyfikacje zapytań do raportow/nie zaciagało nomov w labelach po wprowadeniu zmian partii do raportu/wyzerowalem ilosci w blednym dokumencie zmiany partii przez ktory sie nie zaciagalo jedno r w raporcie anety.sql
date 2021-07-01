use Synaptic

select * from Document d where d.Id = 'C7F745AB-673F-4791-8599-D7ECD14CCFEA'


select * from DocumentProductDefinition dpd where dpd.DocumentId = (select d.Id from Document d where d.Id = 'C7F745AB-673F-4791-8599-D7ECD14CCFEA')

/*
update DocumentProductDefinition
set OriginCount = 0 --800
where Id = '0A2C0C9E-804F-4EE3-B5CB-6466BB25D1F2'

update DocumentProductDefinition
set OriginCount = 0 --1506
where Id = '3E7ED3BA-570A-4B30-B13A-8DB7B0FDB805'
*/