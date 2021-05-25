val t = new Table(
	new SchemaTable("GR_ELEM_FACTIMPORT", Connections.mssql),
	new SchemaTable("ELEMFACTIMP"),
	Seq(
		(new Column("FIm_Folio", false, true, 30), new Column("EI_NFACTIMP")),
		(new Column("FId_NoParte", false, true, 30), new Column("EI_NPARTE")),
		(new Column("Pai_Clave", false, true, 3), new Column("EI_PAISORIGEN")),
		(new Column("FId_CostoUnit", true), new Column("EI_VALORUNIT"))
	),
	null,
	Connections.fb
)

saveBatchTables(
	Seq("elem_fact_imp._fix.sql"),
	Seq(t)
)