use Synaptic


select * from ProductionMaterials pm where pm.Id = 'E40B1F11-7B57-4E1A-BC36-EB3F5D2CBBAC'
union all
select * from ProductionMaterials pm where pm.Id = '2C6EECDF-6C82-494A-B890-A741590E9A99'

--select * from ProductionMaterials pm where pm.ManufacturingPositionSchedulerId is null and pm.Created > '2019-11-03 14:07:05.627'

/*
update ProductionMaterials 
set Deleted =  null --(select GETDATE()) --bylonull
where Id = '2C6EECDF-6C82-494A-B890-A741590E9A99'
*/

select * from ManufacturingPositionScheduler mps where mps.Id = 'B060CEC9-7489-4D42-97B3-51D2AE7FE1CF'
select * from ManufacturingPositionScheduler mps where mps.Name = 'ZPC0256/2020 T385R_1350_080_SC_WT1_BV4+5000'

select * from LogicalProduct lp where lp.BarCode = '0001932380'

select * from DocumentProductDefinition dpd where dpd.DocumentId = (select d.Id from Document d where d.DocumentNumber like '%mmt0010/05/2020%')