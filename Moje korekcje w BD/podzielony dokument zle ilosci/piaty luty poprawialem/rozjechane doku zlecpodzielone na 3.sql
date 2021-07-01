use Synaptic

select * from Document d where d.DocumentPreNumber = 'PrePWTSUR0141/01/2020'

select * from DocumentProductDefinition dpd where dpd.DocumentId ='75ABE106-9C5B-474F-B82E-19EC1EC3D894'


update DocumentProductDefinition 
set FinishCount = 65568
where Id = '23C342AD-1FF4-4587-96BA-E667C0486FAD'


update DocumentProductDefinition 
set FinishCount = 0
where Id = '284321FB-DDF5-48AF-98C5-8AEC06460D1E'