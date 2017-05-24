CREATE TABLE tipoResponsable(
idTipo CHAR(10),
tipoRes VARCHAR2(20) NOT NULL,
CONSTRAINT PkTipoResponsable PRIMARY KEY (idTipo));

CREATE TABLE parentesco(
clvParen CHAR(10),
descripParen VARCHAR2(20) NOT NULL,
CONSTRAINT PKParentesco PRIMARY KEY (clvParen));

CREATE TABLE responsable(
clvRes CHAR(10),
clvParen CHAR(10),
idTipo CHAR(10) NOT NULL,
apPatRes VARCHAR2(20) NOT NULL,
apMatRes VARCHAR2(20),
nomRes VARCHAR2(20) NOT NULL,
fechaNac DATE NOT NULL,
sexoRes CHAR(1) NOT NULL,
celular VARCHAR2(10),
direcResp VARCHAR2(100) NOT NULL,
CONSTRAINT PkClvRes PRIMARY KEY (clvRes),
CONSTRAINT FkResponsableIdTipo FOREIGN KEY (idTipo) REFERENCES tipoResponsable (idTipo),
CONSTRAINT FkResponsableClvParen FOREIGN KEY (clvParen) REFERENCES parentesco (clvParen),
CONSTRAINT CkSexoRes CHECK (sexoRes IN('H','M')));

CREATE TABLE contacto(
clvRes CHAR(10) NOT NULL,
telefono VARCHAR2(10) NOT NULL,
horarioDisp VARCHAR2(20) NOT NULL,
CONSTRAINT FkContactoClvRes FOREIGN KEY (clvRes) REFERENCES responsable (clvRes),
CONSTRAINT PkContacto PRIMARY KEY (clvRes));

CREATE TABLE tutor(
clvTutor CHAR(10),
rfc VARCHAR2(10) NOT NULL,
CONSTRAINT FkTutorClvTutor FOREIGN KEY (clvTutor) REFERENCES responsable (clvRes),
CONSTRAINT PkTutor PRIMARY KEY (clvTutor),
CONSTRAINT UnRFC UNIQUE (rfc));

CREATE TABLE alumno(
clvAlumno CHAR(10),
clvTutor CHAR(10) NOT NULL,
curp CHAR(18) NOT NULL,
nomAlu VARCHAR2(20) NOT NULL,
apPatAlu VARCHAR2(20) NOT NULL,
apMatAlu VARCHAR2(20),
fechaNac DATE NOT NULL,
sexoAlu CHAR(1) NOT NULL,
lugarNac VARCHAR2(100) NOT NULL,
cp CHAR(5) NOT NULL,
CONSTRAINT PkClvAlumno PRIMARY KEY (clvAlumno),
CONSTRAINT FkAlumnoClvTutor FOREIGN KEY (clvTutor) REFERENCES tutor(clvTutor),
CONSTRAINT CkSexoAlu CHECK (sexoAlu IN('H','M')));

CREATE TABLE servicios(
clvServ CHAR(4),
descripServ VARCHAR2(100) NOT NULL,
nomServicio VARCHAR2(30) NOT NULL,
CONSTRAINT PkServicio PRIMARY KEY (clvServ));

CREATE TABLE grado(
numGrado CHAR(1),
CONSTRAINT PkGrado PRIMARY KEY (numGrado),
CONSTRAINT CkNumGrado CHECK(numGrado IN('1','2','3','4','5','6')));

CREATE TABLE grupo(
clvGrupo CHAR(4),
numGrado CHAR(1),
letra CHAR(1) NOT NULL,
CONSTRAINT FkGrupoNumGrado FOREIGN KEY (numGrado) REFERENCES grado (numGrado),
CONSTRAINT PkGrupo PRIMARY KEY (clvGrupo,numGrado));

CREATE TABLE grad_serv(
clvServ CHAR(4),
numGrado CHAR(1),
precio NUMBER(11,2) NOT NULL,
periodoPago NUMBER(2) NOT NULL,
CONSTRAINT FkGrad_ServNumGrado FOREIGN KEY (numGrado) REFERENCES grado (numGrado),
CONSTRAINT PkGrad_Serv PRIMARY KEY (clvServ,numGrado),
CONSTRAINT CkPeriodoPago CHECK(periodoPago IN (1, 2, 3, 6, 10, 12)));

CREATE TABLE inscripcion(
clvInscrip CHAR(10),
clvAlumno CHAR(10) NOT NULL,
clvGrupo CHAR(4) NOT NULL,
numGrado CHAR(1) NOT NULL,
cicloInsc VARCHAR2(10) NOT NULL,
CONSTRAINT PkInscripcion PRIMARY KEY (clvInscrip),
CONSTRAINT FkInscripcionClvAlumno FOREIGN KEY (clvAlumno) REFERENCES alumno (clvAlumno),
CONSTRAINT FKInscripcionGrupo FOREIGN KEY (clvGrupo,numGrado) REFERENCES grupo (clvGrupo,numgrado));

CREATE TABLE cargo(
noNotaCargo CHAR(10),
clvInscrip CHAR(10) NOT NULL,
fechaCrea DATE DEFAULT SYSDATE NOT NULL,
fechaVenc DATE NOT NULL,
fechaPago DATE,
servicio VARCHAR2(20) NOT NULL,
importeCar NUMBER(11,2) NOT NULL,
CONSTRAINT PkCargo PRIMARY KEY (noNotaCargo),
CONSTRAINT FkCargoClvInscrip FOREIGN KEY (clvInscrip) REFERENCES inscripcion (clvInscrip));

CREATE TABLE credito(
noNotaCredito CHAR(10),
clvInscrip CHAR(10) NOT NULL,
referencia CHAR(10) NOT NULL,
fecha DATE NOT NULL,
descuento NUMBER(3) NOT NULL,
importeCre NUMBER(11,2) NOT NULL,
usado CHAR(2) NOT NULL,
CONSTRAINT PkCredito PRIMARY KEY (noNotaCredito),
CONSTRAINT FkCreditoReferencia FOREIGN KEY (referencia) REFERENCES cargo (noNotaCargo));



SET LINE 180;
SET SERVEROUTPUT ON;
