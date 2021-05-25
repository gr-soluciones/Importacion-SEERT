drop view if exists GR_PEDIMENTO_IMP;
GO
create view GR_PEDIMENTO_IMP AS
select
    CONCAT(
               right(YEAR(PI.Pim_FechaPago), 2), ' ',
               left(pi.Adu_AduanaSecc, 2), ' ',
               pi.AgP_Patente, ' ',
               pi.Pim_Folio
           ) AS Clave,
       ISNULL(MAX(pis.Psa_FechaEntrada), MAX(pi.Pim_FechaIni)) AS Ini,
       ISNULL(MAX(pis.Psa_FechaVencimiento), MAX(pi.Pim_FechaFin)) AS FechaCaducidad,
       MAX(pi.Pim_FechaFin) AS FechaFinal,
       MAX(pi.Pim_TipoCambio) AS TCambio,
       MAX(pi.Pim_CostoTotMN) AS Importe,
       -- ADV
        SUM((pid.Pid_TasaAdv * pid.Pid_CostoTotMN)/100) AS ADV,
       -- El Derecho de Trámite Aduanero (DTA)
       SUM(pid.Pid_PagoIVAMN) AS IVA,
       pi.Adu_AduanaSecc AS ClvAduana,
       pi.AgP_Patente AS AgPatente,
       0 AS Status,
       -- SI,NO AS Consolidado
       MAX(pi.Pim_Observa) AS Notas,
       -- Rectificaciones
       -- AS AcuseRecibo
       -- TipoImp (T1 Equipo, T2 Temporal)
       MAX(pi.ClP_Clave) AS ClvPedimento,
       -- permanencia,
       -- Adquirio IND (IMMEX, Extranjero)
       -- Fecha Rect
       IIF(MAX(pid.Pid_PagoIGIMN) > 0, 'SI', 'NO') AS ImpIgiPagado,
       -- Otros -> 0
       MAX(ap.AgP_Rfc) AS AgenteRFC,
       MAX(pi.Pim_ValorAdu) AS ValorAduana,
       MAX(pi.Pim_FechaPago) AS FechaPAgo
       -- ActRecargos
       -- Prevalidador
       -- Multas
       -- Art303
       -- FP_IGIE
       -- FP_DTA
       -- FP_A303
       -- FP_PRV
       -- FP_REC
       -- FP_MULT
       -- FP_IVA
       -- FP_OTROS
       -- TipoDoc
       -- IVA prevalidacion
       -- Contraprestacion
       -- pi.Pim_TipoDoc -- TipoDocumento


FROM Di_Pedimento as pi
LEFT JOIN Di_PedimentoSaldo pis on pi.Pim_Consecutivo = pis.Pim_Consecutivo
LEFT JOIN Di_PedimentoDet pid on pi.Pim_Consecutivo = pid.Pim_Consecutivo
LEFT JOIN Ca_AgenciaPatente ap on pi.AgP_Patente = ap.AgP_Patente
-- Di_PedCons -> para el Acuse de recibo (Tabla sin datos)

GROUP BY pi.Pim_FechaPago, pi.Adu_AduanaSecc, pi.AgP_Patente, pi.Pim_Folio;