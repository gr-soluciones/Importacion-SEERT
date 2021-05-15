DROP VIEW IF EXISTS GR_PRODUCTOS_fix_NPARTE;
GO
CREATE VIEW GR_PRODUCTOS_fix_NPARTE AS
SELECT
    IIF(
        LEN(P.Par_NoParte) >= 30,
        SUBSTRING(master.dbo.fn_varbintohexstr(HASHBYTES('MD5', Par_NoParte)), 3, 30),
        P.Par_NoParte
    ) AS NPArte,
    Max(P.Par_DescripcionEsp) AS DescEsp,
    Max(P.Par_DescripcionIng) AS DescIng,
    CASE
        WHEN Max(P.Tim_Clave) = 'DESMP' THEN 'PRO'
        WHEN Max(P.Tim_Clave) = 'EQ' THEN 'ACT'
        WHEN Max(P.Tim_Clave) = 'MAQ' THEN 'ACT'
        WHEN Max(P.Tim_Clave) = 'MP' THEN 'MAT'
        WHEN Max(P.Tim_Clave) = 'PT' THEN 'PRO'
        WHEN Max(P.Tim_Clave) = 'SUB' THEN 'PRO'
        ELSE 'MAT'
    END Tipo,
    CASE
        WHEN Max(P.Tim_Clave) = 'EQ' THEN 'Equipo'
        WHEN Max(P.Tim_Clave) = 'MAQ' THEN 'Maquinaria'
        WHEN Max(P.Tim_Clave) = 'MP' THEN 'Materias Primas'
        WHEN Max(P.Tim_Clave) = 'PT' THEN 'Producto Terminado'
        WHEN Max(P.Tim_Clave) = 'SUB' THEN 'Subensamble'
    END TipoParte,
    Max(P.Med_Clave) AS UM,
    IsNull(Max(Ca_FArancelaria.Med_Clave), Max(P.Med_Clave)) AS UMedidaFraccion,
    IIf(
        Max(vf.Fra_FraccionMex) IS NULL
        Or Max(vf.Fra_FraccionMex) = '',
        CONCAT('__', Min(P.Par_Consecutivo)),
        Max(vf.Fra_FraccionMex)
    ) AS FracMex,
    IIf(
        Max([Fra_FraccionUsa1]) = ''
        Or Max([Fra_FraccionUsa1]) IS NULL,
        Max([Fra_FraccionUsa2]),
        Max([Fra_FraccionUsa1])
    ) AS ArancelUs,
    Avg(P.Par_FactConvCom) AS FactConv,
    'Importado desde el sistema SEERT' AS Nota,
    'NO' AS Desp,
    'NO' AS Merm
FROM
    Ca_Parte AS P
    LEFT JOIN vFracciones AS vf ON P.Par_Consecutivo = vf.Par_Consecutivo
    LEFT JOIN Ca_FArancelaria ON vf.Fra_FraccionMex = Ca_FArancelaria.Fra_Fraccion
GROUP BY
    P.Par_NoParte;