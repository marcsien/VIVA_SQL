use Synaptic


select * from Document d where d.Id = 'CCB9556A-01ED-4D52-930E-591B79B79C69'

select * from Document d where d.DocumentNumber like 'WZTU%' and  d.DocumentNumber like '%/02/2021' order by d.documentnumber desc
select * from Document d where d.DocumentPreNumber like 'PreWZTU%' and  d.DocumentPreNumber like '%/02/2021' order by d.DocumentPreNumber desc


/*
update Document
set Created = '2021-02-28 14:48:32.000', -- bylo 2021-03-08 14:53:52.467
Accepted = '2021-02-28 14:48:32.000', -- bylo 2021-03-08 14:53:52.467
Realizated = '2021-02-28 14:48:32.000', -- bylo 2021-03-08 14:54:10.743
DocumentNumber = 'WZTU0002/02/2021', -- bylo WZTU0001/03/2021
DocumentPreNumber = 'PreWZTU0002/02/2021' -- bylo PreWZTU0001/03/2021
where Id = 'CCB9556A-01ED-4D52-930E-591B79B79C69'
*/



select * from Document d where d.DocumentNumber like 'WZTU%' and  d.DocumentNumber like '%/03/2021' order by d.documentnumber desc
select * from Document d where d.DocumentPreNumber like 'PreWZTU%' and  d.DocumentPreNumber like '%/03/2021' order by d.DocumentPreNumber desc

/*
update Document
set DocumentPreNumber = 'PreWZTU0001/03/2021' -- bylo PreWZTU0002/03/2021
where Id = '6A79B410-16FA-46EE-A645-B5BF5213B1ED'
*/