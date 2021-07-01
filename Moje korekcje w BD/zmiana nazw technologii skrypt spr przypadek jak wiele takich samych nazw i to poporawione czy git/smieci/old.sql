use Synaptic
declare @name as nvarchar(50) = '485_264_030_SC_FT R4_K_G + P485_XXXX_XXX_SC_NC' -- tu wpisuje nazwe odczytan¹z technologii produkcji

-- 485_264_030_SC_FT_K_G + P485_XXXX_XXX_SC_NC -- bylo
-- 485_264_030_SC_FT R4_K_G + P485_XXXX_XXX_SC_NC -- zmienilo na 

--ponizej jest join ktory zbiera nazwy do wklejenia do formula
/*
select top 1 pd2.Name from ProductDefinition pd2 
inner join FormulaItems fi2 on pd2.Id = fi2.ProductDefinitionId
inner join Formula f2 on f2.Id = fi2.FormulaId
where pd2.ProductCategoryId = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' and f2.Name = @name
*/

--ponizej napisze selecta sklejaj¹cego now¹ nazwê

--select top 1 f2.Name from Formula f2 where f2.Name = @name
--SELECT SUBSTRING((select top 1 f2.Name from Formula f2 where f2.Name = @name), (SELECT CHARINDEX('+', (select top 1 f2.Name from Formula f2 where f2.Name = @name))), (len((select top 1 f2.Name from Formula f2 where f2.Name = @name)))) AS ExtractString;
select (select top 1 pd2.Name from ProductDefinition pd2 
inner join FormulaItems fi2 on pd2.Id = fi2.ProductDefinitionId
inner join Formula f2 on f2.Id = fi2.FormulaId
where pd2.ProductCategoryId = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' and f2.Name = @name) + ' ' + (SELECT SUBSTRING((select top 1 f2.Name from Formula f2 where f2.Name = @name), (SELECT CHARINDEX('+', (select top 1 f2.Name from Formula f2 where f2.Name = @name))), (len((select top 1 f2.Name from Formula f2 where f2.Name = @name)))))


--select * from Formula f where f.Name = @name -- nazwa technologii produkcji 


--select * from FormulaItems fi where fi.FormulaId = (select top 1 f.Id from Formula f where f.Name = @name) --stad wzialem skladniki technologii produkcji id wklejam z powyzej

-- tu musze wziac productdefinitionid gdzie productcategoryid w productdefinition = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' 

/*
select * from ProductDefinition pd1 
inner join FormulaItems fi1 on fi1.Id = pd1.ProductCategoryId
where pd1.ProductCategoryId = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' 

select * from ProductDefinition pdd where pdd.Id = '7B23AD5F-FB6E-4246-8A0A-100DA07F0628'
select * from ProductDefinition pdd where pdd.Id = '3EA97EF2-1DA9-4904-84D4-35076268536B' 
*/


-- ponizej update
/*
update Formula set Formula.Name = (select (select top 1 pd2.Name from ProductDefinition pd2 
inner join FormulaItems fi2 on pd2.Id = fi2.ProductDefinitionId
inner join Formula f2 on f2.Id = fi2.FormulaId
where pd2.ProductCategoryId = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' and f2.Name = @name) + ' ' + (SELECT SUBSTRING((select top 1 f2.Name from Formula f2 where f2.Name = @name), (SELECT CHARINDEX('+', (select top 1 f2.Name from Formula f2 where f2.Name = @name))), (len((select top 1 f2.Name from Formula f2 where f2.Name = @name))))))
where Formula.Name = @name

*/

