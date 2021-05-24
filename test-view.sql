DROP VIEW IF EXISTS GR_ELEM_FACTEXPORT;
GO
CREATE VIEW GR_ELEM_FACTEXPORT WITH SCHEMABINDING AS
    SELECT
    dbo.De_Factura.FEx_Folio,
    dbo.De_FacturaDet.Fed_NoParte,
    CASE
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'EQ' THEN 'Retorno'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'MAQ' THEN 'Retorno'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'MP' THEN 'Mismo Estado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'SUB' THEN 'Producto Terminado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'DESMP' THEN 'Producto Terminado'
    END AS TipoMatExp,
    CASE
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'DESMP' THEN 'PRO'
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'EQ' THEN 'ACT'
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'MAQ' THEN 'ACT'
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'MP' THEN 'MAT'
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'PT' THEN 'PRO'
        WHEN (MAX(dbo.De_FacturaDet.TiM_Clave)) = 'SUB' THEN 'PRO'
        ELSE 'MAT'
    END AS NPTipo,
    MAX(dbo.De_FacturaDet.TiM_Clave) AS TiM_Clave,
    MAX(dbo.De_FacturaDet.Fed_DescripcionEsp) AS Fed_DescripcionEsp,
--     MAX(dbo.De_FacturaDetUSA.Fed_DescripcionIng) AS Fed_DescripcionIng,
    SUM(dbo.De_FacturaDet.Fed_Cantidad) AS Fed_Cantidad,
    SUM(dbo.De_FacturaDet.Fed_PesoUnit) AS Fed_PesoUnit,
    SUM(dbo.De_FacturaDet.Fed_PesoNeto) AS Fed_PesoNeto,
    SUM(dbo.De_FacturaDet.Fed_PesoBru) AS Fed_PesoBru,
    COALESCE(MAX(dbo.De_PedimentoDet.Fra_FraccionUSA), '99999999') AS FRACUSA,
    COALESCE(MAX(dbo.De_PedimentoDet.Fra_Fraccion), '88888888') AS FRACCMX,
    MAX(dbo.De_FacturaDet.Med_Clave) AS Med_Clave,
    MAX(dbo.De_PedimentoDet.Med_Fraccion) AS Med_Fraccion,
    MAX(dbo.De_PedimentoDet.Ped_FactConvMx) AS Ped_FactConvMx,
    AVG(dbo.De_PedimentoDet.Ped_FactConvCom) AS Ped_FactConvCom,
    MAX(dbo.De_PedimentoDet.Ped_TipoTasaExp) AS Ped_TipoTasaExp,
    AVG(dbo.De_PedimentoDet.Ped_TasaAdv) AS Ped_TasaAdv,
    MAX(dbo.De_PedimentoDet.Pai_Origen) AS Pai_Origen,
    MAX(dbo.De_PedimentoDet.Pai_Destino) AS Pai_Destino,
    MAX(dbo.De_PedimentoDet.Pai_Comprador) AS Pai_Comprador,
    RIGHT(YEAR(MAX(dbo.De_Pedimento.Pex_FechaPago)), 2) + ' ' + LEFT(MAX(dbo.De_Pedimento.Adu_AduanaSecc), 2) + ' ' + MAX(dbo.De_Pedimento.AgP_Patente) + ' ' + MAX(dbo.De_Pedimento.Pex_Folio) AS NPedimentoExpGr,
    MAX(dbo.De_Pedimento.Pex_FechaPago) AS Pex_FechaPago,
    MAX(dbo.De_PedimentoDet.Ped_Secuencia) AS Ped_Secuencia,
    SUM(dbo.De_PedimentoDet.Ped_CostoUnit) AS Ped_CostoUnit,
    SUM(dbo.De_PedimentoDet.Ped_CostoUnitCom) AS Ped_CostoUnitCom,
    SUM(dbo.De_PedimentoDet.Ped_CostoUnitVA) AS Ped_CostoUnitVA,
    SUM(dbo.De_PedimentoDet.Ped_CostoTotUSD) AS Ped_CostoTotUSD,
    SUM(
        IIF(dbo.De_PedimentoDet.Ped_CostoUnit = 0 or (dbo.De_PedimentoDet.Ped_CostoUnitAdu / dbo.De_PedimentoDet.Ped_CostoUnit) = 0,
            0,
            dbo.De_PedimentoDet.Ped_CostoUnitVA /(
            dbo.De_PedimentoDet.Ped_CostoUnitAdu / dbo.De_PedimentoDet.Ped_CostoUnit
        ))
    ) AS LABOR,
    SUM(
        IIF(dbo.De_PedimentoDet.Ped_CostoUnit = 0 or (dbo.De_PedimentoDet.Ped_CostoUnitAdu / dbo.De_PedimentoDet.Ped_CostoUnit) = 0,
            0,
        dbo.De_PedimentoDet.Ped_CostoUnit - (
            dbo.De_PedimentoDet.Ped_CostoUnitVA /(
                dbo.De_PedimentoDet.Ped_CostoUnitAdu / dbo.De_PedimentoDet.Ped_CostoUnit
            )
        )
            )
    ) AS MATGRAB
FROM
    dbo.De_FacturaDet
    INNER JOIN dbo.De_Factura ON (
        dbo.De_FacturaDet.Fex_Consecutivo = dbo.De_Factura.FEx_Consecutivo
    )
--     LEFT JOIN dbo.De_FacturaDetUSA ON (
--         dbo.De_FacturaDet.Fex_Consecutivo = dbo.De_FacturaDetUSA.Fex_Consecutivo
--     )
    INNER JOIN dbo.De_PedimentoDet ON (
        dbo.De_FacturaDet.Fex_Consecutivo = dbo.De_PedimentoDet.Fex_Consecutivo
    )
    INNER JOIN dbo.De_Pedimento ON(
        dbo.De_PedimentoDet.Pex_Consecutivo = dbo.De_Pedimento.Pex_Consecutivo
    )
    GROUP BY dbo.De_Factura.FEx_Folio,
    dbo.De_FacturaDet.Fed_NoParte,
    CASE
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'EQ' THEN 'Retorno'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'MAQ' THEN 'Retorno'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'MP' THEN 'Mismo Estado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'SUB' THEN 'Producto Terminado'
        WHEN (dbo.De_FacturaDet.TiM_Clave) = 'DESMP' THEN 'Producto Terminado'
    END
--     ORDER BY FEx_Folio
--     OFFSET 22200 ROWS FETCH NEXT 10000 ROWS ONLY;
-- GO
-- CREATE UNIQUE CLUSTERED INDEX IDX_GR_ELEM_FACT_EXP_P32200
--    ON GR_ELEM_FACT_EXP_P32200 (FEx_Folio, Fed_NoParte, TipoMatExp);
-- GO