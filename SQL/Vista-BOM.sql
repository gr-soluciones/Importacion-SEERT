DROP VIEW IF EXISTS GR_BOM;
GO

CREATE VIEW GR_BOM WITH SCHEMABINDING AS
SELECT
       LEFT(bm.Par_NoPartePadre, 30) AS Par_NoPartePadre,
       LEFT(bm.Par_NoParteHijo, 30) AS Par_NoParteHijo,
       bm.Bom_FechaFin,
       bm.Bom_Cantidad,
       LEFT(bm.Med_Clave, 5) AS Med_Clave,
       bm.Bom_FactConvD,
       bm.Bom_FechaIni,
       IIF(bm.Par_NoPartePadre in (SELECT bm.Par_NoParteHijo FROM dbo.Ca_Bom),
           'SI',
           'NO') AS MakeBuy
FROM
     dbo.Ca_Bom AS bm;

drop view if exists GR_BOM2;
CREATE VIEW GR_BOM2 WITH SCHEMABINDING AS
SELECT
       top 100
       LEFT(bm.Par_NoPartePadre, 30) AS Par_NoPartePadre,
       LEFT(bm.Par_NoParteHijo, 30) AS Par_NoParteHijo,
       bm.Bom_FechaFin,
       bm.Bom_Cantidad,
       LEFT(bm.Med_Clave, 5) AS Med_Clave,
       bm.Bom_FactConvD,
       bm.Bom_FechaIni,
       IIF(bm.Par_NoPartePadre in (SELECT bm.Par_NoParteHijo FROM dbo.Ca_Bom),
           'SI',
           'NO') AS MakeBuy
FROM
     dbo.Ca_Bom AS bm;

-- select count(*) from (select 0 AS C from GR_BOM group by Par_NoPartePadre, Par_NoParteHijo, Bom_FechaFin) AS TB
-- CREATE UNIQUE CLUSTERED INDEX IDX_V1
--    ON GR_BOM (Par_NoPartePadre, Par_NoParteHijo, Bom_FechaFin);