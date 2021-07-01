use Synaptic

select * from Formula f where f.Name like '%485_264_015_SC_FT R4_TP_ME/SI + P485_XXXX_XXX_SC_NC%' -- nazwa technologii produkcji 

--select * from ProductDefinition pd where pd.Id = '86912166-C649-4292-B266-8CD0563B6F72'

select * from FormulaItems fi where fi.FormulaId = '5E628CD4-8FFE-4327-892D-E1FCBB56BCB5' --stad wzialem skladniki technologii produkcji

-- tu musze wziac productdefinitionid gdzie productcategoryid w productdefinition = '7DBA1E4C-BA7A-49F4-96AD-0D507EE0258B' 


select * from ProductDefinition pdd where pdd.Id = '7B23AD5F-FB6E-4246-8A0A-100DA07F0628'
select * from ProductDefinition pdd where pdd.Id = '3EA97EF2-1DA9-4904-84D4-35076268536B' 