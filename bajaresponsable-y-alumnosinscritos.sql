--Procedimineto para dar de baja un responsable

CREATE OR REPLACE PROCEDURE bajaresponsable(
vClvRes IN CHAR)
AS
BEGIN
	DELETE FROM responsable
	WHERE ClvRes=vClvRes;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('baja del Responsable');
END bajaresponsable;
/

--Fin procedimiento para dar de baja responsable

--Procedimiento cuantos alumnos hay inscritos en un determinado periodo

CREATE OR REPLACE PROCEDURE alumnosinscritos(
vcicloInsc IN VARCHAR2)
AS
vBuscaAlumno alumno.clvAlumno%TYPE;
BEGIN
	SELECT a.nomAlu INTO vBuscaAlumno
	FROM alumno a,inscripcion i 
	WHERE i.clvAlumno=a.clvAlumno
	AND i.cicloInsc=vcicloInsc;
	DBMS_OUTPUT.PUT_LINE('Alumno inscritos'||vCicloInsc);
END alumnosinscritos;
/	
	
--Fin procedimiento cuantos alumnos hay inscritos en un determinado periodo

--Procedimiento cuantos pagos tiene pendientes un alumno y su tutor

CREATE OR REPLACE PROCEDURE pagospendientes(
vclvAlumno IN CHAR)
AS

BEGIN
	SELECT servicio 
	FROM alumno
	JOIN inscripcion USING(clvAlumno)
	JOIN cargo USING(clvinscrip)
	JOIN credito USING(clvinscrip)
DBMS_OUTPUT.PUT_LINE('Adeudos'||vclvalumno);
END pagospendientes;
/

--Fin procedimiento cuantos pagos tiene pendientes un alumno y su tutor
