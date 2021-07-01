use Synaptic

select * from Document d where d.DocumentPreNumber = 'PrePWTSUR0040/10/2019'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'BE9B4608-FF10-4B35-82D9-8CBD5DC72159'


select * from Document d where d.DocumentPreNumber = 'PrePWTSUR0171/10/2019'
select * from DocumentProductDefinition dpd where dpd.DocumentId = '7A1CBC49-1C31-4231-98AB-531C449AEC6F'

--update DocumentProductDefinition set DocumentProductDefinition.DocumentId = '7A1CBC49-1C31-4231-98AB-531C449AEC6F' where DocumentProductDefinition.Id = 'F8819463-D558-4CE6-B244-8AFB55C26F4F' -- przerzuca pozycje dpd z pierwszego doku do drugiego