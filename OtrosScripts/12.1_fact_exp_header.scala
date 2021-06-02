val t = new Table(
	new SchemaTable("GR_FACTEXPORT", Connections.mssql),
	new SchemaTable("FACTEXPORT", Connections.fb),

	Seq(
		(new Column("Folio", false, true, 30), new Column("EX_NFACTEXP")),
		(new Column("Fecha"), new Column("EX_FACTFECHA")),
		(new Column("TCambio", true), new Column("EX_TCAMBIO")),
		(new Column("Importador", false, false, 13), new Column("EX_IMPORTADOR")),
		(new Column("Exportador", false, false, 13), new Column("EX_CONSIGNATARIO")),
		(new Column("AgenciaMX", false, false , 13), new Column("EX_AGENCIAMX")),
		(new Column("AgenciaUSA", false, false, 13), new Column("EX_AGENCIAUS")),
		(new Column("PlacasMx", false, false, 20), new Column("EX_CONTPLACASMX")),
		(new Column("PlacasUSA", false, false, 20), new Column("EX_TCAMBIO")),
		(new Column("Intercom", false, false, 3), new Column("EX_INCOTERM")),
	),
	s"""SELECT F.*
	FROM GR_FACTEXPORT F
	INNER JOIN FACTEXPORT G ON G.EX_NFACTEXP = F.Folio
	WHERE G.EX_IMPORTADOR IS NULL""",
	Connections.fb
)

saveBatchTables(
	Seq("fact_exp.sql"),
	Seq(t)
)
