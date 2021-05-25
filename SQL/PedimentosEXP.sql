drop view if exists GR_PEDIMENTO_EXP;
GO
create view GR_PEDIMENTO_EXP AS
select
    CONCAT(
               right(YEAR(pe.Pex_FechaPago), 2), ' ',
               left(pe.Adu_AduanaSecc, 2), ' ',
               pe.AgP_Patente, ' ',
               pe.Pex_Folio
           )) AS Clave,
       ISNULL(MAX(pe.Pex_FechaIni), MAX(pe.Pex_FechaIni)) AS FechaIni,
       MAX(pe.Pex_FechaFin) AS FechaFin,
       IIF(MAX(pe.Pex_Consolidado) = 'S', 'SI', 'NO') AS Consolidado,
       SUM((ped.Ped_TasaAdv * ped.Ped_CostoTotMN)/100) AS ADV,
       SUM(ped.Ped_PagoIVAMN) AS IVA,
       MAX(pe.Pex_CostoTotMN) AS Importe,
       MAX(pe.Pex_Observa) AS Observaciones,
       MAX(pe.Pex_TipoCambio) AS TCambio,
       pe.Adu_AduanaSecc AS ClvAduana,
       pe.AgP_Patente AS AgPatente,
       MAX(pe.ClP_Clave) AS ClvPedimento,
       MAX(ap.AgP_Rfc) AS AgenteRFC,
       MAX(pe.Pex_ValorAdu) AS ValorAduana,
       MAX(pe.Pex_FechaPago) AS FechaPAgo

FROM De_Pedimento as pe
LEFT JOIN De_PedimentoDet ped on pe.Pex_Consecutivo = ped.Pex_Consecutivo
LEFT JOIN Ca_AgenciaPatente ap on pe.AgP_Patente = ap.AgP_Patente

GROUP BY pe.Pex_FechaPago, pe.Adu_AduanaSecc, pe.AgP_Patente, pe.Pex_Folio;