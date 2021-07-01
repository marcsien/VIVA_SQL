use Synaptic

select * from LogicalProduct lp where lp.BarCode = 'X0838148'
union all
select * from LogicalProduct lp where lp.BarCode = 'X1893184'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0774636'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0869223'
union all
select * from LogicalProduct lp where lp.BarCode = 'X1023054'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0808333'


select * from Stock s where s.Id = '5C749EE4-5BA4-4E23-9410-395A5C23427F' -- stock id nieograniczone wykorzystanie

begin tran

update LogicalProduct
set StockId = '5C749EE4-5BA4-4E23-9410-395A5C23427F'
where Id in ('1C543253-8E17-4697-8787-4776C0A7CE3B','1A0DA14A-F634-439D-B39E-8EF29CA792DB','3055F4B4-A946-48C6-AE4E-5AC8BDDF1BBE','5164FD4E-A9F8-493D-9FA2-BDC95B7F28F0','E2205B8B-3115-47B1-9CC1-6C0F8982E89A','1F43A1AE-DBF6-4538-96A7-E25170FA6BC3','644CAB10-C84C-4473-BF4A-764D7289C197','CED0627D-8FE9-4ECA-A9B0-DB0A5F14202F','68978E3E-AF02-4213-B061-8942AA1A2002','FA9A94CA-79D1-400C-A543-F12B06818191','A88F22A0-0866-4EEF-BD3D-A589CE49B24A','D817F14D-3581-4BAF-8948-C3518D37C2EC')

select * from LogicalProduct lp where lp.BarCode = 'X0838148'
union all
select * from LogicalProduct lp where lp.BarCode = 'X1893184'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0774636'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0869223'
union all
select * from LogicalProduct lp where lp.BarCode = 'X1023054'
union all
select * from LogicalProduct lp where lp.BarCode = 'X0808333'

rollback tran