use Synaptic


 select * from ProductBatch pb where pb.Name = 'CAP/20-0590/01/W2163/2020'


 select * from DocumentProductDefinition dpd where dpd.ProductBatchId = '0F7CA04C-0FDE-4DB4-89AE-697F0C13CAA0' and dpd.FinishCount <> 0 