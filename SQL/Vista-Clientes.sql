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