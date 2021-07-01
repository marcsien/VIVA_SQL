USE [Synaptic]
GO

/****** Object:  UserDefinedFunction [dbo].[BilansVPPMWysylki]    Script Date: 2021-05-05 09:47:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER function [dbo].[BilansVPPMWysylki] (@LRangeDate Datetime, @URangeDate Datetime,@MMZLRangeDate Datetime, @MMZURangeDate Datetime)
RETURNS TABLE
AS 
RETURN

SELECT     TOP (100) PERCENT PB.Name AS JSName, PD.Name, CAST(SUM(WYS.COUNT) AS int) AS count, WYS.ExternalSystemId, CAST(SUM(WYS.COUNTRW) AS int)
                      AS UsedOnProduction, CAST(SUM(WYS.COUNTRWZ) AS int) AS Scrapped
FROM         dbo.ProductBatch AS PB INNER JOIN
                      dbo.ProductDefinition AS PD ON PB.ProductDefinitionId = PD.Id INNER JOIN



                          (SELECT     ISNULL((CASE WHEN (DS.IsWZ = 1 OR DS.IsMMW = 1 OR ((DS.NAME='MMZ' or ds.Name='Korekta MMZ') and (DW.WarehouseSrcName<>'Magazyn zewnêtrzny Ejko' and DW.WarehouseSrcName<>'Magazyn zewnêtrzny Technicolor' and DW.WarehouseSrcName<>'Magazyn zewnêtrzny Sklad')))
														THEN SUM(isnull(TILP.Count, 0)) 
												   WHEN  ((ds.Name='MMZ' or ds.Name='Korekta MMZ' or ds.Name = 'MMPZ' or ds.Name = 'KOREKTA WZ') and (DW.WarehouseSrcName<>'Magazyn zewnêtrzny Ejko' or DW.WarehouseSrcName='Magazyn zewnêtrzny Technicolor' or DW.WarehouseSrcName='Magazyn zewnêtrzny Sklad') and DW.WarehouseDstName='Wyroby gotowe')
														THEN -SUM(isnull(TILP.Count, 0)) 
												   END), 0) AS COUNT, 
                                                   ISNULL((CASE WHEN DS.Name = 'RWtace' THEN SUM(isnull(TILP.Count, 0)) END), 0) AS COUNTRW,
                                                   ISNULL((CASE WHEN DS.Name='RW ZWROTY' THEN SUM(isnull(TILP.Count, 0)) END), 0) AS COUNTRWZ,
                                                   LP.ProductBatchId, LP.ProductDefinitionId, 
                                                   BR.ExternalSystemId
                            FROM          dbo.LogicalProduct AS LP WITH (NOLOCK) left JOIN
                                                   dbo.LogicalProduct AS BLP WITH (NOLOCK) ON BLP.Id = LP.ParentLogicalProductId left JOIN
                                                   dbo.BoxDefinition AS BR WITH (NOLOCK) ON BR.Id = BLP.BoxDefinitionId INNER JOIN
                                                   dbo.TaskItemLogicalProduct AS TILP WITH (NOLOCK) ON LP.Id = TILP.LogicalProductId AND TILP.IsReadyToGenerateDocument = 1 INNER JOIN
                                                   dbo.TaskItems AS TI WITH (NOLOCK) ON TI.Id = TILP.TaskItemId INNER JOIN
                                                   dbo.Task AS T WITH (NOLOCK) ON T.Id = TI.TaskId AND T.Realizated IS NOT NULL AND T.RefusedDate IS NULL INNER JOIN
                                                   dbo.DocumentTask AS DT ON DT.TaskId = T.Id INNER JOIN
                                                   dbo.[Document] AS DW WITH (NOLOCK) ON DW.Id = DT.DocumentId INNER JOIN
                                                   dbo.DocumentSeries AS DS WITH (NOLOCK) ON DS.Id = DW.DocumentSeriesId AND (DS.IsWZ = 1 OR
                                                   DS.Name = 'RWtace' or DS.Name='RW ZWROTY' or DS.Name='MMZ' or ds.Name='Korekta MMZ' or ds.IsMMW = 1 or ds.ISMMP = 1 or ds.Name = 'KOREKTA WZ')
                            WHERE   
							
							(
							
												   (
														(LP.Deleted > @LRangeDate) AND (LP.Deleted < @URangeDate) 
														and 
														(DS.IsWZ = 1 OR DS.Name = 'RWtace' or DS.Name='RW ZWROTY')
														and 
														(
															(DW.WarehouseSrcName<>'Magazyn zewnêtrzny Ejko' and DW.WarehouseSrcName<>'Magazyn zewnêtrzny Technicolor' and DW.WarehouseSrcName<>'Magazyn zewnêtrzny Sklad')		   
															or 
															(
																ds.Name='MMZ' and (DW.WarehouseSrcName<>'Magazyn zewnêtrzny Ejko' or DW.WarehouseSrcName='Magazyn zewnêtrzny Technicolor' or DW.WarehouseSrcName='Magazyn zewnêtrzny Sklad') and DW.WarehouseDstName='Wyroby gotowe'
															)
														)
												   ) 

												   or 

												   (
												   
														(DS.Name='MMZ' or DS.Name='Korekta MMZ') 
												   
														and 
												   
														DW.DeadlineDate>@MMZLRangeDate AND DW.DeadlineDate<@MMZURangeDate
												   
												   )

												   or

												   (
														DW.DeadlineDate>@MMZLRangeDate AND DW.DeadlineDate<@MMZURangeDate
														and 
														ds.IsMMW = 1 
														and 
														dw.WarehouseSrcName = 'Wyroby gotowe'
												   )

												   or

												   (
														DW.DeadlineDate>@MMZLRangeDate AND DW.DeadlineDate<@MMZURangeDate
														and 
														ds.ISMMP = 1 
														and 
														dw.WarehouseDstName = 'Wyroby gotowe'
												   )

												   or

												   (
														DW.DeadlineDate>@MMZLRangeDate AND DW.DeadlineDate<@MMZURangeDate
														and 
														ds.Name = 'KOREKTA WZ' 
														and 
														dw.WarehouseDstName = 'Wyroby gotowe'
												   )
												   
							)


                            GROUP BY LP.ProductBatchId, LP.ProductDefinitionId, BR.ExternalSystemId, DS.IsWZ, DS.Name, DW.WarehouseSrcName, DW.WarehouseDstName, ds.IsMMW) AS WYS ON WYS.ProductBatchId = PB.Id 
							
							
							AND 
                      WYS.ProductDefinitionId = PD.Id
WHERE PD.ProductCategoryId='208A8F3D-480C-4960-86B1-048A9A7887BC'
GROUP BY PB.Name, PD.Name, WYS.ExternalSystemId
ORDER BY JSName, PD.Name, WYS.ExternalSystemId




GO


