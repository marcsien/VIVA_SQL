use Synaptic

--select * from Request r where r.Number = 'Z3273/2019'

select * from RequestItems ri where ri.RequestId = '0DE6D7A6-9638-41D8-AEA2-8A664BA6576A' -- requestitems dla 242 ktorego nie zaciaga - sa tam usuniete jakies pozycje i zrealizowane z iloscia 0
select * from RequestItems ri where ri.RequestId = '0D259657-AEF6-4DF7-AE1E-493AF0B8FBC9'

--select * from RequestItems ri (nolock) where ri.Deleted is not null and ri.ProductBatchId = '6B993D3F-AC0B-42BC-8FCB-7554DAF7F27D'
/*
update RequestItems set RequestItems.InCount = 0 where RequestItems.Id = '1DDF12DC-B250-4096-8BBB-40E170AE4961' -- jak cos to na 0 zeby powrocic 
update RequestItems set RequestItems.InCount = 0 where RequestItems.Id = '02B4342C-F145-4BD7-8AD6-A97F977A69C9' -- jak cos to na 0 zeby powrocic
update RequestItems set RequestItems.InCount = 0 where RequestItems.Id = '08E14DCE-1522-4E01-BBD3-F7BFE0C1AF06' -- jak cos to na 0 zeby powrocic 
*/
/*
update RequestItems set RequestItems.OrderNumber = 1 where RequestItems.Id = '64E95261-CBB1-45BE-A5D5-1E7A4828A831' -- jak cos to na 1 zeby powrocic 
update RequestItems set RequestItems.OrderNumber = 1 where RequestItems.Id = '1A58B4F2-C5D7-4E3B-A727-7063BC0835AE' -- jak cos to na 1 zeby powrocic
update RequestItems set RequestItems.OrderNumber = 2 where RequestItems.Id = 'C27508B2-BB9F-4F2C-BCDD-FEBE2D10F844' -- jak cos to na 2 zeby powrocic 
*/

