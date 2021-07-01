use Synaptic

select * from Document d where d.DocumentNumber = 'WZTSUR0002/09/2020'

select * from Company c where c.Name like '%reynd%'

select * from Company c where c.Id = '27F4AAD9-F42D-4573-8DBD-EB83E8DC2485'

/*
update Document 
set CompanyRecipientId = 'A5DF75F3-8661-421D-AD87-922DB4483668' -- bylo '27F4AAD9-F42D-4573-8DBD-EB83E8DC2485'
where Id = 'CCD57506-CF06-404A-B451-58ABDE582621'
*/