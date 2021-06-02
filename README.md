# Importacion-SEERT
Scripts y utilidades para migrar datos desde una BD del sistema SEERT (MSSQL) hacia una DB de GRSA (Firebird).

### Carpetas
SQL -> Scirpts SQL para generar vistas, tablas y otros ajustes en la información.
<br>
OtrosScripts -> Scripts para generar archivos SQL para insertar datos.

### Este repositorio contienen los siguientes scripts:
- [Consulta para encontrar las tablas que tengan alguna relacion con cierta tabla](SQL/Tablas-Relaciones.sql)
- [Encontrar todas las tablas que tienen cierta columna](SQL/Find-Tables-By-Row-Name.sql)
- [Correcciones a la BD firebird](SQL/Fix_Firebird.sql)
- [Correciones a la BD MSSQL](SQL/fixes.sql)
- [Empresas](SQL/Empresas-View.sql)
- [Agentes](SQL/View-Agentes.sql)
- [Fracciones](SQL/Vista-Fracciones.sql)
- [Clietnes](SQL/Vista-Clientes.sql)
- [Productos](SQL/Vista-Productos.sql)
- [BOMS](SQL/Vista-BOM.sql)
- [Pedimentos de exportacion](SQL/PedimentosEXP.sql)
- [Pedimentos de Importacion](SQL/PedimentosIMP.sql)
- [Elementos de las facturas de exportacion](SQL/Tabla_ElemFactExp.sql)
- [Elementos de las facturas de importacion](SQL/Tabla-ElemFactImp.sql)
- [Descargas](SQL/Vista-Descargas.sql)
