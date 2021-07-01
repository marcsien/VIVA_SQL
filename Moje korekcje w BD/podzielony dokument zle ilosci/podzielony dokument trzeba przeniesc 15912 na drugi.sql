use Synaptic

select * from Document d where d.DocumentNumber ='PWT0048/12/2019' -- z tego na drugi mam przeniesc 15912 pozycje

select * from DocumentProductDefinition dpd where dpd.DocumentId = '7A0B41FA-96B1-43E7-8F9A-A3A4C86CFE64'

select * from Document d where d.DocumentNumber ='PWT0015/01/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'CB09179D-4BD4-4B96-975D-07B93A0A5A14'

--zamiast przenosic dpd po documentid postanowilem zmienic ilosci:

/*
update DocumentProductDefinition 
set FinishCount = 0 -- bylo 15912
where Id = 'BE701FBA-C980-4F48-991B-D9410579A150'

update DocumentProductDefinition 
set FinishCount = 15912 -- bylo 0
where Id = 'E7A46362-DAB9-4B16-AED8-0FB041151124'
*/