UPDATE SEERT_ROCKWELL_3_OCT26.dbo.CaF_Medida SET Med_Clave = N'NAOHT' WHERE Med_Consecutivo = 126;

update Ca_AgenciaPatente set AgP_Rfc = left(trim(AgP_Rfc), 13);


update Ca_AgenciaPatente set AgP_Rfc = '91-1069248' where AgP_Rfc like '91-1069248__';