CREATE SEQUENCE numNotaCargo
START WITH 1 INCREMENT BY 1;

--Creacion de Funciones
CREATE OR REPLACE FUNCTION obtieneFechaVencimiento(vServicio IN VARCHAR2)
RETURN DATE
IS
	vFecha DATE;
BEGIN
	IF vServicio = 'Inscripcion' THEN
		vFecha := SYSDATE;
	ELSE
		vFecha := '22/08/17'; --Dian en que empiezan las clases en escuelas 
	END IF;
	RETURN(vFecha);
END obtieneFechaVencimiento;
/

-- DISPARADOR CARGO
CREATE OR REPLACE TRIGGER creaServ
AFTER INSERT 
ON inscripcion
DECLARE 
	vclvServ CHAR(4);
	vNomServicio VARCHAR2(30);
	vprecio NUMBER(11, 2);
	CURSOR obtieneServ 
	IS
		SELECT clvServ, nomServicio		
		FROM servicios;	
BEGIN	
	OPEN obtieneServ;
	LOOP		
		
		FETCH obtieneServ INTO vclvServ, vNomServicio;
		EXIT WHEN obtieneServ%NOTFOUND;
		
		SELECT precio INTO vprecio
		FROM grad_serv AS gs
		WHERE gs.numGrado = numGrado
		AND gs.clvServ = vclvServ;
		
		INSERT INTO cargo
		VALUES('numNotaCargo.NEXVAL',:OLD.clvInscrip,SYSDATE, obtieneFechaVencimiento(vNomServicio),NULL,, vprecio);--FALTA VERIFICAR FECHAVENC
	END LOOP;
	CLOSE obtieneServ;
END creaServ;
/

-- Disparador de tabla credito
CREATE OR REPLACE TRIGGER creaNotaCredito
AFTER UPDATE ON cargo
FOR EACH ROW
WHEN (new.fechaPago <> NULL)
BEGIN
	IF servicio = 'Inscripcion' AND TO_CHAR(new:fechaPago,'MM') = '02' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,50,importeCar*50/100); 
	ELSIF servicio = 'Inscripcion' AND TO_CHAR(fechaPago,'MM') <> '02' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,0,importeCar*0); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '01' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,20,importeCar*20/100); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '02' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,15,importeCar*15/100); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '03' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,10,importeCar*10/100); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '06' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,6,importeCar*6/100); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '10' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,3,importeCar*3/100); 
	ELSIF TO_CHAR(:new.fechaPago,'MM') = '12' THEN
		INSERT INTO credito
		VALUES('NC'||numNotaCredito.NEXTVAL,NoNotaCargo,fechaPago,0,importeCar*0); 
	END IF;
END creaNotaCredito;
/

--CREACION DE PROCEDIMIENTOS

CREATE OR REPLACE PROCEDURE insertaResponsable
(	vClvRes IN CHAR,
	vIdTipo IN CHAR,
	vNomRes IN VARCHAR2,
	vApPatRes IN VARCHAR2,
	vApMatRes IN VARCHAR2,
	vFechaNac IN DATE,
	vSexoRes IN CHAR,
	VDirec IN VARCHAR2,
	vCelular IN VARCHAR2
)
AS
BEGIN
	INSERT INTO responsable
	VALUES(vClvRes, vIdTipo, vNomRes, vApPatRes, vApMatRes, vFechaNac, vSexoRes, vDirec, vCelular);
	COMMIT;
END insertaResponsable;
/

--ALTA TUTOR
CREATE OR REPLACE PROCEDURE insertaTutor
(
	vClvTutor in CHAR,
	vRfc in VARCHAR2
)
AS
BEGIN
	INSERT INTO tutor
	VALUES (vClvTutor, vRfc);
	COMMIT;
END insertaTutor;
/

--ALTA ESTUDIANTES
CREATE OR REPLACE PROCEDURE insertaAlumno
(	vClvAlumno IN CHAR,
	vClvTutor IN CHAR,
	vCurp IN CHAR,
	vNomAlu IN VARCHAR2,
	vApPatAlu IN VARCHAR2,
	vApMatAlu IN VARCHAR2,	
	vFechaNac IN DATE,
	vSexoAlu IN CHAR, 
	vDirec IN VARCHAR2
)
AS
BEGIN
	INSERT INTO alumno
	VALUES(vClvAlumno,vClvTutor,vCurp,vNomAlu,vApPatAlu,vApMatAlu,vFechaNac,vSexoAlu,vDirec);
	COMMIT;
