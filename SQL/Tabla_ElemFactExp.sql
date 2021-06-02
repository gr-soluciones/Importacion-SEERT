-- Otras funciones
-- EXECUTE sp_helpindex GR_ELEMFACTEXP;
-- sp_who2
-- TRUNCATE TABLE GR_ELEMFACTEXP;

-- Crear Tabla
drop table if exists GR_ELEMFACTEXP;
go
create table GR_ELEMFACTEXP
(
    _Fex_Consecutivo int,
    _Fed_Consecutivo int,
    EE_NFACTEXP        VARCHAR(30)                not null,
    EE_NPARTE          VARCHAR(30)                not null,
    EE_TIPOMATEXP      VARCHAR(20)                not null,
    EE_NPTIPO          CHAR(3),
    EE_DESCESP         VARCHAR(150),
    EE_DESCING         VARCHAR(150),
    EE_TOTALMAT        decimal(18, 6) default 0,
    EE_MATNONDUT       decimal(18, 6) default 0,
    EE_MATDUTIABLE     decimal(18, 6) default 0,
    EE_EMPNONDUT       decimal(18, 6) default 0,
    EE_EMPDUTIABLE     decimal(18, 6) default 0,
    EE_VALDUTIABLE     decimal(18, 6) default 0,
    EE_OTRDUTIABLE     decimal(18, 6) default 0,
    EE_EMPAQUE         VARCHAR(5),
    EE_PESOUNIT        decimal(18, 6) default 0,
    EE_PESOBRUTO       decimal(18, 6) default 0,
    EE_PESONETO        decimal(18, 6) default 0,
    EE_ARANCELUS       VARCHAR(10),
    EE_ARANCELMX       VARCHAR(10),
    EE_PESOEMPAQUE     decimal(18, 6) default 0,
    EE_CANTEMPAQUE     decimal(18, 6) default 0,
    EE_TIPOPARTE       VARCHAR(20),
    EE_UMPARTE         VARCHAR(5),
    EE_UMFRACCION      VARCHAR(5),
    EE_FCONVERSION     decimal(18, 6) default 0,
    EE_PAISDESTINO     VARCHAR(3),
    EE_DESTINO         VARCHAR(20),
    EE_NPARTEASOCIADO  VARCHAR(30),
    EE_PEDIMENTOEXP    VARCHAR(25),
    EE_FECHAPED        datetime,
    EE_NAFTA           CHAR(2)       default 'NO' not null,
    EE_PAISORIGEN      VARCHAR(3),
    EE_CLAVEFDA        CHAR(3),
    EE_COSTOHR         decimal(18, 6) default 0,
    EE_ESTANDARPROD    decimal(18, 6) default 0,
    EE_ENSAMBLADOMX    CHAR(2),
    EE_MATDUTUSD       decimal(18, 6) default 0,
    EE_MATDUTMN        decimal(18, 6) default 0,
    EE_MATNODUSD       decimal(18, 6) default 0,
    EE_MATNODMN        decimal(18, 6) default 0,
    EE_EMPUSD          decimal(18, 6) default 0,
    EE_EMPMN           decimal(18, 6) default 0,
    EE_AGREGUSD        decimal(18, 6) default 0,
    EE_AGREGMN         decimal(18, 6) default 0,
    EE_FPAGO           CHAR(3),
    EE_SECUENCIAPEDEXP INTEGER,
    constraint ELEMFACTEXP_PK
        primary key (EE_NFACTEXP, EE_NPARTE, EE_TIPOMATEXP)
);
go

-- peso bruto

-- Crear Registros
insert into GR_ELEMFACTEXP(_Fex_Consecutivo,
                           _Fed_Consecutivo,
                           EE_SECUENCIAPEDEXP,
                           EE_NFACTEXP, EE_NPARTE, EE_TIPOMATEXP, EE_NPTIPO,
                           EE_UMPARTE,
                           EE_DESCESP, EE_TOTALMAT,
                           EE_PESOUNIT,EE_PESOBRUTO, EE_PESONETO)
