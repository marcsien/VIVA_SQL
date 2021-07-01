use Synaptic

select * from Task t where t.Name like '%PrePWT0002/12/2019%'

select * from DocumentTask dt where dt.TaskId = '3DB8574C-D680-46F4-A3A4-71855A9371D7'

select * from Document d where d.Id = 'E013C3FC-37D9-493F-827D-DBAB1B7A2B17'
select * from Document d where d.Id = 'D5F9B9E7-2D3E-4D8D-8CD1-E05654639B5F'

select * from DocumentProductDefinition dpd where dpd.DocumentId = 'E013C3FC-37D9-493F-827D-DBAB1B7A2B17'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'D5F9B9E7-2D3E-4D8D-8CD1-E05654639B5F'