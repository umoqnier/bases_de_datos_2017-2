
--Llenando tabla servicios
INSERT INTO servicios
VALUES('S001','Pago anual que normalmente se difiere hasta en 12 pagos','Colegiatura');

INSERT INTO servicios
VALUES('S002','Pago que se realiza al inscribirse','Inscripcion');

INSERT INTO servicios
VALUES('S003','Unico pago, se realiza normalmente en el primer mes','Material escolar');

INSERT INTO servicios
VALUES('S004','Unico pago, se realiza normalmente en el primer mes','Uniforme');

INSERT INTO servicios
VALUES('S005','Unico pago, se realiza normalmente en el primer mes','Libros');

--Llenando Grado
INSERT INTO grado
VALUES('1');

INSERT INTO grado
VALUES('2');

INSERT INTO grado
VALUES('3');

INSERT INTO grado
VALUES('4');

INSERT INTO grado
VALUES('5');

INSERT INTO grado
VALUES('6');

--Llenando grupos
INSERT INTO grupo
VALUES ('1', '1', 'A');
s
INSERT INTO grupo
VALUES ('2', '2', 'A');

INSERT INTO grupo
VALUES ('3', '3', 'A');

INSERT INTO grupo
VALUES ('4', '4', 'A');

INSERT INTO grupo
VALUES ('5', '5', 'A');

INSERT INTO grupo
VALUES ('6', '6', 'A');

INSERT INTO grupo
VALUES ('7', '1', 'B');

INSERT INTO grupo
VALUES ('8', '2', 'B');

INSERT INTO grupo
VALUES ('9', '3', 'B');

INSERT INTO grupo
VALUES ('10', '4', 'B');

INSERT INTO grupo
VALUES ('11', '5', 'B');

INSERT INTO grupo
VALUES ('12', '6', 'B');

INSERT INTO grupo
VALUES ('13', '1', 'C');

INSERT INTO grupo
VALUES ('14', '2', 'C');

INSERT INTO grupo
VALUES ('15', '3', 'C');

INSERT INTO grupo
VALUES ('16', '4', 'C');

INSERT INTO grupo
VALUES ('17', '5', 'C');

INSERT INTO grupo
VALUES ('18', '6', 'C');

--Llenando tabla grad_serv
INSERT INTO grad_serv
VALUES('S001','1',2000,3);

INSERT INTO grad_serv
VALUES('S002','1',24000,1);

INSERT INTO grad_serv
VALUES('S003','1',800,1);

INSERT INTO grad_serv
VALUES('S004','1',2500,1);

INSERT INTO grad_serv
VALUES('S005','1',500,1);
-- segundo
INSERT INTO grad_serv
VALUES('S001','2',2000,3);

INSERT INTO grad_serv
VALUES('S002','2',24000,1);

INSERT INTO grad_serv
VALUES('S003','2',800,1);

INSERT INTO grad_serv
VALUES('S004','2',2500,1);

INSERT INTO grad_serv
VALUES('S005','2',500,1);

--tercero
INSERT INTO grad_serv
VALUES('S001','3',2000,3);

INSERT INTO grad_serv
VALUES('S002','3',24000,1);

INSERT INTO grad_serv
VALUES('S003','3',800,1);

INSERT INTO grad_serv
VALUES('S004','3',2500,1);

INSERT INTO grad_serv
VALUES('S005','3',500,1);

--cuarto
INSERT INTO grad_serv
VALUES('S001','4',2000,3);

INSERT INTO grad_serv
VALUES('S002','4',24000,1);

INSERT INTO grad_serv
VALUES('S003','4',800,1);

INSERT INTO grad_serv
VALUES('S004','4',2500,1);

INSERT INTO grad_serv
VALUES('S005','4',500,1);

--quinto
INSERT INTO grad_serv
VALUES('S001','5',2000,3);

INSERT INTO grad_serv
VALUES('S002','5',24000,1);

INSERT INTO grad_serv
VALUES('S003','5',800,1);

INSERT INTO grad_serv
VALUES('S004','5',2500,1);

INSERT INTO grad_serv
VALUES('S005','5',500,1);

