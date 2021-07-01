use Synaptic 

select f.Id, f.Name,pd2.Name  
from Formula f
inner join FormulaItems fi2 on fi2.FormulaId = f.Id
inner join ProductDefinition pd2 on pd2.Id = fi2.ProductDefinitionId
where (pd2.Name like '% R2%' or pd2.Name like '% R4%') and f.Name not like 'Z_nieaktualne %' and f.Name like '% + %' and f.Name like '485_%'
and f.Name not like '% R2%' and pd2.Name like '% R4%'

