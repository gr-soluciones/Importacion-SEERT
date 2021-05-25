DROP VIEW IF EXISTS GR_FRACCIONES;
GO
CREATE VIEW GR_FRACCIONES AS
SELECT
  cast(max(fa.Fra_Fraccion) as varchar) AS Fraccion,
  cast(max(fa.Fra_DescripcionOfi) as varchar) AS Descripcion,
  cast(min(fa.Pai_Clave) as varchar) AS Pais,
  cast(IIf(
    min(fa.Pai_Clave) <> 'MEX',
    'IMPORTACION',
    'EXPORTACION'
  ) as varchar) AS TIPO,
  cast(max(fa.Med_Clave) as varchar) AS Medida,
  cast('Importado desde el sistema SEERT' as varchar) AS Nota
FROM
  Ca_FArancelaria AS fa
GROUP BY
  fa.Fra_Fraccion
HAVING
  fa.Fra_Fraccion IS NOT NULL;