END insertaAlumno;
/

--BAJA ALUMNOS

CREATE OR REPLACE PROCEDURE bajaAlumno
(	vClvAlumno alumno.clvAlumno%TYPE)
AS
	vBuscaDeuda alumno.clvAlumno%TYPE;
BEGIN
	SELECT distinct al.clvAlumno INTO vBuscaDeuda
	FROM cargo c
	JOIN inscripcion ins ON ins.clvInscrip = c.clvInscrip
	JOIN alumno al ON ins.clvAlumno = al.clvAlumno
	WHERE al.clvAlumno = vClvAlumno
	AND fechaPago IS NULL;
	IF vBuscaDeuda is null THEN
		DELETE FROM alumno
		WHERE clvAlumno = vClvAlumno;		
	ELSE
		DBMS_OUTPUT.PUT_LINE('El alumno aun presenta adeudos');
	END IF;
END bajaAlumno;
/

--Procedimiento para calculo de deudas

CREATE OR REPLACE PROCEDURE deudaTotal
(	vClvTutor IN CHAR,
	vFecha IN DATE
)	
AS
	vTotal NUMBER(11,2);
BEGIN
SELECT SUM(importeCar) INTO vTotal 
FROM cargo
JOIN inscripcion USING(clvInscrip)
JOIN alumno USING(clvAlumno)
LEFT OUTER JOIN alum_res ON clvRes = vClvTutor
LEFT OUTER JOIN responsable ON responsable.clvRes = vClvTutor
LEFT OUTER JOIN tutor ON tutor.clvTutor = vClvTutor
WHERE (TRUNC(fechaCrea) >= TRUNC(vFecha)
	AND TRUNC(fechaVenc) <= TRUNC(vFecha))
	AND fechaPago IS NULL
	AND tutor.clvTutor = vClvTutor;
IF vTotal IS NULL THEN
	DBMS_OUTPUT.PUT_LINE('El Tutor con la clave '||vclvTutor||' no tiene adeudos');
ELSE
	DBMS_OUTPUT.PUT_LINE('El Tutor con la clave '||vclvTutor||' debe: $'||vTotal);
END IF;

END deudaTotal;
/

-- Procedimiento de reporte de fechas de Vencimiento

CREATE OR REPLACE PROCEDURE reporteVenc
(	vClvAlumno IN CHAR )	
AS
	CURSOR cursorReporteVenc
	IS
	SELECT clvAlumno,nomAlu, apPatAlu,apMatAlu, fechaVenc
	FROM alumno
	JOIN inscripcion USING (clvAlumno)
	JOIN cargo USING (clvInscrip)
	WHERE clvAlumno = vClvAlumno
	ORDER BY TO_DATE(fechaVenc,'DD/MM/YY') ASC;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Fecha de Vencimiento de Pagos:');
	FOR alumReg IN cursorReporteVenc LOOP
		DBMS_OUTPUT.PUT_LINE('	|	'||alumReg.clvAlumno||'	|	'|| alumReg.nomAlu||'	|	'|| alumReg.apPatAlu||'	|	'||alumReg.apMatAlu||' |	'||alumReg.fechaVenc||'	|	');
	END LOOP;				
END reporteVenc;
/

--Procedimineto para dar de baja un responsable

CREATE OR REPLACE PROCEDURE bajaresponsable(
vClvRes IN CHAR)
AS
BEGIN
	DELETE FROM responsable
	WHERE ClvRes=vClvRes;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('baja del Responsable '|| vClvRes);
END bajaresponsable;
/

--Procedimiento cuantos alumnos hay inscritos en un determinado periodo

CREATE OR REPLACE PROCEDURE alumnosInscritos(
vCicloInsc IN VARCHAR2)
AS
	CURSOR cursorAlumnos
	IS
	SELECT a.nomAlu, a.apPatAlu, a.apMatAlu, a.curp
	FROM alumno a
	INNER JOIN inscripcion i ON a.clvAlumno = i.clvAlumno
	WHERE i.cicloInsc = vCicloInsc;
BEGIN
	DBMS_OUTPUT.PUT_LINE('ALumno pertenecientes al ciclo '||vCicloInsc);
	FOR alumnosInsc IN cursorAlumnos LOOP
		DBMS_OUTPUT.PUT_LINE('| '||alumnosInsc.nomAlu||' | '||alumnosInsc.apPatAlu||' | '||alumnosInsc.apMatAlu||' | '||alumnosInsc.curp||' |');
	END LOOP;
END alumnosInscritos;
/	
	