-- sexto
INSERT INTO grad_serv
VALUES('S001','6',2000,3);

INSERT INTO grad_serv
VALUES('S002','6',24000,1);

INSERT INTO grad_serv
VALUES('S003','6',800,1);

INSERT INTO grad_serv
VALUES('S004','6',2500,1);

INSERT INTO grad_serv
VALUES('S005','6',500,1);

--Llenando parentescos
INSERT INTO parentesco
VALUES ('1', 'Padre');

INSERT INTO parentesco
VALUES ('2', 'Madre');

INSERT INTO parentesco
VALUES ('3', 'Tio(a)');

INSERT INTO parentesco
VALUES ('4', 'Abuelo(a)');

INSERT INTO parentesco
VALUES ('5', 'Primo(a)');

--Llenando tipoResponsable
INSERT INTO tipoResponsable
VALUES ('RT1', 'Responsable');

INSERT INTO tipoResponsable
VALUES ('RT2', 'Tutor');

INSERT INTO tipoResponsable
VALUES ('RT3', 'Responsable/Tutor');

-- DISPARADOR CARGO

CREATE SEQUENCE numNotaCargo
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER creaServ
	AFTER INSERT ON inscripcion
DECLARE 
	vclvServ servicios.clvServ%TYPE;
	vNomServicio servicios.nomServicio%TYPE;
	vprecio grad_serv.precio%TYPE;
	
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
		VALUES('numNotaCargo.NEXVAL',:OLD.clvInscrip,SYSDATE,FUNCIONFECHAVENC,NULL,vNomServicio,vprecio);--FALTA VERIFICAR FECHAVENC
	END LOOP;
	CLOSE obtieneServ;
END creaServ;
/

--CREACION DE PROCEDIMIENTOS

CREATE OR REPLACE PROCEDURE insertaResponsable
(	vClvRes IN CHAR,
	vClvParen IN CHAR,
	vIdTipo IN CHAR,
	vApPatRes IN VARCHAR2,
	vApMatRes IN VARCHAR2,
	vNomRes IN VARCHAR2,
	vFechaNac IN DATE,
	vSexoRes IN CHAR,
	vCelular IN VARCHAR2,
	vCalleRes IN VARCHAR2,
	vColRes IN VARCHAR2,
	vDelRes IN VARCHAR2,
	vCP IN CHAR
)
AS
BEGIN
	INSERT INTO responsable
	VALUES(vClvRes,vClvParen,vIdTipo,vApPatRes,vApMatRes,vNomRes,vFechaNac,vSexoRes,vCelular,vCalleRes,vColRes,vDelRes,vCP);
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
	vCalleAlu IN VARCHAR2,
	vColAlu IN VARCHAR2,
	vDelAlu IN VARCHAR2,
	vCP IN CHAR	
)
AS
BEGIN
	INSERT INTO alumno
	VALUES(vClvAlumno,vClvTutor,vCurp,vNomAlu,vApPatAlu,vApMatAlu,vFechaNac,vSexoAlu,vCalleAlu,vColAlu,vDelAlu,vCP);
	COMMIT;
END insertaAlumno;
/

--BAJA ALUMNOS

CREATE OR REPLACE PROCEDURE bajaAlumno
(	vClvAlumno alumno.clvAlumno%TYPE)
AS
	vBuscaDeuda cargo.fechaPago%TYPE;
BEGIN
	SELECT fechaPago INTO vBuscaDeuda
	FROM cargo 
	NATURAL JOIN inscripcion
	NATURAL JOIN alumno
	WHERE clvAlumno = vClvAlumno;
	IF(vBuscaDeuda IS NOT NULL) THEN
		DELETE FROM alumno
		WHERE alumno.clvAlumno = vClvAlumno;
	ELSE
		DBMS_OUTPUT.PUT_LINE('El alumno aun presenta deudas');
	END IF;
END bajaAlumno;
/

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
JOIN tutor USING(clvTutor)
WHERE (TRUNC(fechaCrea) >= TRUNC(vFecha)
	AND TRUNC(fechaVenc) <= TRUNC(vFecha))
	AND fechaPago IS NULL
	AND clvTutor = vClvTutor;
