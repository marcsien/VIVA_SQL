use synaptic 


select * from Document d where d.Id = '58BC9178-C4C7-4765-B95D-867E96F403DF'

/*
update Document
set RealizationDate = '2020-07-07 11:00:26.843',
DeadlineDate = '2020-07-07 11:00:26.843',
Accepted = '2020-07-07 11:00:26.843',
DocumentNumber = 'WZ0041/07/2020',
DocumentPreNumber = 'PreWZ0045/07/2020'
where Id = '58BC9178-C4C7-4765-B95D-867E96F403DF'
*/

select d.DocumentPreNumber from Document d where d.DocumentSeriesId = '21A77945-EDF5-4E76-A5D6-461E9CF50291' and 
							   d.DocumentPreNumber like 'PreWZ%' and 
							   d.DocumentPreNumber like '%/07/2020' 
order by d.DocumentPreNumber desc

select d.DocumentNumber from Document d where d.DocumentSeriesId = '21A77945-EDF5-4E76-A5D6-461E9CF50291' and 
							   d.DocumentNumber like 'WZ%' and 
							   d.DocumentNumber like '%/07/2020' 
order by d.DocumentNumber desc