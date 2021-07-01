use Synaptic

--select * from DocumentSeries 

select d.DocumentNumber
, d.Realizated as Data_Realizacji
, (CASE
    WHEN d.DocumentSeriesId = '5E2DD341-07E8-4840-8DBE-0CE50F2DB91F' THEN 'Media'
    WHEN d.DocumentSeriesId = 'F79CAFBD-69E0-4159-99EC-2551C5354225' THEN 'Tuby'
    ELSE 'Unknown'
END) as Oddzia³
,p.Name + ' ' + p.Surname as Osoba
,pd.Name as Nazwa_Towaru
,isnull(pb.Name,'') as Numer_Partii 
,dpd.FinishCount as Iloœæ
,d.Comment as Powód
from Document d
inner join DocumentProductDefinition dpd on dpd.DocumentId = d.Id
inner join ProductDefinition pd on dpd.ProductDefinitionId = pd.Id
left join ProductBatch pb on dpd.ProductBatchId = pb.Id
inner join Person p on p.Id = d.PersonId
where d.DocumentSeriesId in ('5E2DD341-07E8-4840-8DBE-0CE50F2DB91F' , 'F79CAFBD-69E0-4159-99EC-2551C5354225')
and d.Realizated between '2020-07-01 00:00:00.000' and '2020-12-31 00:00:00.000'
and d.DocumentNumber is not null
order by d.Realizated