IF vTotal IS NULL THEN
	DBMS_OUTPUT.PUT_LINE('EL Tutor con la clave '||vclvTutor||' no tiene adeudos');
ELSE
	DBMS_OUTPUT.PUT_LINE('EL Tutor con la clave '||vclvTutor||' debe: $'||vTotal);
END IF;

END deudaTotal;
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
		DBMS_OUTPUT.PUT_LINE(' | '||preciosReg.s.clvServ||' | '||preciosReg.numGrado||' | '||preciosReg.nomServicio||' | '||preciosReg.precio);
	END LOOP
END preciosServicios;
/

--Creacion de Vistas

CREATE OR REPLACE VIEW obtenerPreciosServ
AS
SELECT s.clvServ, numGrado, nomServicio AS NOMBRE, precio
FROM servicios s
INNER JOIN grad_serv gs
ON s.clvServ = gs.clvServ;


--Insertar responsables

EXEC insertaResponsable('1', '1', 'RT3', 'Barriga', 'Rodriguez', 'Alberto', '17/02/1980', 'H', '5598762938', 'Tulipanes #6', 'Jardines', 'Atizapan', '54040');
EXEC insertaResponsable('2', '2', 'RT3', 'Martínez', 'Olvera', 'Angeles', '30/08/1978', 'M', '5565829300', 'Frailes #3', 'San Andres', 'Tlalnepantla', '54040');
EXEC insertaResponsable('3', '3', 'RT2', 'Martínez', 'Rodriguez', 'Ilian', '20/04/1988', 'M', '5500738283', 'Dakota #425', 'Paises', 'Tlalpan', '58290');
EXEC insertaResponsable('4', '4', 'RT1', 'Olvera', 'Salvador', 'Francisca', '23/10/1966', 'M', '5576328221', 'Maestros #1', 'Centro', 'Coyoacan', '56232');
EXEC insertaResponsable('5', '5', 'RT2', 'Hernandez', 'Juarez', 'Saul', '22/09/1995', 'H', '5523493002', 'Sol #9', 'Universo', 'Cuahutemoc', '50082');
EXEC insertaResponsable('6', '2', 'RT2', 'Dominguez', 'Olvera', 'Sonia', '08/12/1978', 'M', '5592803545', 'Oxxo #56', 'Centro', 'Coyoacan', '58290');

--Insertar tutor
EXEC insertaTutor('1', 'BARA170280');
EXEC insertaTutor('2', 'MAOA300878');
EXEC insertaTutor('3', 'MARI200488');
EXEC insertaTutor('5', 'HEJS220995');
EXEC insertaTutor('6', 'DOOS081278');

--Inserta Alumnos
EXEC insertaAlumno('1', '1', 'BAMD220407', 'Diego', 'Barriga', 'Martínez', '22/04/2007', 'H', 'Tulipanes #6', 'Jardines', 'Atizapan', '54040');
EXEC insertaAlumno('2', '6', 'LODD191106', 'Juan', 'Lopez', 'Dominguez', '19/11/2006', 'H', 'Oxxo #56', 'Centro', 'Coyoacan', '58290');
EXEC insertaAlumno('3', '3', 'SAME060309', 'Ester', 'Sanchez', 'Martínez', '06/03/2009', 'M', 'Dakota #425', 'Paises', 'Tlalpan', '58290');

--Para pruebas
INSERT INTO inscripcion
VALUES ('IN001', '1', '16', '4', '2017-2');

INSERT INTO inscripcion
VALUES ('IN002', '2', '5', '5', '2017-1');

INSERT INTO inscripcion
VALUES ('IN003', '3', '8', '2', '2017-2');

INSERT INTO cargo
VALUES ('NP001', 'IN001', default, SYSDATE, NULL, 'Inscripcion', 2000);

INSERT INTO cargo
VALUES ('NP002', 'IN003', default, SYSDATE, SYSDATE, 'Inscripcion', 2000);

INSERT INTO cargo
VALUES ('NP003', 'IN001', default, SYSDATE, NULL, 'Libros', 500);



