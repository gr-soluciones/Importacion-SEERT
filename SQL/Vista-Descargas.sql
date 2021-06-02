DROP TABLE IF EXISTS GR_ELEMPEDIMENTOEXP;
GO
CREATE TABLE GR_ELEMPEDIMENTOEXP
(
    EP_NFACTURAEXP VARCHAR(30) not null,
    EP_NFACTURAIMP VARCHAR(30) not null,
    EP_NPARTE      VARCHAR(30) not null,
    EP_PAISORIGEN  VARCHAR(3)  not null,
    EP_CANTIDAD    NUMERIC default 0,
    constraint ELEMPEDIMENTOEXP_PK
        primary key (EP_NFACTURAEXP, EP_NFACTURAIMP, EP_NPARTE, EP_PAISORIGEN)
);
GO
INSERT INTO GR_ELEMPEDIMENTOEXP(EP_NFACTURAEXP, EP_NFACTURAIMP, EP_NPARTE,
                                EP_PAISORIGEN, EP_CANTIDAD)
SELECT
    left(De_Factura.FEx_Folio,30) as NFactExp,
    left(Di_PedimentoDet.FIm_Folio,30) as NFactImp,
    Di_PedimentoDet.Pid_NoParte,
    Di_PedimentoDet.Pai_Origen,
    SUM(TR_Descarga.Des_CantTotDescargar) AS CantTotDescargar
FROM
     dbo.TR_Descarga TR_Descarga
     INNER JOIN dbo.De_Factura De_Factura ON TR_Descarga.Fex_Consecutivo = De_Factura.FEx_Consecutivo
     INNER JOIN dbo.Di_PedimentoDet Di_PedimentoDet ON TR_Descarga.Pid_Consecutivo = Di_PedimentoDet.Pid_Consecutivo
GROUP BY
         De_Factura.FEx_Folio,
         Di_PedimentoDet.FIm_Folio,
         Di_PedimentoDet.Pid_NoParte,
         Di_PedimentoDet.Pai_Origen;