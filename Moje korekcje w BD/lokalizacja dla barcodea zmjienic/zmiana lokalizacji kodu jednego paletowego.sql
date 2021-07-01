use Synaptic

select * from LogicalProduct lp where lp.BarCode = '1001189473' -- do poprawienia

select * from LogicalProduct lp where lp.BarCode = '1001189428' -- stadw wzialem id warehousause id 


select * from LogicalProduct lp where lp.Id = '0B685AEB-89B5-4ABC-9246-B74E77858E10'


/*
update LogicalProduct
set WarehouseId = '87B21C20-A507-4BC7-A1E2-401AD45168C7'
where Id = '0B685AEB-89B5-4ABC-9246-B74E77858E10'
*/
/*
update LogicalProduct
set WarehouseId = '87B21C20-A507-4BC7-A1E2-401AD45168C7'
where Id = '62DC9F85-69EA-437A-9996-FAE56E07675E'
*/
 
 --dodatkowo trzeba logicalplace


 select * from LogicalPlace lp where lp.Id = '0F1D1199-139F-4CF8-8D79-E67DD05B8178'