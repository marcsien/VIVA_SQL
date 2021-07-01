use Synaptic

/*

select * from Document d where d.Id = 'F1D3F18E-75A3-4C15-95AC-8880E34EE6B1'
union all
select * from Document d where d.DocumentPreNumber = 'PrePWTSUR0016/07/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'F1D3F18E-75A3-4C15-95AC-8880E34EE6B1'
union all
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'BEE6CAFB-F4A7-411D-B1F7-192E974BAC97'

select * from Document d where d.DocumentPreNumber like '%/06/2020' and d.DocumentPreNumber like 'PrePWT%' order by d.DocumentPreNumber desc
select * from Document d where d.DocumentNumber like '%/06/2020' and d.DocumentNumber like 'PWT%' order by d.DocumentNumber desc

*/

/*
update Document
set DocumentPreNumber = 'PrePWTSUR0111/06/2020', --PreKRWT0006/06/2020
DocumentNumber = 'PWTSUR0111/06/2020', --KRWT0001/06/2020
DocumentSeriesId = '69554553-1670-40F9-9998-B88FB4B491FB', --4BD97C1F-94CE-45BE-B383-CD94575FF304
DocumentSeriesNumberPatternId = 'D96A6D1D-C538-4B3E-A564-0A78FCDE0886' --BDB02648-85A2-4356-9D72-C85CE44F3E10
where Id = 'F1D3F18E-75A3-4C15-95AC-8880E34EE6B1'
*/


--select * from Document d where d.DocumentPreNumber like '%/2020' and d.DocumentPreNumber like 'PreKRWT%' order by d.DocumentPreNumber desc

/*
update Document
set DocumentPreNumber = 'PreKRWT0006/06/2020' --PreKRWT0007/06/2020
where Id = '896CF412-EC98-409A-83F5-1BCADE42C907'
*/


select * from Document d where d.DocumentNumber like '%/05/2020' and d.DocumentNumber like 'KRWT%' order by d.DocumentNumber desc

/*
update Document
set DocumentNumber = 'KRWT0001/06/2020' --PreKRWT0007/06/2020
where Id = '896CF412-EC98-409A-83F5-1BCADE42C907'
*/