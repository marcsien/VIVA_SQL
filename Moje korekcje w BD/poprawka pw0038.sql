use Synaptic 

select * from Document d where d.DocumentNumber = 'PWT0063/08/2021'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'F6DCCC33-7850-47D4-9512-043D1629F1F3'
/*
update DocumentProductDefinition
set OriginCount = 3220,
FinishCount = 3220
where Id = 'F84A68CF-25B7-4F6C-8A9E-0E1CD7EBCFA4'
*/

select * from DocumentProductDefinitionTaskItem dpdti where dpdti.DocumentId = 'F6DCCC33-7850-47D4-9512-043D1629F1F3'

/*
update DocumentProductDefinitionTaskItem
set Count = 3220,
CountSettled = 3220
where Id = 'E313D2B8-EEE7-483C-8586-B86015E57C3B'
*/


select * from DocumentProductDefinitionTaskItem dpdti2 where dpdti2.TaskId = '1A2C55BB-6C4A-4889-B4DD-A431052A71A3'




select * from TaskItemLogicalProduct tilp where tilp.TaskItemId = '8BD5F7A4-1357-4F28-8C49-16A167B796A9'

union all
select * from TaskItemLogicalProduct tilp where tilp.TaskItemId = '1EC9858F-DE37-4124-9CE3-637A20E95A8C'

/*
update TaskItemLogicalProduct
set IsNeglected = null,
IsFinished = 1,
IsReadyToGenerateDocument = 1
where Id = '9507A651-B084-4E06-83DC-6B331106108D'
*/

select * from LogicalProduct lp where lp.Id = '1E738DBB-863C-4E13-BEBF-605AF8E62C1B'


select * from TaskItems ti where ti.Id = '8BD5F7A4-1357-4F28-8C49-16A167B796A9'
union all
select * from TaskItems ti where ti.Id = '1EC9858F-DE37-4124-9CE3-637A20E95A8C'
