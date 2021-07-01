use Synaptic
------------------------------------------------------ zapisuj sobie ladnie zapytania ktore uzyles z wlasnym opisem 
declare @Doc1Pre nvarchar(20)
declare @Doc2Pre nvarchar(20)
set @Doc2Pre = 'PrePWT0001/10/2019'
set @Doc1Pre = 'PrePWT0019/09/2019'


--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 0 where DocumentProductDefinition.Id='2C1BE7A5-3221-4993-918A-AF96A5F287AC'


select * from Document d (nolock) where d.DocumentPreNumber=@Doc1Pre
select * from DocumentProductDefinition dpd (nolock) where dpd.DocumentId=(select d.Id from Document d(nolock) where d.DocumentPreNumber=@Doc1Pre)
select * from DocumentProductDefinition dpd (nolock) where dpd.DocumentId=(select d.Id from Document d(nolock) where d.DocumentPreNumber=@Doc2Pre)
select * from Task t (nolock) where t.DocumentId=(select d.Id from Document d(nolock) where d.DocumentPreNumber=@Doc1Pre)
select * from TaskItems ti (nolock) where ti.TaskId = (select t.Id from Task t (nolock) where t.DocumentId=(select d.Id from Document d (nolock) where d.DocumentPreNumber=@Doc1Pre))

--select * from Document d where d.DocumentPreNumber=@Doc2Pre
--select * from Task t (nolock) where t.DocumentId=(select d.Id from Document d(nolock) where d.DocumentPreNumber=@Doc2Pre)
--select * from TaskItems ti (nolock) where ti.TaskId = (select t.Id from Task t (nolock) where t.DocumentId=(select d.Id from Document d (nolock) where d.DocumentPreNumber=@Doc2Pre))

