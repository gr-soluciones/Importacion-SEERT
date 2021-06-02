DROP VIEW IF EXISTS GR_CLIENTES;
go
CREATE VIEW GR_CLIENTES AS
SELECT
  CAST(MAX(Ca_Cliente.Cli_Corto) as varchar) AS Nombre,
  CAST(
      IIf(
    Min(Ca_ClientePermiso.ClP_Valor) IS NULL
    Or Min(Ca_ClientePermiso.ClP_Valor) = '',
    cast(MAX(Ca_ClientePermiso.Cli_Consecutivo) AS varchar),
    MIN(Ca_ClientePermiso.ClP_Valor)
    )
  AS varchar) AS RFC,
  CAST(IIF(
    Max(Cli_TipoEmpresa) = 'EXTRANJERA',
    'Extranjero',
    IIf(Max(Cli_TipoEmpresa) = 'IMMEX', 'Nacional', Null)
  ) AS varchar) AS ORIGEN,
  CAST(IIf(Max(Cli_TipoProvee) = 'P', 'Proveedor', 'Cliente') AS varchar) AS Tipo,
  CAST(Max(Ca_ClienteDireccion.Dir_Calle) AS varchar) AS MaxOfDir_Calle,
  CAST(Max(Ca_ClienteDireccion.Dir_NoExt) AS varchar) AS MaxOfDir_NoExt,
  CAST(Max(Ca_ClienteDireccion.Dir_NoInt) AS varchar) AS MaxOfDir_NoInt,
  CAST(Max(Ca_ClienteDireccion.Dir_Colonia) AS varchar) AS MaxOfDir_Colonia,
  CAST(Max(Ca_ClienteDireccion.Dir_Ciudad) AS varchar) AS MaxOfDir_Ciudad,
  CAST(Max(Ca_ClienteDireccion.Pai_Clave) AS varchar) AS MaxOfPai_Clave,
  CAST(Max(Ca_ClienteDireccion.Edo_Clave) AS varchar) AS MaxOfEdo_Clave,
  CAST(Max(Ca_ClienteDireccion.Dir_Telefono) AS varchar) AS MaxOfDir_Telefono,
  CAST(Max(Ca_ClienteDireccion.Dir_FAX) AS varchar) AS MaxOfDir_FAX
FROM
    Ca_Cliente
    INNER JOIN Ca_ClientePermiso ON Ca_Cliente.Cli_Consecutivo = Ca_ClientePermiso.Cli_Consecutivo
  LEFT JOIN Ca_ClienteDireccion ON Ca_Cliente.Cli_Consecutivo = Ca_ClienteDireccion.Cli_Consecutivo
WHERE
      Ca_ClientePermiso.ReP_Clave In ('RFC', 'IRS')
GROUP BY
  IIf(
    Ca_ClientePermiso.ClP_Valor IS NULL
    Or Ca_ClientePermiso.ClP_Valor = '',
    cast(Ca_ClientePermiso.Cli_Consecutivo AS varchar),
    Ca_ClientePermiso.ClP_Valor
    )

DROP VIEW IF EXISTS GR_CLIENTES_MAX;
go
CREATE VIEW GR_CLIENTES_MAX AS
SELECT
       D.Dir_Consecutivo,
       c.Cli_Corto AS NombreCorto,
       c.Cli_Razon AS RazonSocial,
       ISNULL(
           IIF(
               LEN(TRIM(RFCS.ClP_Valor)) = 0,
               CAST(c.Cli_Consecutivo AS VARCHAR),
               TRIM(RFCS.ClP_Valor)
               ),
           CAST(c.Cli_Consecutivo AS VARCHAR)
           ) AS RFC,
       IIF(
           c.Cli_TipoEmpresa = 'EXTRANJERA',
           'Extranjero',
           IIf(c.Cli_TipoEmpresa = 'IMMEX',
               'Nacional',
               Null
               )
           ) AS ORIGEN,
       IIf(c.Cli_TipoProvee = 'P',
           'Proveedor',
           'Cliente'
           ) AS Tipo,
       d.Dir_Calle AS Calle,
       d.Dir_NoExt AS NoExt,
       d.Dir_NoInt AS NoInt,
       d.Dir_Colonia AS Colonia,
       d.Dir_Ciudad AS Ciudad,
       d.Pai_Clave AS Pais,
       d.Edo_Clave AS Estado,
       d.Dir_Telefono AS Telefono,
       d.Dir_FAX AS FAX
FROM
    (
        Ca_Cliente c
        LEFT JOIN Ca_ClienteDireccion d ON c.Cli_Consecutivo = d.Cli_Consecutivo
    )
    LEFT JOIN (
        SELECT
               P.Cli_Consecutivo,
               P.ClP_Valor
        FROM Ca_ClientePermiso P WHERE P.ReP_Clave = 'RFC'
        UNION
        SELECT
               P.Cli_Consecutivo,
               P.ClP_Valor
        FROM Ca_ClientePermiso P WHERE P.ReP_Clave = 'IRS'
        ) AS RFCs ON c.Cli_Consecutivo = RFCS.Cli_Consecutivo;