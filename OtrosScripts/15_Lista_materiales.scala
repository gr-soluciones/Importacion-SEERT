saveAsTXT(
	"LMateriales.txt", 
	new Table(
		new SchemaTable("GR_BOM2", Connections.mssql),
		new SchemaTable("LMATERIALES"),
		Seq(
			(new Column("Par_NoPartePadre", false, true, 30), new Column("LM_NENSAMBLE")),
			(new Column("Par_NoParteHijo", false, true, 30), new Column("LM_NPARTE")),
			(new Column("Bom_FechaIni", false, true, 19), new Column("LM_FINI")),
			(new Column("Bom_Cantidad", false, false, 10), new Column("LM_CANTIDAD")),
			(new Column("Med_Clave", false, false, 5), new Column("LM_UMEDIDA")),
			// (new Column("Bom_FactConvD", true), new Column("EE_DESCESP")),
			(new Column("Bom_FechaFin", false, false, 19), new Column("LM_FFIN")),
			(new Column("MakeBuy", false, false, 2), new Column("LM_MAKE_BUY"))
		),
		null,
		Connections.fb,
		Formats.txt
	)
)