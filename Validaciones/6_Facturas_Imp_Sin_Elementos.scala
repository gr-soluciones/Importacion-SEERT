saveAsTXT(
	"result.txt", 
	new Table(
        new SchemaTable("FACTIMPORT", Connections.fb),
        new SchemaTable("ELEMFACTIMP", Connections.fb),
        Seq(
            (new Column("IM_NFACTIMP"), new Column("1"))
        ),
        s"""SELECT IM_NFACTIMP
FROM FACTIMPORT
LEFT JOIN ELEMFACTIMP E on FACTIMPORT.IM_NFACTIMP = E.EI_NFACTIMP
WHERE E.EI_NPARTE IS NULL
        """,
        null,
        Formats.slList
    )
)