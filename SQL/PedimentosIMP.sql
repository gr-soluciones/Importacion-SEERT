drop view if exists GR_PEDIMENTO_IMP;
GO
create table GR_PEDIMENTOIMP
(
    PI_PEDIMENTOIMP           VARCHAR(25)                not null,
    PI_FCADUCIDAD             DATETIME              not null,
    PI_FECHAINICIAL           DATETIME,
    PI_FECHAFINAL             DATETIME,
    PI_TCAMBIO                NUMERIC(18, 6) default 0,
    PI_IMPORTE                NUMERIC(18, 6) default 0,
    PI_ADV                    NUMERIC(18, 6) default 0,
    PI_DTA                    NUMERIC(18, 6) default 0,
    PI_IVA                    NUMERIC(18, 6) default 0,
    PI_CLVADUANA              CHAR(3),
    PI_AGPATENTE              VARCHAR(10),
    PI_STATUS                 NUMERIC(18, 6) default 0,
    PI_CONSOLIDADO            CHAR(2)       default 'NO' not null,
    PI_NOTAS                  TEXT,
    PI_RECTIFICACIONES        TEXT,
    PI_ACUSERECIBO            VARCHAR(10),
    PI_TIPOIMP                VARCHAR(20),
    PI_CLVPEDIMENTO           VARCHAR(4),
    PI_PERMANENCIA            SMALLINT,
    PI_ADQUIRIDOIND           VARCHAR(40),
    PI_FECHARECT              DATETIME,
    PI_IMPIGIPAGADO           CHAR(2)       default 'NO' not null,
    PI_OTROS                  NUMERIC(18, 6) default 0,
    PI_AGENTERFC              VARCHAR(13),
    PI_VALORADUANA            NUMERIC(18, 6) default 0,
    PI_FECHAPAGO              DATETIME,
    PI_ACTRECARGOS            NUMERIC(18, 6) default 0,
    PI_PREVALIDADOR           NUMERIC(18, 6) default 0,
    PI_MULTAS                 NUMERIC(18, 6) default 0,
    PI_ART303                 NUMERIC(18, 6) default 0,
    PI_FP_IGIIGE              CHAR(3),
    PI_FP_DTA                 CHAR(3),
    PI_FP_A303                CHAR(3),
    PI_FP_PRV                 CHAR(3),
    PI_FP_REC                 CHAR(3),
    PI_FP_MULT                CHAR(3),
    PI_FP_IVA                 CHAR(3),
    PI_FP_OTROS               CHAR(3),
    PI_TIPODOCUMENTO          VARCHAR(30),
    PI_IVA_PREVALIDACION      NUMERIC(18, 6) default 0,
    PI_CONTRAPRESTACION       NUMERIC(18, 6) default 0,
    PI_IVA_CONTRAPRESTACION   NUMERIC(18, 6) default 0,
    PI_FPIVA_PREVALIDACION    CHAR(3),
    PI_FPCONTRAPRESTACION     CHAR(3),
    PI_FPIVA_CONTRAPRESTACION CHAR(3),
    constraint PEDIMENTOIMP_PK
        primary key (PI_PEDIMENTOIMP, PI_FCADUCIDAD)
);

INSERT INTO GR_PEDIMENTOIMP(
                            PI_PEDIMENTOIMP, PI_FECHAINICIAL, PI_FCADUCIDAD,
                            PI_FECHAFINAL, PI_TCAMBIO, PI_IMPORTE, PI_ADV, PI_IVA,
                            PI_CLVADUANA, PI_AGPATENTE, PI_STATUS, PI_NOTAS, PI_CLVPEDIMENTO,
                            PI_IMPIGIPAGADO, PI_AGENTERFC, PI_VALORADUANA, PI_FECHAPAGO
)
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
       MAX(ag.RFC) AS AgenteRFC,
       MAX(pi.Pim_ValorAdu) AS ValorAduana,
       MAX(pi.Pim_FechaPago) AS FechaPAgo
--        MAX(importador.RFC) AS Importador,
--        MAX(provee.RFC) AS Proveedor,
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
-- LEFT JOIN GR_CLIENTES_MAX importador on importador.Dir_Consecutivo = pi.Dir_Importador
-- LEFT JOIN GR_CLIENTES_MAX provee on provee.Dir_Consecutivo = pi.Dir_Proveedor
LEFT JOIN dbo.GR_Agencia ag ON ag.Patente = pi.AgP_Patente
-- Di_PedCons -> para el Acuse de recibo (Tabla sin datos)


GROUP BY pi.Pim_FechaPago, pi.Adu_AduanaSecc, pi.AgP_Patente, pi.Pim_Folio;

select count(*)
from GR_PEDIMENTOIMP ;

select count(*)
from Di_Pedimento;