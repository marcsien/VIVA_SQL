use Synaptic

select * from Document d where d.DocumentPreNumber = 'prerwtsur0525/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'B7C21CAE-8B55-4642-A27E-2BBCA7B0D208'

select * from Document d where d.DocumentPreNumber = 'prerwtsur1164/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'FDEF29FF-B512-4A7C-A918-FD2D2AE883DF'


/*
update DocumentProductDefinition 
set DocumentId = 'FDEF29FF-B512-4A7C-A918-FD2D2AE883DF', --bylo B7C21CAE-8B55-4642-A27E-2BBCA7B0D208
OriginCount = 0 -- bylo 300
where Id = '6FDB2C13-8B4C-4206-B931-F06907F3A30A'
*/