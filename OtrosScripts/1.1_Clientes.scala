val t = new Table(
	new SchemaTable("GR_CLIENTES_MAX", Connections.mssql),
	new SchemaTable("CLIENPROV"),
	Seq(
		(new Column("RFC", false, true, 13), new Column("CL_RFC")),
		(new Column("RazonSocial", false, false, 75), new Column("CL_NOMBRE")),
		(new Column("ORIGEN", false, false, 10), new Column("CL_ORIGEN")),
		(new Column("Tipo", false, false, 40), new Column("CL_TIPO")),
		(new Column("Calle", false, false, 150), new Column("CL_DIRECCIONPI")),
		(new Column("NoExt", false, false, 10), new Column("CL_NOEXTFISCAL")),
		(new Column("NoInt", false, false, 10), new Column("CL_NOINTFISCAL")),
		(new Column("Colonia", false, false, 70), new Column("CL_COLONIAFISCAL")),
		(new Column("Ciudad", false, false, 30), new Column("CL_CIUDADFISCAL")),
		(new Column("Pais", false, false, 3), new Column("CL_PAIS")),
		(new Column("Estado", false, false, 20), new Column("CL_EFEDERATIVAFISCAL")),
		(new Column("Telefono", false, false, 20), new Column("CL_TELEFONOFISCAL")),
		(new Column("FAX", false, false, 20), new Column("CL_FAXFISCAL"))
	),
	null,
	Connections.fb
)

saveBatchTable("ClientesProv.sql", 500, t)
