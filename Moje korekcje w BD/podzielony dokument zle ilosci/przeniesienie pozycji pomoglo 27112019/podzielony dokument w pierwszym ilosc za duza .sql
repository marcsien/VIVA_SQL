use Synaptic

select * from Document d where d.DocumentNumber = 'PWTSUR0139/10/2019'
select * from DocumentProductDefinition dpd where dpd.DocumentId = '0A7EE346-2050-4877-8896-E914527311A2'


select * from Document d where d.DocumentNumber = 'PWTSUR0059/11/2019'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'D730A1B1-E4AE-4615-9F7C-1E384606F460'

select * from Document d where d.DocumentNumber = 'PWTSUR0169/10/2019'
select * from DocumentProductDefinition dpd where dpd.DocumentId = 'D1CE0190-F3E3-4DFF-ADBF-0741ADDFB278'


--ponizej zmienilem pozycje dpd nalezaca do pierwssgo doku zeby nalezala do 169
--update DocumentProductDefinition set DocumentProductDefinition.DocumentId = '2E240A90-868E-457B-A057-3CBBCB52BB77' where DocumentProductDefinition.Id = 'FF211F62-8AD0-41B0-B1F5-B7DAE88CF614' -- przerzuca pozycje dpd z pierwszego doku do drugiego


--ponizej zmiana przenieisonej pozycji na ilosc 9216 zeby fizyczny stan by³ git poprzednio bylo 0 i potem zmienilem na 0 bo to jednak w zlym doku
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 0 where DocumentProductDefinition.Id = '473E5354-61E5-429E-AFA9-ED04445B7C7A'


--ponizej w pozycji doku z tego miesiaca dodalem ilosc 9216 zeby fizycny stan sie zgadzal
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 18432 where DocumentProductDefinition.Id = 'E09AF5E9-7DBC-47C5-80B7-E26540751A71' -- by³o  9216