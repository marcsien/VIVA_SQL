use synaptic
/*
begin transaction
select * from Formula f where f.Name like '%light%'

update Formula
set Name = replace(Name,'LIGHT GREY', 'WT1-PCR')
where Name like '%light%'

select * from Formula f where f.Name like '%light%'
select * from Formula f where f.Name like '%WT1-PCR%'
commit transaction
*/

/*
begin transaction
select * from ProductDefinition pd where pd.Name like '%light grey%'

update ProductDefinition 
set Name = replace(Name,'LIGHT GREY','WT1-PCR'),
AdditionalMark = replace(AdditionalMark,'LIGHT GREY','WT1-PCR')
where Name like '%light grey%' and Name not in ('T300_1300_040_SC_LIGHT GREY_PCR+4000 (CAN)','T190_0800_020LBP_SC_PCR LIGHT GREY/NC G_PCR+4500 (CAN)','DIPOLEN PP-73 LIGHT GREY','DIPOLEN PP-73 LIGHT GREY MEDIA')

select * from ProductDefinition pd where pd.Name like '%light grey%'
select * from ProductDefinition pd where pd.Name like '%WT1-PCR%'
commit transaction
*/

