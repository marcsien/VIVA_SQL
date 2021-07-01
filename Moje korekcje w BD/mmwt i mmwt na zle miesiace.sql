use Synaptic 


select * from Document d where d.Id ='0D8A5392-E842-4863-95F1-D9E647CD8E62'--d.DocumentNumber = 'MMWM0011/04/2020'--'mmwt0001/05/2020' --0D8A5392-E842-4863-95F1-D9E647CD8E62
select * from DocumentProductDefinition dpd where dpd.DocumentId = '0D8A5392-E842-4863-95F1-D9E647CD8E62'


/*
update Document
set DocumentNumber = 'MMWT0001/04/2020',
DocumentPreNumber ='PreMMWT0001/04/2020',
Created = '2020-04-29 13:55:31.587',
Accepted = '2020-04-29 13:55:31.587',
Realizated = '2020-04-29 13:55:31.587',
RealizationDate = '2020-04-29 13:55:31.587',
DeadlineDate ='2020-04-29 13:55:31.587'
where Id='0D8A5392-E842-4863-95F1-D9E647CD8E62'
*/
/*
update DocumentProductDefinition 
set Created ='2020-04-29 13:59:03.433',
Realizated = '2020-04-29 14:00:52.497'
where Id = 'A13C3628-09FC-4EC4-8726-92F6F8049D4C'
*/

/*
update Document
set DocumentNumber = 'MMWM0001/04/2020',
DocumentPreNumber ='PreMMWM0001/04/2020',
Created = '2020-04-29 13:55:31.587',
Accepted = '2020-04-29 13:55:31.587',
Realizated = '2020-04-29 13:55:31.587',
RealizationDate = '2020-04-29 13:55:31.587',
DeadlineDate ='2020-04-29 13:55:31.587'
where Id='F4B64EFA-EF59-4395-BBAD-76E245D01319'
*/

/*
update DocumentProductDefinition 
set Created ='2020-04-29 13:59:03.433',
Realizated = '2020-04-29 14:00:52.497'
where Id = 'AF364874-A350-4384-BF10-3730AA30F471'
*/



select * from Document d where d.DocumentNumber = 'mmwm0001/04/2020'
--select * from DocumentProductDefinition dpd where dpd.DocumentId = 'F4B64EFA-EF59-4395-BBAD-76E245D01319'
union
select * from Document d where d.Id = 'F4B64EFA-EF59-4395-BBAD-76E245D01319'


select * from DocumentSeries ds where ds.Id= '43038FA3-9A67-4D77-9AC2-939B6725D506' or ds.Id = 'A25F4BBA-0088-4DFD-A87D-6B895E3C1B77'
