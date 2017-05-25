--Llenando tabla servicios
INSERT INTO servicios
VALUES('S001','Colegiatura','Pago anual que normalmente se difiere hasta en 12 pagos');

INSERT INTO servicios
VALUES('S002','Inscripcion','Pago que se realiza al inscribirse');

INSERT INTO servicios
VALUES('S003','Material escolar','Unico pago, se realiza normalmente en el primer mes');

INSERT INTO servicios
VALUES('S004','Uniforme','Unico pago, se realiza normalmente en el primer mes');

INSERT INTO servicios
VALUES('S005','Libros','Unico pago, se realiza normalmente en el primer mes');

INSERT INTO servicios
VALUES('S006','Multas','Adeudos generados por pagos atrasados');

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
VALUES('S001','1',2000);

INSERT INTO grad_serv
VALUES('S002','1',24000);

INSERT INTO grad_serv
VALUES('S003','1',800);

INSERT INTO grad_serv
VALUES('S004','1',2500);

INSERT INTO grad_serv
VALUES('S005','1',500);
-- segundo
INSERT INTO grad_serv
VALUES('S001','2',2100);

INSERT INTO grad_serv
VALUES('S002','2',25000);

INSERT INTO grad_serv
VALUES('S003','2',900);

INSERT INTO grad_serv
VALUES('S004','2',2600);

INSERT INTO grad_serv
VALUES('S005','2',600);

--tercero
INSERT INTO grad_serv
VALUES('S001','3',2200);

INSERT INTO grad_serv
VALUES('S002','3',26000);

INSERT INTO grad_serv
VALUES('S003','3',1000);

INSERT INTO grad_serv
VALUES('S004','3',2700);

INSERT INTO grad_serv
VALUES('S005','3',700);

--cuarto
INSERT INTO grad_serv
VALUES('S001','4',2300);

INSERT INTO grad_serv
VALUES('S002','4',27000);

INSERT INTO grad_serv
VALUES('S003','4',1100);

INSERT INTO grad_serv
VALUES('S004','4',2700);

INSERT INTO grad_serv
VALUES('S005','4',800);

--quinto
INSERT INTO grad_serv
VALUES('S001','5',2400);

INSERT INTO grad_serv
VALUES('S002','5',28000);

INSERT INTO grad_serv
VALUES('S003','5',1200);

INSERT INTO grad_serv
VALUES('S004','5',2800);

INSERT INTO grad_serv
VALUES('S005','5',900);

-- sexto
INSERT INTO grad_serv
VALUES('S001','6',2500);

INSERT INTO grad_serv
VALUES('S002','6',29000);

INSERT INTO grad_serv
VALUES('S003','6',1300);

INSERT INTO grad_serv
VALUES('S004','6',2900);

INSERT INTO grad_serv
VALUES('S005','6',1000);

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

--Insertar responsables

EXEC insertaResponsable('1', 'RT3', 'Alberto', 'Barriga', 'Rodriguez', '17/02/1980', 'H', 'Tulipanes #6, Jardines, Atizapan', '5598762938');
EXEC insertaResponsable('2', 'RT3', 'Angeles', 'Martínez', 'Olvera', '30/08/1978', 'M', 'Frailes #3, San Andres, Tlalnepantla', '5565829300');
EXEC insertaResponsable('3', 'RT2', 'Ilian', 'Martínez', 'Rodriguez', '20/04/1988', 'M', 'Dakota #425, Paises, Tlalpan', '5500738283');
EXEC insertaResponsable('4', 'RT1', 'Francisca', 'Olvera', 'Salvador', '23/10/1966', 'M', 'Maestros #1, Centro, Coyoacan', '5576328221');
EXEC insertaResponsable('5', 'RT2', 'Saul', 'Hernandez', 'Juarez', '22/09/1995', 'H', 'Sol #9, Universo, Cuahutemoc', '5523493002');
EXEC insertaResponsable('6', 'RT2', 'Sonia', 'Dominguez', 'Olvera', '08/12/1978', 'M', 'Oxxo #56, Centro, Coyoacan', '5592803545');

--Insertar tutor
EXEC insertaTutor('1', 'BARA170280');
EXEC insertaTutor('2', 'MAOA300878');
EXEC insertaTutor('3', 'MARI200488');
EXEC insertaTutor('5', 'HEJS220995');
EXEC insertaTutor('6', 'DOOS081278');

--Inserta Alumnos
EXEC insertaAlumno('1', '1', 'BAMD220407', 'Diego', 'Barriga', 'Martínez', '22/04/2007', 'H', 'Tulipanes #6, Jardines, Atizapan');
EXEC insertaAlumno('2', '6', 'LODD191106', 'Juan', 'Lopez', 'Dominguez', '19/11/2006', 'H', 'Oxxo #56, Centro, Coyoacan');
EXEC insertaAlumno('3', '3', 'SAME060309', 'Ester', 'Sanchez', 'Martínez', '06/03/2009', 'M', 'Dakota #425, Paises, Tlalpan');

--Insertar contacto
EXEC insertarContacto('1', '53674398', '9:30-16:00');
EXEC insertarContacto('2', '51783243', '11:45-19:00');
EXEC insertarContacto('3', '56783291', '7:00-13:00');
EXEC insertarContacto('4', '59004938', '9:00-14:00');
EXEC insertarContacto('5', '21342442', '6:00-13:45');
EXEC insertarContacto('6', '53658673', '10:00-16:00');

--Para pruebas
INSERT INTO inscripcion
VALUES ('IN001', '1', '16', '4', '2017-2', 3);

INSERT INTO inscripcion
VALUES ('IN002', '2', '5', '5', '2017-1', 6);

INSERT INTO inscripcion
VALUES ('IN003', '3', '8', '2', '2017-2', 12);

INSERT INTO cargo
VALUES ('NP001', 'IN001', 'S002', default, SYSDATE, NULL, 2000);

INSERT INTO cargo
VALUES ('NP002', 'IN003', 'S002', default, SYSDATE, SYSDATE, 2000);

INSERT INTO cargo
VALUES ('NP003', 'IN001', 'S005', default, SYSDATE, NULL, 500);

INSERT INTO cargo
VALUES ('NP004', 'IN003', 'S005', default,'22/06/17', NULL, 500);

INSERT INTO cargo
VALUES ('NP005', 'IN002', 'S005', default,'22/01/17', NULL, 500


