# Importacion-SEERT
Scripts y utilidades para migrar datos desde una BD del sistema SEERT (MSSQL) hacia una DB de GRSA (Firebird).

### Carpetas
|Carpeta|Contenido|
|-------|---------|
|SQL|Scirpts SQL para generar vistas, tablas y otros ajustes en la información.|
|OtrosScripts|Scripts para generar archivos SQL para insertar datos.|
|Validaciones|Scripts para validar los datos.|
|Procesos|Procesos de la BD de GRSA para importar datos.|

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

## Procedimiento
#### 1. Conectarse al servidor para preparar la BD MSSQL.
  ```bash
  ssh root@192.168.1.151
  docker start mssql
  ```
  Datos del servidor MSSQL:
  - host: `192.168.1.151`
  - User: `sa`
  - Password: `mssql(!)Password`
  - Port: `1433`
#### 2. Restaurar backup:
Mover el archivo .bak a la carpeta del volumem configurado en MSSL
```bash
mv /grsc/Clientes/ClientesGRSA/Sunrise\ Jewelry/BC6P93-M/SEERT_Sunrise202.bak /grsc/Clientes/ClientesGRSA/ABASEDATOS/mssql/
# docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'mssql(!)Password' # <- Para iniciar una sesión T-SQL
```
Obtener el nombre de la base de datos.
```tsql
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/data/SEERT_Sunrise202.bak';
```
Listar los archivos que componene el backup ya que se deberán de reubicar.
```tsql
RESTORE FILELISTONLY FROM  DISK = N'/var/opt/mssql/data/SEERT_Sunrise202.bak';
```
Restarurar la BD (suponiendo que la salida del T-SQL anterior regresó los `LogicalName` `SEERMain` y `SEERMain_log`)
```tsql
RESTORE DATABASE [SEERT_Sunrise202]
FROM
  DISK = N'/var/opt/mssql/data/SEERT_Sunrise202.bak' 
WITH
  NORECOVERY
  , FILE = 1
  , MOVE 'SEERMain' TO N'/var/opt/mssql/data/SEERT_Sunrise202.mdf'
  , MOVE 'SEERMain_log' TO N'/var/opt/mssql/data/SEERT_Sunrise202_0.LDF'
;
GO
```
Validar la restauración
```tsql
USE SEERT_Sunrise202;
SELECT
  *
FROM
  SYSOBJECTS
WHERE
  xtype = 'U';
```
