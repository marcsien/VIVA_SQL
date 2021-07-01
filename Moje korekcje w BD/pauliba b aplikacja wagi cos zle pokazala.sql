use synaptic



select * from Document d where d.DocumentNumber = 'PZTU0008/02/2021'

select * from DocumentProductDefinition dpd where dpd.DocumentId = '3880F322-1A00-4318-B32E-4B8028523617' and dpd.ProductBatchId in ('60DF6CF0-CEEC-41BC-A2CE-3337CDFC712D','31B086C6-5429-4D54-B21F-A72C95D20853')


select * from ProductBatch pb where pb.Param1 = 'LABEL/21-0511/01' or pb.Param1 = 'LABEL/21-0478/01'

/*
update ProductBatch 
set Param2 = 'R-25243980004', -- bylo 'POTTER+MOORE CREIGHTONS SUNSHINE BLONDE SILVER SHAMPOO PURPLE 200ML (B)'
Param3 = 'POTTER+MOORE CREIGHTONS SUNSHINE BLONDE SILVER SHAMPOO PURPLE 200ML (B)' -- bylo 'R-25243980004'
where Id = '31B086C6-5429-4D54-B21F-A72C95D20853'
*/
