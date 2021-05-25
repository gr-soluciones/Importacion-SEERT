val mapping = Seq(
	(new Column("EE_NFACTEXP", false, true, 30), new Column("EE_NFACTEXP")),
	(new Column("EE_NPARTE", false, true), new Column("EE_NPARTE")),
	(new Column("EE_TIPOMATEXP", false, true), new Column("EE_TIPOMATEXP")),
	(new Column("EE_NPTIPO"), new Column("EE_NPTIPO")),
	(new Column("EE_DESCESP", false, false, 150), new Column("EE_DESCESP")),
	(new Column("EE_DESCING", false, false, 150), new Column("EE_DESCING")),
	(new Column("EE_TOTALMAT"), new Column("EE_TOTALMAT")),
	(new Column("EE_MATDUTIABLE"), new Column("EE_MATDUTIABLE")),
	(new Column("EE_VALDUTIABLE", true), new Column("EE_VALDUTIABLE")),
	(new Column("EE_PESOUNIT", true), new Column("EE_PESOUNIT")),
	(new Column("EE_PESOBRUTO", true), new Column("EE_PESOBRUTO")),
	(new Column("EE_PESONETO", true), new Column("EE_PESONETO")),
	(new Column("EE_ARANCELUS", false, false, 10), new Column("EE_ARANCELUS")),
	(new Column("EE_ARANCELMX", false, false, 10), new Column("EE_ARANCELMX")),
	(new Column("EE_UMPARTE", false, false, 5), new Column("EE_UMPARTE")),
	(new Column("EE_UMFRACCION", false, false, 5), new Column("EE_UMFRACCION")),
	(new Column("EE_PAISDESTINO", false, false, 3), new Column("EE_PAISDESTINO")),
	(new Column("EE_PEDIMENTOEXP", false, false, 25), new Column("EE_PEDIMENTOEXP")),
	(new Column("EE_FECHAPED"), new Column("EE_FECHAPED")),
	(new Column("EE_PAISORIGEN", false, false, 3), new Column("EE_PAISORIGEN"))
)

def getTableFor(tbName:String):Table = {
	new Table(
		new SchemaTable(tbName, Connections.mssql),
		new SchemaTable("ELEMFACTEXP"),
		mapping,
		null,
		Connections.fb
	)
}

saveBatchTables(
	Seq("GR_ELEMFACTEXP.sql"),
	Seq(getTableFor("GR_ELEMFACTEXP"))
)