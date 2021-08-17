USE [Synaptic]

Declare @LRangeDate DATETIME 
Declare @URangeDate DATETIME
Declare @DocLRangeDate DATETIME 
Declare @DocURangeDate DATETIME
Set @LRangeDate ='2021-04-01 14:00:00' /*otwarcie, tak jak zrobimy, '2020-04-01 14:00'*/
Set @URangeDate ='2021-05-04 13:59:59' /*zamkniêcie, tak jak zrobimy, '2020-05-04 13:59'*/
Set @DocLRangeDate ='2021-04-01 06:00:00'/*pierwszy dzieñ mies, tak jak ustalimy pierwsz¹ zmianê w kolejnym miesi¹cu, '2020-04-01 06:00:00'*/
Set @DocURangeDate ='2021-05-04 05:59:59'/*ostatni dzien mies, tak jak ustalimy ostatni¹ zmianê w kolejnym miesi¹cu, '2020-05-04 05:59:59'*/

/* SPRAWDZIÆ GODZINY ZAMKNÊCIA PW - MUSZ¥ BYÆ W OBRÊBIE DNIA I GODZIN WG KTÓRYCH POBIERAMY DANE!!!!!!!!!! */

select fpb.Name
		, SUM(FPB.INCOUNT) as Prod
		, SUM(FPB.RWCOUNT) as Tech
		, SUM(fpb.Transfercount) as TransferCount
		, SUM(fpb.scrapcount) as QCScrapCount
		, SUM(fpb.ReturnCOUNT) as ReturnCount
		, SUM(FPB.ReturnSCRAPCOUNT) ReturnScrap


from	(Select pd.Name
		, PD.Id  
		, ISNULL((CASE WHEN (DS.IsPW = 1 and (DS.NAME='pw' or ds.name='pw surowce')) THEN SUM(isnull(dpd.FinishCount, 0)) END), 0) AS INCOUNT
		, ISNULL((CASE WHEN (DS.IsRW = 1 and DS.NAME='RW') THEN SUM(isnull(dpd.FinishCount, 0))
					   WHEN (DS.IsPW = 1 and DS.Name='Korketa RW' ) THEN SUM(isnull(-dpd.finishCount,0)) END), 0) AS RWCOUNT
		, ISNULL((CASE WHEN (DS.IsRW = 1 and DS.NAME='RW Scrap') THEN SUM(isnull(dpd.FinishCount, 0)) END), 0) AS SCRAPCOUNT
		, ISNULL((CASE WHEN ((DS.IsMM = 1 and DS.NAME='MMZ' and left(whs.Name,18) ='Magazyn zewnêtrzny' and (left(whd.Name,8) ='Kontrola' OR left(whd.Name,8) ='Zwroty')) or (ds.ISMMP = 1 and ds.Name='MMPZ' and d.WarehouseDstName = 'Wyroby gotowe')) THEN SUM(isnull(dpd.FinishCount, 0)) 
					   WHEN ((DS.IsMM = 1 and ds.Name='Korekta MMZ')) THEN SUM(isnull(-dpd.finishCount,0)) END), 0) AS TRANSFERCOUNT -- bez dotatkowego warunku na magazyny bo ju¿ odfilotrowane w where dla klorekty mmz
		, ISNULL((CASE WHEN (DS.IsPZ = 1 and DS.NAME='PZ' and (left(whd.Name,6) ='Zwroty' or (left(whd.Name,8) ='Kontrola'))) THEN SUM(isnull(dpd.FinishCount, 0)) 
					   WHEN (ds.IsWZ = 1 and ds.Name='KOREKTA PZ') THEN SUM(isnull(-dpd.FinishCount, 0))  END), 0) AS ReturnCOUNT
		, ISNULL((CASE WHEN (DS.IsRW = 1 and DS.NAME='RW Zwroty') THEN SUM(isnull(dpd.FinishCount, 0)) END), 0) AS ReturnSCRAPCOUNT

		from DocumentProductDefinition DPD inner join
		 Document D on D.Id= DPD.DocumentId inner join 
		 DocumentSeries ds on ds.Id = D.DocumentSeriesId inner join
		 ProductDefinition pd on pd.Id = DPD.ProductDefinitionId left join 
		 Warehouse whs on whs.Id = DPD.WarehouseSrcId left join 
		 Warehouse whd on whd.Id = DPD.WarehouseDstId

		where PD.ProductCategoryId = '208A8F3D-480C-4960-86B1-048A9A7887BC'
		and (D.deadlinedate > @DocLRangeDate) AND (d.deadlinedate < @DocURangeDate)
		and (D.DocumentStatusId ='997C6161-ACEF-4D84-A75A-E1983087179B' or D.DocumentStatusId ='30369AA5-BFD3-4164-8606-B0EBE3D86A3B')
		and ((DS.IsPW = 1 and (DS.NAME='pw' or ds.name='pw surowce') and (d.WarehouseSrcName<>'87B21C20-A507-4BC7-A1E2-401AD45168C7' 
																		and d.WarehouseSrcName<>'9C0CF50A-B01D-420A-866D-640FCDC06CDC' 
																		and d.WarehouseSrcName<>'2735A5AC-3616-4A7A-89D0-8F2CDFB75E19' /*wykluczone magazyny zew. korekty*/)) or
			 (DS.IsRW = 1 and DS.NAME='RW') or
			 (DS.IsRW = 1 and DS.NAME='RW Scrap') or
			 ((DS.IsMM = 1 and DS.NAME='MMZ' and left(whs.Name,18) ='Magazyn zewnêtrzny' and (left(whd.Name,8) ='Kontrola' OR left(whd.Name,8) ='Zwroty'))) or
			 ((DS.IsMM = 1 and DS.NAME='Korekta MMZ' and left(whd.Name,18) ='Magazyn zewnêtrzny' and (left(whs.Name,8) ='Kontrola' OR left(whs.Name,8) ='Zwroty'))) or
			 ((DS.IsPZ = 1 and DS.NAME='PZ' and (left(whd.Name,6) ='Zwroty' OR (left(whd.Name,8) ='Kontrola')))) or
			 (DS.IsRW = 1 and DS.NAME='RW Zwroty') or 
			 (ds.IsWZ = 1 and ds.Name='KOREKTA PZ') or
			 (ds.ispw = 1 and ds.Name='Korekta RW') or
			 (ds.IsMMW = 1 and ds.Name='MMWZ' and d.WarehouseSrcName = 'Wyroby gotowe') or
			 (ds.ISMMP = 1 and ds.Name='MMPZ' and d.WarehouseDstName = 'Wyroby gotowe')


			)
		and DPD.FinishCount>0
		group by pd.Id, pd.Name, ds.IsPW, ds.IsRW, ds.Ismm, ds.Name, whs.Name, whd.Name, ds.IsPZ, DS.ISWZ, ds.IsMMW, ds.ISMMP, d.WarehouseDstName,d.WarehouseSrcName) as FPB

group by FPB.Name





