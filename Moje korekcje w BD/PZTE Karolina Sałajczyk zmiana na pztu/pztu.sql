use Synaptic

select * from Document d where d.DocumentNumber = 'PZTESUR0005/01/2021'

--doc number 
select * from Document d where d.DocumentSeriesId = '04F71743-0D37-439F-B10F-675C52E5E98E' and d.DocumentNumber like '%/01/2021' ORDER BY d.DocumentNumber
--doc prenumber 
select * from Document d where d.DocumentSeriesId = '04F71743-0D37-439F-B10F-675C52E5E98E' and d.DocumentPreNumber like '%/01/2021' ORDER BY d.DocumentPreNumber


select * from Document d where d.Id = 'D9E8FB65-6868-4884-B056-C64C25508BE0'

/*
update Document 
set DocumentNumber = 'PZTU0007/01/2021', -- bylo PZTESUR0005/01/2021
DocumentPreNumber = 'PrePZTU0007/01/2021', -- bylo PrePZTESUR0005/01/2021
DocumentSeriesId = '04F71743-0D37-439F-B10F-675C52E5E98E', -- bylo C0E8157A-3FB7-4158-92C9-09A61AB2A680
DocumentSeriesNumberPatternId = 'A2EB1DAB-EED1-414B-B27C-27C525AFCA07' -- bylo DA30C5CA-0C4D-4A26-8C6C-E67582BA2D4C
--WarehouseDstName = 'Magazyn zewnêtrzny - Us³ugi' -- bylo Surowce (Tuby)
where Id = 'D9E8FB65-6868-4884-B056-C64C25508BE0'
*/


--doc number 
select * from Document d where d.DocumentSeriesId = 'C0E8157A-3FB7-4158-92C9-09A61AB2A680' and d.DocumentNumber like '%/01/2021' ORDER BY d.DocumentNumber
--doc prenumber 
select * from Document d where d.DocumentSeriesId = 'C0E8157A-3FB7-4158-92C9-09A61AB2A680' and d.DocumentPreNumber like '%/01/2021' ORDER BY d.DocumentPreNumber

/*
update Document
set DocumentNumber = 'PZTESUR0005/01/2021' -- bylo PZTESUR0007/01/2021
where Id = '70939033-A41D-41AB-AA00-3DE9236A87C2'
*/

/*
update Document
set DocumentPreNumber = 'PrePZTESUR0005/01/2021' -- bylo PrePZTESUR0007/01/2021
where Id = '70939033-A41D-41AB-AA00-3DE9236A87C2'
*/