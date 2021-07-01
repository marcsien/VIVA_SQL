use Synaptic
--select * from Document d where d.DocumentNumber = 'PWT0098/11/2019'


declare @Id uniqueidentifier
set @Id = 'CA749688-BE48-459B-938D-283A7D6CF239' 

select * from Document d where d.Id = @Id

select * from DocumentProductDefinition dpd where dpd.DocumentId = @Id




--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 4048 where DocumentProductDefinition.Id = 'BC1D56B7-BA3B-41C3-8687-13FD1C82E2D2' -- oryginalnie by³o 3960


-- w ponizszym bledne id wzialem i uruchomilem to , id to productdefinitionit z tych 3 wczytanych documentproductdefinition
--update DocumentProductDefinition set DocumentProductDefinition.FinishCount = 4048 where DocumentProductDefinition.Id = '7058B4D2-FDA3-4674-8EDF-7564BA51E431' -- oryginalnie by³o 3960