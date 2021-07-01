use Synaptic 

select * from Request r where r.Number = 'Z3438/2019'

select * from RequestAdditionalData rad where rad.RequestId = '2C1D391D-E991-4B1F-A116-23D168654B78'

-- nie zaci¹ga³o tej partii 'FT/20-0421/01', by³a spacja w tabeli ponizej przed ft:


/*

update RequestAdditionalData 
set AdditionalColumnShortString = 'FT/20-0421/01'
where Id = '4D7C614C-66EB-40E6-BB2D-C5CAB2EE6634'

*/