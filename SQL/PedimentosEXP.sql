drop view if exists GR_PEDIMENTO_EXP;
GO
create table GR_PEDIMENTOEXP
(
    PE_PEDIMENTOEXP           VARCHAR(25)                not null
        constraint PEDIMENTOEXP__PK
            primary key,
    PE_CONSOLIDADO CHAR(2) DEFAULT 'NO',
    PE_FECHAINICIAL           DATETIME,
    PE_FECHAFINAL             DATETIME,
    PE_ACUSERECIBO            VARCHAR(10),
    PE_ADV                    NUMERIC(18, 6) default 0,
    PE_DTA                    NUMERIC(18, 6) default 0,
    PE_IVA                    NUMERIC(18, 6) default 0,
    PE_IMPORTE                NUMERIC(18, 6) default 0,
    PE_TCAMBIO                NUMERIC(18, 6) default 0,
    PE_CLVADUANA              CHAR(3),
    PE_AGPATENTE              VARCHAR(10),
    PE_OBSERVACIONES text,
    PE_CLVPEDIMENTO           VARCHAR(4),
    PE_FECHARECT              DATETIME,
    PE_OTROS                  NUMERIC(18, 6) default 0,
    PE_AGENTERFC              VARCHAR(13),
    PE_VALORADUANA            NUMERIC(18, 6) default 0,
    PE_FECHAPAGO              DATETIME,
    PE_ACTRECARGOS            NUMERIC(18, 6) default 0,
    PE_PREVALIDADOR           NUMERIC(18, 6) default 0,
    PE_MULTAS                 NUMERIC(18, 6) default 0,
    PE_ART303                 NUMERIC(18, 6) default 0,
    PE_FP_IGIIGE              CHAR(3),
    PE_FP_DTA                 CHAR(3),
    PE_FP_A303                CHAR(3),
    PE_FP_PRV                 CHAR(3),
    PE_FP_REC                 CHAR(3),
    PE_FP_MULT                CHAR(3),
    PE_FP_IVA                 CHAR(3),
    PE_FP_OTROS               CHAR(3),
    PE_TIPODOCUMENTO          VARCHAR(30),
    PE_IVA_PREVALIDACION      NUMERIC(18, 6) default 0,
    PE_CONTRAPRESTACION       NUMERIC(18, 6) default 0,
    PE_IVA_CONTRAPRESTACION   NUMERIC(18, 6) default 0,
    PE_FPIVA_PREVALIDACION    CHAR(3),
    PE_FPCONTRAPRESTACION     CHAR(3),
    PE_FPIVA_CONTRAPRESTACION CHAR(3)
);
GO
INSERT INTO GR_PEDIMENTOEXP(
                            PE_PEDIMENTOEXP, PE_FECHAINICIAL, PE_FECHAFINAL,
                            PE_CONSOLIDADO, PE_ADV, PE_IVA, PE_IMPORTE, PE_OBSERVACIONES,
                            PE_TCAMBIO, PE_CLVADUANA, PE_AGPATENTE, PE_CLVPEDIMENTO,
                            PE_AGENTERFC, PE_VALORADUANA, PE_FECHAPAGO)
select
        CONCAT(
           right(YEAR(pe.Pex_FechaPago), 2), ' ',
           left(pe.Adu_AduanaSecc, 2), ' ',
           pe.AgP_Patente, ' ',
           pe.Pex_Folio
       ) AS Clave,
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