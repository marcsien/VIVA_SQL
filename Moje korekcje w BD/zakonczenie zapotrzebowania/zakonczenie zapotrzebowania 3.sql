use Synaptic

select * from Request r where r.Number = 'WT3986/2020' or r.Number = 'Z3940/2020'

/*
update Request
set RealizationDate = '2020-08-12 09:38:20.000',
CompanyId = '20C21463-5798-43F0-AA97-66F21F40A623'
where Id = 'DEF5AF0A-7162-458D-9A17-3A0749500DAA'
*/



select * from Company c where c.Id = '20C21463-5798-43F0-AA97-66F21F40A623'