# Importacion-SEERT
Scripts y utilidades para migrar datos desde una BD del sistema SEERT (MSSQL) hacia una DB de GRSA (Firebird).

### Carpetas
SQL => Scirpts SQL para generar vistas, tablas y otros ajustes en la información.
OtrosScripts => Scripts Scala para generar una serie de archivos SQL para insertar los datos directamente.

### Este repositorio contienen los siguientes scripts:
- [Consulta para encontrar las tablas que tengan alguna relacion con cierta tabla](SQL/Tablas-Relaciones.sql)
- [Encontrar todas las tablas que tienen cierta columna](SQL/Find-Tables-By-Row-Name.sql)
- [Correcciones a la BD firebird](SQL/Fix_Firebird.sql)
- [Correciones a la BD MSSQL](SQL/fixes.sql)
- [Crear la vista que relaciona las empresas de SEERT con las de GRSA](SQL/Empresas-View.sql)
- [Vista con los datos de las fracciones](SQL/Vista-Fracciones.sql)
- [Vista con los datos de los clietnes](SQL/Vista-Clientes.sql)
- [Vista con el formato de los productos arregado](SQL/Vista-Productos.sql)
- [Vista con los datos de los pedimentos de exportacion](SQL/PedimentosEXP.sql)
- [Vista con los datos de los pedimentos de Importacion](SQL/PedimentosIMP.sql)
- [Tabla con los elementos de las facturas de exportacion](SQL/Tabla_ElemFactExp.sql)
- [Tabla con los elementos de las facturas de Importacion](SQL/Tabla-ElemFactImp.sql)
