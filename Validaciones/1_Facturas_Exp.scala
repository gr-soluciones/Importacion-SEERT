saveAsTXT(
	"facturass.txt", 
	new Table(
        new SchemaTable("De_Factura", Connections.mssql),
        new SchemaTable("FACTEXPORT", Connections.fb),
        Seq(
            (new Column("FEx_Folio", false, false, 50), new Column(""))
        ),
        s"""SELECT FEx_Folio FROM De_Factura LEFT JOIN FACTEXPORT ON FEx_Folio = EX_NFACTEXP WHERE EX_NFACTEXP IS NULL""",
        null,
        Formats.txt
    )
)