INSERT INTO CO_DATOS (NOMBRE, CONEXION, PROCESO, PARAM_SELEC, MAPEO_INFO, CD_DEFAULT)
VALUES (
        'LMateriales_SEERT',
        'MSSQLSeert',
        'BOM',
        'SELECT bm.Par_NoPartePadre,'   ||
           'bm.Par_NoParteHijo,'        ||
           'bm.Bom_Cantidad,'           ||
           'bm.Med_Clave,'              ||
           'bm.Bom_FactConvD,'          ||
           'bm.Bom_FechaIni,'           ||
           'bm.Bom_FechaFin'            ||
        ' FROM '                        ||
            'Ca_Bom AS bm',
        'LM_NENSAMBLE=Par_NoPartePadre'   || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_NPARTE=Par_NoParteHijo'       || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_FINI=Bom_FechaIni'            || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_UMEDIDA=Med_Clave'            || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_CANTIDAD=Bom_Cantidad'        || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_PARTEFANTASMA='               || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_PMERMA='                      || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_PDESPERDICIO='                || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_MAKE_BUY='                    || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'LM_FFIN=Bom_FechaFin'            || ASCII_CHAR(13) || ASCII_CHAR(10) ||
        'fModoImp=0',
        'NO');

Subensample