drop view if exists GR_Agencia;
GO
create view GR_Agencia AS
SELECT
       Ca_Agencia.AgA_Corto,
       Ca_Agencia.AgA_RazonSocial,
       Ca_Agencia.AgA_Calle AS Direccion,
       Ca_Agencia.AgA_Colonia,
       Ca_Agencia.AgA_Ciudad,
       Ca_Agencia.Pai_Clave,
       IIf(
            Ca_AgenciaPatente.AgP_Rfc IS NULL,
           IIF(
               Ca_Agencia.AgA_Rfc_Irs IS NULL Or
               TRIM(Ca_Agencia.AgA_Rfc_Irs) IN ('XEXX010101000', ''),
               CAST(Ca_Agencia.AgA_Consecutivo AS VARCHAR),
               Ca_Agencia.AgA_Rfc_Irs),
           Ca_AgenciaPatente.AgP_Rfc) AS RFC,
       Ca_AgenciaPatente.AgP_Patente AS Patente
FROM
     Ca_Agencia
     LEFT JOIN Ca_AgenciaPatente ON Ca_AgenciaPatente.AgA_Consecutivo = Ca_Agencia.AgA_Consecutivo;