use Synaptic

select * from Document d where d.DocumentNumber = 'PZ0053/08/2020'

/*
update Document
set CompanySupplierId = '15EBC8DF-5FDE-4F44-A236-C1370D9E757D'
where Id = '6BACDA6F-8FAB-4F89-9F6D-32CC607E3009'
*/


select * from Company c where c.Name like '%BOREALIS%' -- 15EBC8DF-5FDE-4F44-A236-C1370D9E757D
--c.Id = '07A9D4FD-4349-4067-A8F1-EBFDE4EC799C' 