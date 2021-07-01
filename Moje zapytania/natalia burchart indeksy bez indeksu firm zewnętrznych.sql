use Synaptic

select pd.Name as 'Indeks towarowy', pdc.ExternalSystemId as 'Indeks firmy zewnêtrznej'
from ProductDefinition pd
left join ProductDefinitionCompany pdc on pd.Id = pdc.ProductDefinitionId
--inner join Company c on c.Id = pdc.CompanyId

where pdc.ExternalSystemId is null and pd.ProductCategoryId = '208A8F3D-480C-4960-86B1-048A9A7887BC'



--select * from ProductCategory pc