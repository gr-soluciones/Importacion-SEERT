saveAsTXT(
	"LMateriales.txt", 
	new Table(
        new SchemaTable("FACTIMPORT", Connections.fb),
        new SchemaTable("Di_Factura", Connections.mssql),
        Seq(
            (new Column("IM_NFACTIMP", false, true, 30), new Column(""))
        ),
        s"""SELECT IM_NFACTIMP FROM FACTIMPORT LEFT JOIN Di_Factura ON IM_NFACTIMP = FIm_Folio WHERE FIm_Folio IS NULL""",
        null,
        Formats.txt
    )
)