--Fin procedimiento cuantos alumnos hay inscritos en un determinado periodo

CREATE OR REPLACE PROCEDURE preciosServicios(
vGrado IN VARCHAR2)
AS
	CURSOR cursorServicios
	IS
	SELECT s.clvServ, numGrado, nomServicio, precio
	FROM servicios s
	INNER JOIN grad_serv gs
	ON s.clvServ = gs.clvServ
	WHERE numGrado = vGrado;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Precios de: '||vGrado||' Grado');
	FOR preciosReg IN cursorServicios LOOP
		DBMS_OUTPUT.PUT_LINE(' | '||preciosReg.clvServ||' | '||preciosReg.numGrado||' | '||preciosReg.nomServicio||' | '||preciosReg.precio);
	END LOOP;
END preciosServicios;
/

CREATE OR REPLACE PROCEDURE bajaresponsable(
vClvRes IN CHAR)
AS
BEGIN
	DELETE FROM responsable
	WHERE ClvRes=vClvRes;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('baja del Responsable '|| vClvRes);
END bajaresponsable;
/

--Procedimiento para insertar contacto
CREATE OR REPLACE PROCEDURE insertarContacto(
vClvRes IN CHAR,
vTelefono IN VARCHAR2, 
vHorarioDisp IN VARCHAR2
)
AS
BEGIN
	INSERT INTO contacto
	VALUES (vClvRes, vTelefono, vHorarioDisp);
	COMMIT;
END insertarContacto;
/

--Creacion de Vistas

--Ver si hay pago pendiente
CREATE OR REPLACE VIEW vistaAdeudosXAlumno
AS
SELECT a.curp AS ALUMNO, nomServicio AS SERVICIO, importeCar AS "POR PAGAR", fechaVenc AS VENCE
FROM cargo c
INNER JOIN inscripcion i ON c.clvInscrip = i.clvInscrip
INNER JOIN alumno a ON a.clvAlumno = i.clvAlumno
INNER JOIN servicios s ON c.clvServ = s.clvServ;

--Ver nota de credito y cargo por alumno
 
--Tutor de cada alumno
CREATE OR REPLACE VIEW vistaTutorXAlumno
AS
SELECT a.nomAlu AS ALUMNO, a.curp, r.nomRes AS TUTOR, r.apPatRes AS "APELLIDO PAT.", r.apMatRes AS "APELLIDO MAT.", r.celular, t.rfc
FROM alumno a
INNER JOIN tutor t ON a.clvTutor = t.clvTutor
INNER JOIN responsable r ON t.clvTutor = r.clvRes;
--Alumno mujer y hombres
CREATE OR REPLACE VIEW vistaNumeroAlumnosXSexo
AS
SELECT sexoAlu AS SEXO, COUNT(sexoAlu) AS "#" 
FROM Alumno
GROUP BY sexoAlu;
--Inscritos en que grupo
CREATE OR REPLACE VIEW vistaAlumnoXGrupo
AS
SELECT a.nomAlu AS ALUMNO, a.apPatAlu AS "APELLIDO PAT", a.apMatAlu AS "APELLIDO MAT", i.cicloInsc AS CICLO, g.letra AS GRUPO, g.numGrado AS N
FROM alumno a
INNER JOIN inscripcion i ON a.clvAlumno = i.clvAlumno
INNER JOIN grupo g ON i.clvGrupo = g.clvGrupo;

--SERVICIOS POR ALUMNO
CREATE OR REPLACE VIEW vistaServicioXAlumno
AS
SELECT i.clvInscrip, a.nomAlu AS NOMBRE, a.apPatAlu AS "APELLIDO PAT", a.apMatAlu AS "APELLIDO MAT", g.numGrado AS G, gs.precio, s.nomServicio AS SERVICIO
FROM alumno a
INNER JOIN inscripcion i ON a.clvAlumno = i.clvAlumno
INNER JOIN grupo g ON i.clvGrupo = g.clvGrupo
INNER JOIN grado gr ON g.numGrado = gr.numGrado
INNER JOIN grad_serv gs ON gr.numGrado = gs.numGrado
INNER JOIN servicios s ON gs.clvServ = s.clvServ;

--Horario del responsable con telefono
CREATE OR REPLACE VIEW vistaHorarioResponsable
AS
SELECT nomRes AS NOMBRE, apPatRes AS "APELLIDO PAT", apMatRes AS "APELLIDO MAT", telefono, horarioDisp AS HORARIO
FROM responsable
JOIN contacto USING(clvRes);