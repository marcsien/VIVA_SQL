use Synaptic
--declare @id as uniqueidentifier = null -- tu se wpisz id formula i odpal skrypt i sie automatycznie dla tego id zmieni nazwa 


DECLARE kursor CURSOR FOR
(
select f.Id  
from Formula f
inner join FormulaItems fi2 on fi2.FormulaId = f.Id
inner join ProductDefinition pd2 on pd2.Id = fi2.ProductDefinitionId
where (pd2.Name like '% R2%' or pd2.Name like '% R4%') 
and f.Name like '% + %' 
and f.Name like '485_%'
and f.Name not like '% R2%' 
and f.Name not like '% R4%'
)

declare @id as uniqueidentifier

OPEN kursor
FETCH NEXT FROM kursor INTO @id
WHILE @@FETCH_STATUS = 0
		BEGIN
		update Formula set Formula.Name = (select (select pd2.Name from ProductDefinition pd2 
												   inner join FormulaItems fi2 on pd2.Id = fi2.ProductDefinitionId
												   inner join Formula f2 on f2.Id = fi2.FormulaId
												   where pd2.ProductCategoryId = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' and f2.Id = @id) 
												   + ' ' 
												   + (SELECT SUBSTRING((select f2.Name from Formula f2 where f2.Id = @id), 
												   (SELECT CHARINDEX('+', (select f2.Name from Formula f2 where f2.Id = @id))), 
												   (len((select f2.Name from Formula f2 where f2.Id = @id))))))
		where Formula.Id = @id

		FETCH NEXT FROM kursor INTO @id
		END

CLOSE kursor
DEALLOCATE kursor
