saveAsTXT(
	"result.txt", 
	new Table(
        new SchemaTable("GR_ELEMFACTEXP", Connections.mssql),
        new SchemaTable("ELEMFACTEXP", Connections.fb),
        Seq(
            (new Column("EE_NFACTEXP", false, false, 30), new Column("1")),
            (new Column("EE_NPARTE", false, false, 30), new Column("2")),
            (new Column("EE_TIPOMATEXP", false, false, 20), new Column("3"))
        ),
        s"""SELECT M.EE_NFACTEXP, M.EE_NPARTE, M.EE_TIPOMATEXP FROM GR_ELEMFACTEXP AS M
        LEFT JOIN ELEMFACTEXP AS F ON 
            F.EE_NFACTEXP = M.EE_NFACTEXP AND
            F.EE_NPARTE = M.EE_NPARTE AND
            F.EE_TIPOMATEXP = M.EE_TIPOMATEXP
        WHERE F.EE_NFACTEXP IS NULL""",
        null,
        Formats.txt
    )
)