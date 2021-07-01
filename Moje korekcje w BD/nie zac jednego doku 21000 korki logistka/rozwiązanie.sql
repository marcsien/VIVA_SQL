use Synaptic

w jednym doku nie bylo w dpd productbatch id i nie zaciagnelo przez too do raportu cap 

select * from Document d where d.DocumentNumber = 'PZTSUR0003/03/2020' 

select * from DocumentProductDefinition dpd where dpd.DocumentId = '03CD8CBB-D527-4B5E-86DE-BCCE8F1E7E80'

/*
update DocumentProductDefinition
set ProductBatchId = '0F7CA04C-0FDE-4DB4-89AE-697F0C13CAA0' -- bylo null
where Id= '94852A54-6A0F-4D65-B071-4C60E42D77C1'
*/