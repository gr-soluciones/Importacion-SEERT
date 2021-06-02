DROP VIEW IF EXISTS GR_FACTIMPORT;
GO
CREATE VIEW GR_FACTIMPORT AS
select
       LEFT(F.FIm_Folio, 30) AS Folio,
       MAX(F.FIm_Fecha) AS Fecha,
       MAX(F.FIm_TipoCambioUsd) AS TCambio,
       MAX(LEFT(C.RFC, 13)) AS Importador,
       MAX(LEFT(cE.RFC, 13)) AS Exportador,
       MAX(LEFT(aMX.RFC, 13)) AS AgenciaMX,
       MAX(LEFT(aUSA.RFC, 13)) AS AgenciaUSA,
       MAX(LEFT(F.FIm_VehPlacasMx, 20)) AS PlacasMx,
       MAX(LEFT(F.FIm_VehPlacasUSA, 20)) AS PlacasUSA,
       MAX(LEFT(F.Ite_Clave, 3)) AS Intercom,
       MAX(right(year(Ped.[Pim_FechaPago]),2)+' '+left(Ped.[Adu_AduanaSecc],2)+' '+Ped.[AgP_Patente]+' '+Ped.[Pim_Folio]) AS Pedimento,
       MAX(Ped.Pim_FechaIni) AS FechaPedimento
       -- ,F.*
from
     dbo.Di_Factura F
     LEFT JOIN dbo.GR_CLIENTES_MAX C ON (F.Cli_Importador = C.NombreCorto) or (F.Cli_Importador = C.RazonSocial)
     LEFT JOIN dbo.GR_CLIENTES_MAX cE ON (F.Cli_Exportador = cE.NombreCorto) or (F.Cli_Exportador = cE.RazonSocial)
     LEFT JOIN dbo.GR_Agencia aMX ON aMX.AgA_Corto = F.AgA_Mex
     LEFT JOIN dbo.GR_Agencia aUSA ON aUSA.AgA_Corto = F.AgA_USA
     LEFT JOIN Di_Pedimento Ped ON RIGHT(F.FIm_Pedimento, 7) = Ped.Pim_Folio
GROUP BY LEFT(F.FIm_Folio, 30);