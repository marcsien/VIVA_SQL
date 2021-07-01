use Synaptic

--do zmiany
select  * from LogicalProduct lp where lp.BarCode in ('1001215561','1001215573')

--examplowe
select  * from LogicalProduct lp where lp.BarCode in ('1001213824')


/*
--zmieniê  productdefinitionid
update LogicalProduct 
set ProductDefinitionId = '7C7F9985-3FB2-4D38-9482-E5740A37DC8D' -- bylo E6A5071D-5C04-420B-B32D-EE486B6D2D95
where Id = '73FBAADD-BD65-40F4-AE74-380F187ACAE7'

update LogicalProduct 
set ProductDefinitionId = '7C7F9985-3FB2-4D38-9482-E5740A37DC8D' -- bylo E6A5071D-5C04-420B-B32D-EE486B6D2D95
where Id = '8DADCC22-03CD-4673-9F33-545605A9FF46'
*/


--nie znajdowa³o ich w tworzeniu WZ wiec zmiana partii bez dokumentu na jak¹œ 
/*
update LogicalProduct 
set ProductBatchId = 'FE5751F1-A0D1-4B6A-9F54-39B7290AC6AF' -- bylo 93015DE2-D9D5-47A9-8084-4CE0160C75A3
where Id = '73FBAADD-BD65-40F4-AE74-380F187ACAE7'

update LogicalProduct 
set ProductBatchId = 'FE5751F1-A0D1-4B6A-9F54-39B7290AC6AF' -- bylo 93015DE2-D9D5-47A9-8084-4CE0160C75A3
where Id = '8DADCC22-03CD-4673-9F33-545605A9FF46'
*/