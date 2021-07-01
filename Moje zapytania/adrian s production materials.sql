use Synaptic
declare @id as uniqueidentifier  = 'DCA83B6D-BA2C-4F11-9CB1-0F2178C09FC0'

select ISNULL(STRING_AGG(pd.Name,'; '),'BRAK') from ProductionOrder po
inner join ProductionOrderItems poi on poi.ProductionOrderId = po.Id
inner join Formula f on f.Id = poi.FormulaId
inner join FormulaItems fi on fi.FormulaId = f.Id
inner join ProductDefinition pd on pd.Id = fi.ProductDefinitionId
inner join ProductCategory pc on pc.Id = pd.ProductCategoryId
where pc.Id = 'A2394C5E-56E1-4A1A-83EF-36F5DEFC2E98' --pc.Name = 'PP i dodatki'
and poi.Id = @id -- tutaj id zlecenia prod


select * from ProductionOrder

select * from ProductionOrderItems poi where poi.ProductionOrderId in ('E7C8E98F-F88A-4E29-994D-0002554A7F7A','862BFD53-E4ED-4400-BE4C-00025DABFC6F','62C7114B-9163-47A6-A5B6-00108C609087')




select top 50 * from ProductionMaterials pm
inner join ProductDefinition pd on pd.Id = pm.ProductDefinitionId

select * from ProductCategory pc where pc.Name = 'PP i dodatki'