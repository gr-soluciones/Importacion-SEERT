DROP VIEW IF EXISTS GR_ELEM_FACTIMPORT;
GO
CREATE VIEW GR_ELEM_FACTIMPORT AS
SELECT
 Di_Factura.FIm_Folio,
 Di_FacturaDet.FId_NoParte,
 Di_FacturaDet.Pai_Clave,
 CASE
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'DESMP' THEN 'PRO'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'EQ' THEN 'ACT'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'MAQ' THEN 'ACT'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'MP' THEN 'MAT'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'PT'  THEN 'PRO'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'SUB' THEN 'PRO'
   ELSE 'MAT'
 END Tipo,
  CASE
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'EQ' THEN 'Equipo'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'MAQ' THEN 'Maquinaria'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'MP' THEN 'Materias Primas'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'PT' THEN 'Producto Terminado'
   WHEN (MAX(Di_FacturaDet.TiM_Clave)) = 'SUB' THEN 'Subensamble'
  END AS TipoParte,
 SUM(Di_FacturaDet.FId_CostoUnit) AS FId_CostoUnit,
 MAX(Di_FacturaDet.FId_DescripcionEsp) AS FId_DescripcionEsp,
 MAX(Di_FacturaDetUSA.FId_DescripcionIng) AS FId_DescripcionIng,
 MAX(Di_FacturaDet.Med_Clave) AS Med_Clave,
 MAX(Di_PedimentoDet.Med_Fraccion) AS Med_Fraccion,
 AVG(Di_PedimentoDet.Pid_FactConvMx) AS Pid_FactConvMx,
 COALESCE(MAX(Di_PedimentoDet.Fra_FraccionUSA),'99999999') AS FRACCUSA,
 COALESCE(MAX(Di_PedimentoDet.Fra_Fraccion),'88888888')  AS FRACCMEX,
--  MAX(Di_FacturaDet.Fra_ImpMX) AS Fra_ImpMX,
 MAX(Di_PedimentoDet.Pai_Vendedor) AS PaisProcedencia,
 SUM(Di_FacturaDet.FId_Cantidad) AS FId_Cantidad,
 SUM(Di_PedimentoSaldo.Psa_Saldo) AS Psa_Saldo,
 SUM(Di_FacturaDet.FId_PesoNeto) AS FId_PesoNeto,
 SUM(Di_FacturaDet.FId_PesoBru) AS FId_PesoBru,
 MAX(Di_Factura.FIm_Fecha) AS FactFecha,
--  MAX(Di_Factura.FIm_Fecha) AS FIm_Fecha,
 MAX(Di_PedimentoDet.Pid_FechaVencimiento31) AS Pid_FechaVencimiento31,
 RIGHT(YEAR(MAX(Di_Pedimento.Pim_FechaPago)),2)+' '+ LEFT(MAX(Di_Pedimento.Adu_AduanaSecc),2)+' '+MAX(Di_Pedimento.AgP_Patente)+' '+MAX(Di_Pedimento.Pim_Folio) AS NPedimentoGr,
--  MAX(Di_Pedimento.Pim_Folio) AS Pim_Folio,
--  MAX(Di_Pedimento.AgP_Patente) AS AgP_Patente,
--  MAX(Di_Pedimento.Adu_AduanaSecc) AS Adu_AduanaSecc,
 MAX(Di_Pedimento.Pim_FechaPago) AS Pim_FechaPago
--  MIN(Di_Pedimento.Pim_FechaIni) AS Pim_FechaIni,
--  MAX(Di_Pedimento.Pim_FechaFin) AS Pim_FechaFin
FROM
     Di_FacturaDet
     INNER JOIN Di_PedimentoDet ON( Di_FacturaDet.Fid_Consecutivo = Di_PedimentoDet. Fid_Consecutivo)
     INNER JOIN Di_Factura ON (Di_FacturaDet.FIm_Consecutivo = Di_Factura. FIm_Consecutivo)
     LEFT JOIN Di_FacturaDetUSA ON (Di_FacturaDet.Fid_Consecutivo = Di_FacturaDetUSA.FId_Consecutivo)
     INNER JOIN Di_Pedimento ON (Di_PedimentoDet.Pim_Consecutivo = Di_Pedimento.Pim_Consecutivo)
     INNER JOIN Di_PedimentoSaldo ON (Di_PedimentoDet.Pid_Consecutivo = Di_PedimentoSaldo.Pid_Consecutivo)
GROUP BY
         Di_Factura.FIm_Folio,
         Di_FacturaDet.FId_NoParte,
         Di_FacturaDet.Pai_Clave