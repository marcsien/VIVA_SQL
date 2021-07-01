use Synaptic

-- zmiana serii doku : 
select * from Document d where d.DocumentNumber = 'PZTSUR0003/03/2020' --dokument do zmiany id = 03CD8CBB-D527-4B5E-86DE-BCCE8F1E7E80
--tego u gory id trzeba dac 
--docnum - PZTCSUR0001/03/2020
--docprenum - PrePZTCSUR0001/03/2020
--i inne na wzór z doku PZTCSUR0001/04/2020
union
select * from Document d where d.DocumentNumber = 'PZTCSUR0001/04/2020'
--ponizej update do powyzszych :
/*
update Document
set DocumentNumber = 'PZTCSUR0001/03/2020', -- bylo PZTSUR0003/03/2020
DocumentPreNumber = 'PrePZTCSUR0001/03/2020', -- bylo PrePZTSUR0003/03/2020
DocumentSeriesId = '2409AA6E-8F8E-49B9-B7C5-B60AF0CD8FB9', -- bylo 4A27D315-018E-41CA-9BBF-3E09E574738A
DocumentSeriesNumberPatternId = '8AC468E8-69EE-4CE2-AB00-F960F1BFB114' -- bylo D88E495F-ED29-42F5-A5B7-2F3F544C1B35
where Id = '03CD8CBB-D527-4B5E-86DE-BCCE8F1E7E80'
*/






--zalatanie dziury w pztsurach: 

-- PZTSUR0003/03/2020 zniklo wiec ta nazwe bedzie mia³ teraz PZTSUR0015/03/2020

-- czyli PZTSUR0015/03/2020 -> PZTSUR0003/03/2020
-- czyli PrePZTSUR0001/04/2020 -> PrePZTSUR0003/03/2020





--ale jeszcze latanie dziury po PrePZTSUR0001/04/2020   nazwe po lewej ma miec  to po prawo PrePZTSUR0006/04/2020