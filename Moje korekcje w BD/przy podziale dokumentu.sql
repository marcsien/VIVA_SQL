use Synaptic

select * from Document where documentprenumber = 'prepwt0116/09/2019'
--update DocumentProductDefinition set FinishCount='13376', OriginCount='13376' where id='0EE70390-9013-41D9-A73D-2A77ED0BEA65'
select * from DocumentProductDefinition where DocumentId='B8A52AD3-7315-4B8D-B639-543CFE04D4C9'
--update DocumentProductDefinitionTaskItem set Count='13376', CountSettled='13376' where id='B16B7B91-4C14-4B4B-965C-DC6D58B129FA'
select * from DocumentProductDefinitionTaskItem where DocumentProductDefinitionId='0EE70390-9013-41D9-A73D-2A77ED0BEA65'
select * from TaskItems where id ='CD73E682-A776-44FB-AC52-C2CAC103ACAB'
