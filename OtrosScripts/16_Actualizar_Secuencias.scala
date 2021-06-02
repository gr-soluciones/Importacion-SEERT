saveAsTXT(
	"SecuenciasDePedimentoExp.txt", 
	new Table(
		new SchemaTable("GR_ELEMFACTEXP", Connections.mssql),
		new SchemaTable("ELEMFACTEXP"),
		Seq(
			(new Column("EE_NFACTEXP", false, true, 30), new Column("EE_NFACTEXP")),
			(new Column("EE_NPARTE", false, true, 30), new Column("EE_NPARTE")),
			(new Column("EE_TIPOMATEXP", false, true, 20), new Column("EE_TIPOMATEXP")),
			(new Column("EE_SECUENCIAPEDEXP", false, false, 3), new Column("EE_SECUENCIAPEDEXP"))
		),
		null,
		Connections.fb,
		Formats.txt
	)
)

saveAsTXT(
	"SecuenciasDePedimentoImp.txt", 
	new Table(
		new SchemaTable("GR_ELEMFACTIMP", Connections.mssql),
		new SchemaTable("GR_ELEMFACTIMP"),
		Seq(
			(new Column("EI_NFACTIMP", false, true, 30), new Column("EI_NFACTIMP")),
			(new Column("EI_NPARTE", false, true, 30), new Column("EI_NPARTE")),
			(new Column("EI_PAISORIGEN", false, true, 20), new Column("EI_PAISORIGEN")),
			(new Column("EI_SECUENCIAPEDIMP", false, false, 3), new Column("EI_SECUENCIAPEDIMP"))
		),
		null,
		Connections.fb,
		Formats.txt
	)
)