use Synaptic

select * from Document d where d.DocumentNumber = 'MMWT0003/02/2020'

select * from Document d where d.DocumentNumber = 'MMWT0019/01/2020'

select * from Document d where d.Id ='218BCB0B-CBF7-4F36-903C-C24309A10D3B'

/*
update Document 
set DocumentNumber = 'MMWT0019/01/2020',
DocumentPreNumber = 'PreMMWT0019/01/2020',
Accepted = '2020-01-31 11:17:00.210',
Realizated = '2020-01-31 11:17:00.210',
RealizationDate = '2020-01-31 11:17:00.210',
DeadlineDate = '2020-01-31 11:17:00.210'
where Id = '888E72E2-9482-4AC1-A8BA-E760AF799E8D'
*/
/*
update Document 
set Created = '2020-01-31 11:17:00.210'
where Id = '888E72E2-9482-4AC1-A8BA-E760AF799E8D'
*/
/*
update Document 
set DocumentNumber = 'MMWT0004/02/2020'
where Id = '218BCB0B-CBF7-4F36-903C-C24309A10D3B'
*/
/*
update Document 
set DocumentNumber = 'MMWT0003/02/2020',
	DocumentPreNumber = 'PreMMWT0003/02/2020'
where Id = '218BCB0B-CBF7-4F36-903C-C24309A10D3B'
*/