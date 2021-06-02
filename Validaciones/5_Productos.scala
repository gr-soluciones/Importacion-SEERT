saveAsTXT(
	"result.txt", 
	new Table(
        new SchemaTable("Ca_Parte", Connections.mssql),
        new SchemaTable("PRODUCTOS", Connections.fb),
        Seq(
            (new Column("Par_NoParte"), new Column("1"))
        ),
        s"""SELECT 
            Par_NoParte
        FROM 
            Ca_Parte
            LEFT JOIN PRODUCTOS ON P_NPARTE = Par_NoParte
        WHERE P_NPARTE IS NULL
        """,
        null,
        Formats.slList
    )
)