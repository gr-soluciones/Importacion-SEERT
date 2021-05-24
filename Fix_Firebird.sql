INSERT INTO AGENTESA (AG_RFC, AG_NOMBRE, AG_RAZONSOC, AG_DIRECCION, AG_NOEXT, AG_NOINT, AG_CP, AG_COLONIA, AG_CIUDAD, AG_EFEDERATIVA, AG_TELEFONO1, AG_TELEFONO2, AG_EMAIL, AG_PWEB, AG_FAXI, AG_FAXE, AG_CURP, AG_PAIS, AG_PATENTE, AG_DEFAULT) VALUES ('3', 'VICTOR HUGO GAMAS LUNA', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '3711', 'NO');

update AGENTESA
set AG_PATENTE = 3878
where AG_RFC = '16';

insert into AGENTESA (AG_RFC, AG_NOMBRE, AG_PATENTE)
values ('0', '', 3933);

insert into FARANCELARIAS (FR_FRACCION, FR_PAIS, FR_VALIDADESDE, FR_VALIDAHASTA)
values ('', 'USA', '2000-01-01', '3000-01-01');

insert into PEDIMENTOEXP (PE_PEDIMENTOEXP)
values ('');

insert into CLVPEDIM (CP_CLVPED)
values ('');

insert into MEDIDAS (ME_UMEDIDA)
values ('MP');
insert into MEDIDAS (ME_UMEDIDA)
values ('PT');
insert into MEDIDAS (ME_UMEDIDA)
values ('');
insert into MEDIDAS (ME_UMEDIDA)
values ('DESMP');
insert into MEDIDAS (ME_UMEDIDA)
values ('EQ');

select *
from MEDIDAS;