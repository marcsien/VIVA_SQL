use Synaptic

select * from LogicalProduct lp where lp.BarCode = '1001193064'

select * from LogicalProduct lp2 where lp2.BarCode = '1001200316' --ok

select * from LogicalProduct lp3 where lp3.BarCode = '1001194176'




/*
update LogicalProduct
set Deleted = NULL -- bylo 2020-04-28 08:03:02.003
where Id = '380A619C-042E-4106-8D9F-AE372CD36C9F'

update LogicalProduct
set Deleted = NULL -- bylo 2020-04-28 07:57:48.437
where Id = '9ADAEBF3-E6F8-437F-A324-F60B8D3BC4BF'
*/

