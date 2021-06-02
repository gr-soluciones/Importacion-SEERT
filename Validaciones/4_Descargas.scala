saveAsList(
	"result.txt", 
	new Table(
        new SchemaTable("GR_ELEMPEDIMENTOEXP", Connections.mssql),
        new SchemaTable("ELEMFACTIMP", Connections.fb),
        Seq(
            (new Column("EP_NFACTURAIMP"), new Column("1")),
            (new Column("EP_NPARTE"), new Column("2")),
            (new Column("EP_PAISORIGEN"), new Column("3"))
        ),
        s"""SELECT
           EP_NFACTURAIMP, 
           EP_NPARTE,
           EP_PAISORIGEN
        FROM 
            GR_ELEMPEDIMENTOEXP AS M
            LEFT JOIN ELEMFACTIMP AS F ON
                F.EI_NPARTE = M.EP_NPARTE AND
                F.EI_NFACTIMP = M.EP_NFACTURAIMP and
                F.EI_PAISORIGEN = M.EP_PAISORIGEN
        WHERE
            F.EI_NFACTIMP IS NULL
        """,
        null,
        Formats.list
    )
)