use Synaptic 
declare @LDate Datetime
declare @UDate Datetime
set @LDate='2021-07-01 12:00:00' -- data od 
set @UDate='2021-07-31 12:00:00' -- data do


IF OBJECT_ID('tempdb..#Table') IS NOT NULL
begin
        DROP TABLE #Table
end

CREATE TABLE #Table
(
	Id uniqueidentifier,
	Data datetime
)

DELETE FROM #Table

DECLARE @StartDate DATEtime = @LDate;
DECLARE @EndDate DATEtime = @UDate;
WHILE (@StartDate <= @EndDate)
BEGIN
insert into #Table
    select distinct pd.Id, @StartDate as Data
	from LogicalProduct lp 
	inner join Warehouse w on w.Id = lp.WarehouseId 
	inner join ProductDefinition pd on pd.Id = lp.ProductDefinitionId 
	inner join ProductCategory pc on pc.Id = pd.ProductCategoryId 
	where w.Id in (select w.Id from Warehouse w where w.Name in ('Surowce - Produkcja (Tuby)','Surowce (Tuby)'))
	and pc.Id in (select pc.Id from ProductCategory pc where pc.Name in ('PP i dodatki'))
set @StartDate = DATEADD(day, 1, @StartDate);
END;



select Data, 
(select pd.Name from ProductDefinition pd where pd.Id = #Table.Id) as Surowiec,
isnull((
select SUM(lp.Count)
from LogicalProduct lp 
inner join Warehouse w on w.Id = lp.WarehouseId 
inner join ProductDefinition pd on pd.Id = lp.ProductDefinitionId 
inner join ProductCategory pc on pc.Id = pd.ProductCategoryId 
where w.Id in (select w.Id from Warehouse w where w.Name in ('Surowce - Produkcja (Tuby)','Surowce (Tuby)'))
and pc.Id in (select pc.Id from ProductCategory pc where pc.Name in ('PP i dodatki'))
and Data between lp.Created and lp.Deleted
and pd.Id = #Table.Id
group by pd.Id, pd.name
),0) as Iloœæ
from #Table 
group by #Table.Id, #Table.Data
order by #Table.Id, #Table.Data