SELECT
       MAX(De_Factura.Fex_Consecutivo) AS _Fex_Consecutivo,
       MAX(Fed_Consecutivo) AS Fed_Consecutivo,
       MAX(De_FacturaDet.Fed_SecuenciaPed) AS EE_SECUENCIAPEDEXP,
    LEFT(De_Factura.FEx_Folio, 30),
    LEFT(De_FacturaDet.Fed_NoParte, 30),
    CASE
        WHEN (De_FacturaDet.TiM_Clave) = 'EQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MAQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MP' THEN 'Mismo Estado'
        WHEN (De_FacturaDet.TiM_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'SUB' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'DESMP' THEN 'Producto Terminado'
    END AS TipoMatExp,
    CASE
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'DESMP' THEN 'PRO'
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'EQ' THEN 'ACT'
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'MAQ' THEN 'ACT'
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'MP' THEN 'MAT'
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'PT' THEN 'PRO'
        WHEN (MAX(De_FacturaDet.TiM_Clave)) = 'SUB' THEN 'PRO'
        ELSE 'MAT'
    END AS NPTipo,
--     LEFT(MAX(De_FacturaDet.Med_Clave), 5),
    LEFT(UPPER(MAX(De_FacturaDet.Med_Clave)), 5) AS TiM_Clave,
    LEFT(MAX(De_FacturaDet.Fed_DescripcionEsp), 150) AS Fed_DescripcionEsp,
    SUM(De_FacturaDet.Fed_Cantidad) AS Fed_Cantidad,
    AVG(De_FacturaDet.Fed_PesoUnit) AS Fed_PesoUnit,
--        SUM(De_FacturaDet.Fed_PesoBru) AS Fed_PesoBru,
       0,
    SUM(De_FacturaDet.Fed_PesoNeto) AS Fed_PesoNeto
FROM
    De_FacturaDet
    INNER JOIN De_Factura ON (
        De_FacturaDet.Fex_Consecutivo = De_Factura.FEx_Consecutivo
    )
GROUP BY De_Factura.FEx_Folio,
    De_FacturaDet.Fed_NoParte,
    CASE
        WHEN (De_FacturaDet.TiM_Clave) = 'EQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MAQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MP' THEN 'Mismo Estado'
        WHEN (De_FacturaDet.TiM_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'SUB' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'DESMP' THEN 'Producto Terminado'
    END;
GO

-- Actualizar
UPDATE
    GR_ELEMFACTEXP
SET
    EE_DESCING = Fed_DescripcionIng
FROM GR_ELEMFACTEXP
    INNER JOIN
(
    select
           _Fed_Consecutivo,
        MAX(Fed_DescripcionIng) as Fed_DescripcionIng
     from
    GR_ELEMFACTEXP AS e
    INNER JOIN De_FacturaDetUSA ON (
        e._Fed_Consecutivo = De_FacturaDetUSA.Fed_Consecutivo
    ) GROUP BY _Fed_Consecutivo) AS T on t._Fed_Consecutivo = GR_ELEMFACTEXP._Fed_Consecutivo;

-- Actualizar 2
UPDATE
    GR_ELEMFACTEXP
SET
    EE_UMFRACCION = UPPER(MedFraccion),
    EE_ARANCELUS = FUSA,
    EE_ARANCELMX = FUMEX,
    EE_PAISORIGEN = PO,
    EE_PAISDESTINO = De,
    EE_PEDIMENTOEXP = FOL,
    EE_FECHAPED = FP,
    EE_VALDUTIABLE = VBL,
    EE_MATDUTIABLE = MBL
FROM
     GR_ELEMFACTEXP
     INNER JOIN (
         select
                Fed_Consecutivo as Fed_Consecutivo,

                MAX(De_PedimentoDet.Med_Fraccion) AS MedFraccion,
                COALESCE(MAX(De_PedimentoDet.Fra_FraccionUSA), '99999999') AS FUSA,
                COALESCE(MAX(Fra_Fraccion), '88888888') AS FUMEX,
                MAX(De_PedimentoDet.Pai_Origen) AS PO,
                MAX(De_PedimentoDet.Pai_Destino) AS De,
                RIGHT(YEAR(MAX(De_Pedimento.Pex_FechaPago)), 2) + ' ' + LEFT(MAX(De_Pedimento.Adu_AduanaSecc), 2) + ' ' + MAX(De_Pedimento.AgP_Patente) + ' ' + MAX(De_Pedimento.Pex_Folio) AS FOL,
                MAX(De_Pedimento.Pex_FechaPago) AS FP,

                AVG(
--                     De_PedimentoDet.Ped_CostoUnit,
                        De_PedimentoDet.Ped_CostoUnitVA / (
                            IIF(De_Pedimento.Pex_TipoCambio = 0,
                                IIF(De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit = 0, 1, De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit),
                                De_Pedimento.Pex_TipoCambio)
                            )
                    ) AS VBL,
                AVG(
                    De_PedimentoDet.Ped_CostoUnit - (
                            De_PedimentoDet.Ped_CostoUnitVA /(
                                IIF(De_Pedimento.Pex_TipoCambio = 0,
                                    IIF(De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit = 0, 1, De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit),
                                    De_Pedimento.Pex_TipoCambio)
                                )
                            )
                    ) AS MBL

         FROM
              GR_ELEMFACTEXP AS e
                  INNER JOIN De_PedimentoDet ON (
                      e._Fed_Consecutivo = De_PedimentoDet.Fed_Consecutivo
                      )
                  INNER JOIN De_Pedimento ON(
                      De_PedimentoDet.Pex_Consecutivo = De_Pedimento.Pex_Consecutivo
                      )
         GROUP BY Fed_Consecutivo
         ) AS TB ON TB.Fed_Consecutivo = _Fed_Consecutivo;


-- update
--     GR_ELEMFACTEXP
-- set EE_VALDUTIABLE = f.FEx_TipoCambioUSD
-- from GR_ELEMFACTEXP
-- inner join De_Factura f on f.FEx_Consecutivo = _Fex_Consecutivo
-- where GR_ELEMFACTEXP.EE_VALDUTIABLE = 0;

-- update
--     GR_ELEMFACTEXP
-- set EE_MATDUTIABLE = 1
-- where EE_MATDUTIABLE = 0;
--
-- select EE_MATDUTIABLE, * from GR_ELEMFACTEXP
-- inner join De_Factura f on f.FEx_Consecutivo = _Fex_Consecutivo
-- where GR_ELEMFACTEXP.EE_MATDUTIABLE = 0;