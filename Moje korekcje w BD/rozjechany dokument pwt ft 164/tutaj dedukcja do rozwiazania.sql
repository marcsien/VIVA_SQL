use Synaptic



select d.TaskNames from Document d where d.DocumentNumber = 'pwt0071/10/2020' --cz1
select d.TaskNames from Document d where d.DocumentNumber = 'pwt0081/10/2020' --cz2
select d.TaskNames from Document d where d.DocumentNumber = 'pwt0090/10/2020' --cz3

select * from Document d where d.DocumentNumber = 'pwt0071/10/2020' --cz1
select * from Document d where d.DocumentNumber = 'pwt0081/10/2020' --cz2
select * from Document d where d.DocumentNumber = 'pwt0090/10/2020' --cz3

select * from Task t where t.Id = 'D414C84B-5A18-4426-9806-3D8B572BF698' --task ktory daje poprawna ilosc 107096

select * from TaskItems ti where ti.TaskId = 'D414C84B-5A18-4426-9806-3D8B572BF698' --taskitems ktore daja poprawna ilosc 107096

--teraz rozgryü jak to podzielic na dwa doku 

select * from TaskItemLogicalProduct tilp where tilp.TaskItemId in ('A8940875-52B0-4FCE-B42D-0285AF1ADC50','1B23FDB7-FD31-488E-B62D-5243892A9A3C') --z tej tabeli sπ zliczane na doku pwt , jest tu 107096 , rozdziel polaczeniami na dwa doku
order by tilp.Created
--tabela ktora laczy tilp z dpd to dpdti



--rozwiazanie : ustaw sobie tilp w order by po dacie i sprawdz daty dokumentow dla poszczegolnych etapow miedzy created a realizated w dokumencie. 
--potem sprawdz tilp do jakiego taskitema powinno wejsc zgodnie z tymi datami

/*
update TaskItemLogicalProduct
set TaskItemId = '1B23FDB7-FD31-488E-B62D-5243892A9A3C' -- bylo 'A8940875-52B0-4FCE-B42D-0285AF1ADC50'
where Id in ('D4D830EF-F173-46FA-B519-49A74E5626E0','BE9F389F-6015-4E11-AE39-B7B7655B0539','D57031A1-239B-463F-8F86-64BB21CEB089')
*/


select * from DocumentProductDefinitionTaskItem dpdti where dpdti.TaskItemId in ('A8940875-52B0-4FCE-B42D-0285AF1ADC50','1B23FDB7-FD31-488E-B62D-5243892A9A3C')