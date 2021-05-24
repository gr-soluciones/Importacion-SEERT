DROP VIEW IF EXISTS GR_ELEM_FACTEXPORT;
go
CREATE VIEW GR_ELEM_FACTEXPORT AS
SELECT
    De_Factura.FEx_Folio,
    De_FacturaDet.Fed_NoParte,
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
    MAX(De_FacturaDet.TiM_Clave) AS TiM_Clave,
    MAX(De_FacturaDet.Fed_DescripcionEsp) AS Fed_DescripcionEsp,
    MAX(De_FacturaDetUSA.Fed_DescripcionIng) AS Fed_DescripcionIng,
    SUM(De_FacturaDet.Fed_Cantidad) AS Fed_Cantidad,
    SUM(De_FacturaDet.Fed_PesoUnit) AS Fed_PesoUnit,
    SUM(De_FacturaDet.Fed_PesoNeto) AS Fed_PesoNeto,
    SUM(De_FacturaDet.Fed_PesoBru) AS Fed_PesoBru,
    COALESCE(MAX(De_PedimentoDet.Fra_FraccionUSA), '99999999') AS FRACUSA,
    COALESCE(MAX(De_PedimentoDet.Fra_Fraccion), '88888888') AS FRACCMX,
    MAX(De_FacturaDet.Med_Clave) AS Med_Clave,
    MAX(De_PedimentoDet.Med_Fraccion) AS Med_Fraccion,
    MAX(De_PedimentoDet.Ped_FactConvMx) AS Ped_FactConvMx,
    AVG(De_PedimentoDet.Ped_FactConvCom) AS Ped_FactConvCom,
    MAX(De_PedimentoDet.Ped_TipoTasaExp) AS Ped_TipoTasaExp,
    AVG(De_PedimentoDet.Ped_TasaAdv) AS Ped_TasaAdv,
    MAX(De_PedimentoDet.Pai_Origen) AS Pai_Origen,
    MAX(De_PedimentoDet.Pai_Destino) AS Pai_Destino,
    MAX(De_PedimentoDet.Pai_Comprador) AS Pai_Comprador,
    RIGHT(YEAR(MAX(De_Pedimento.Pex_FechaPago)), 2) + ' ' + LEFT(MAX(De_Pedimento.Adu_AduanaSecc), 2) + ' ' + MAX(De_Pedimento.AgP_Patente) + ' ' + MAX(De_Pedimento.Pex_Folio) AS NPedimentoExpGr,
    MAX(De_Pedimento.Pex_FechaPago) AS Pex_FechaPago,
    MAX(De_PedimentoDet.Ped_Secuencia) AS Ped_Secuencia,
    SUM(De_PedimentoDet.Ped_CostoUnit) AS Ped_CostoUnit,
    SUM(De_PedimentoDet.Ped_CostoUnitCom) AS Ped_CostoUnitCom,
    SUM(De_PedimentoDet.Ped_CostoUnitVA) AS Ped_CostoUnitVA,
    SUM(De_PedimentoDet.Ped_CostoTotUSD) AS Ped_CostoTotUSD,
    SUM(
        IIF(De_PedimentoDet.Ped_CostoUnit = 0 or (De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit) = 0,
            0,
            De_PedimentoDet.Ped_CostoUnitVA /(
            De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit
        ))
    ) AS LABOR,
    SUM(
        IIF(De_PedimentoDet.Ped_CostoUnit = 0 or (De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit) = 0,
            0,
        De_PedimentoDet.Ped_CostoUnit - (
            De_PedimentoDet.Ped_CostoUnitVA /(
                De_PedimentoDet.Ped_CostoUnitAdu / De_PedimentoDet.Ped_CostoUnit
            )
        )
            )
    ) AS MATGRAB
FROM
    De_FacturaDet
    INNER JOIN De_Factura ON (
        De_FacturaDet.Fex_Consecutivo = De_Factura.FEx_Consecutivo
    )
    LEFT JOIN De_FacturaDetUSA ON (
        De_FacturaDet.Fex_Consecutivo = De_FacturaDetUSA.Fex_Consecutivo
    )
    INNER JOIN De_PedimentoDet ON (
        De_FacturaDet.Fex_Consecutivo = De_PedimentoDet.Fex_Consecutivo
    )
    INNER JOIN De_Pedimento ON(
        De_PedimentoDet.Pex_Consecutivo = De_Pedimento.Pex_Consecutivo
    ) GROUP BY De_Factura.FEx_Folio,
    De_FacturaDet.Fed_NoParte,
    CASE
        WHEN (De_FacturaDet.TiM_Clave) = 'EQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MAQ' THEN 'Retorno'
        WHEN (De_FacturaDet.TiM_Clave) = 'MP' THEN 'Mismo Estado'
        WHEN (De_FacturaDet.TiM_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'SUB' THEN 'Producto Terminado'
        WHEN (De_FacturaDet.TiM_Clave) = 'DESMP' THEN 'Producto Terminado'
    END
-- WHERE De_FacturaDet.Fex_Consecutivo IS NULL