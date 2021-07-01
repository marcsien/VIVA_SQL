use Synaptic


select * from Request r where r.Number like '%ZE3531%'

select * from RequestAdditionalData rad where rad.RequestId = 'BFD64F54-37DD-4271-AE5C-D2B68120C982'

select * from Document d where d.DocumentNumber = 'RWTSUR0165/06/2020'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'FDEF29FF-B512-4A7C-A918-FD2D2AE883DF'
select * from ProductBatch pb where pb.Id = '0695734F-0A60-44E8-BA3F-511234E81652'

/*
update RequestAdditionalData
set AdditionalColumnShortString = 'R-25243980001' --bylo 'R-25243980004'
where Id = '5FF73EB8-059C-4A88-B4AC-3EB8DF35D496'
*/

/*
update RequestAdditionalData
set AdditionalColumnShortString = 'LABEL/20-0571/02' --bylo 'LABEL/20-0638/01'
where Id = 'B584E41E-4E28-4A55-A5DA-69BD0F1F1106'
*/

/*
update RequestAdditionalData
set AdditionalColumnShortString = 'POTTER+MOORE CREIGHTONS SUNSHINE BLONDE CONDITIONER 250ML (B)' --bylo 'POTTER+MOORE CREIGHTONS SUNSHINE BLONDE SILVER SHAMPOO PURPLE 200ML (B)'
where Id = '621672A8-4D67-438D-8416-D0A0682B0555'
*/