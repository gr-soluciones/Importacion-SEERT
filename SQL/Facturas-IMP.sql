DROP VIEW IF EXISTS GR_FACTEXPORT;
GO
CREATE VIEW GR_FACTEXPORT AS
select
       LEFT(F.FEx_Folio, 30) AS Folio,
       MAX(F.FEx_Fecha) AS Fecha,
       AVG(F.FEx_TipoCambioUsd) AS TCambio,
       MAX(LEFT(C.RFC, 13)) AS Importador,
       MAX(LEFT(cE.RFC, 13)) AS Exportador,
       MAX(LEFT(aMX.RFC, 13)) AS AgenciaMX,
       MAX(LEFT(aUSA.RFC, 13)) AS AgenciaUSA,
       MAX(LEFT(F.FEx_VehPlacasMx, 20)) AS PlacasMx,
       MAX(LEFT(F.FEx_VehPlacasUSA, 20)) AS PlacasUSA,
       MAX(LEFT(Ite_Clave, 3)) AS Intercom,
       MAX(right(year(Ped.[Pex_FechaPago]),2)+' '+left(Ped.[Adu_AduanaSecc],2)+' '+Ped.[AgP_Patente]+' '+Ped.[Pex_Folio]) AS Pedimento,
       MAX(Ped.Pex_FechaIni) AS FechaPedimento
       -- ,F.*
from
     dbo.De_Factura F
     LEFT JOIN dbo.GR_CLIENTES_MAX C ON (F.Cli_Importador = C.NombreCorto) or (F.Cli_Importador = C.RazonSocial)
     LEFT JOIN dbo.GR_CLIENTES_MAX cE ON (F.Cli_Exportador = cE.NombreCorto) or (F.Cli_Exportador = cE.RazonSocial)
     LEFT JOIN dbo.GR_Agencia aMX ON aMX.AgA_Corto = F.AgA_Mex
     LEFT JOIN dbo.GR_Agencia aUSA ON aUSA.AgA_Corto = F.AgA_USA
     LEFT JOIN De_Pedimento Ped ON RIGHT(F.FEx_Pedimento, 7) = Ped.Pex_Folio
GROUP BY LEFT(F.FEx_Folio, 30);
go

-- CREATE UNIQUE CLUSTERED INDEX IVW_FACTEXPORT
--    ON GR_FACTIMPORT(Folio)
-- GO