PRAGMA foreign_keys = on;
BEGIN TRANSACTION;

DROP TABLE IF EXISTS Gabinete;
DROP TABLE IF EXISTS Curso;
DROP TABLE IF EXISTS Estudante;
DROP TABLE IF EXISTS Prof;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS StaffDoCurso;
DROP TABLE IF EXISTS Leciona;
DROP TABLE IF EXISTS Classificacao;
DROP TABLE IF EXISTS Lab;
DROP TABLE IF EXISTS ProfAssocLab;
DROP TABLE IF EXISTS ComissaoExecutiva;
DROP TABLE IF EXISTS ComissaoCientifica;
DROP TABLE IF EXISTS ComissaoAcompanhamento;
DROP TABLE IF EXISTS Nucleo;
DROP TABLE IF EXISTS EstudanteNucleo;


CREATE TABLE Staff (
	staffID   INTEGER PRIMARY KEY,
	nome      TEXT NOT NULL,
	numTele	  VARCHAR(9) UNIQUE NOT NULL,
	dataNasc  DATE NOT NULL,
	morada    TEXT NOT NULL,
	nif       VARCHAR(9) UNIQUE NOT NULL
);

CREATE TABLE Gabinete (
	numero  VARCHAR(4) PRIMARY KEY 
);

CREATE TABLE Curso (
	codigo    INTEGER	PRIMARY KEY,
	nome      TEXT NOT NULL,
	diretor   INTEGER,
	FOREIGN KEY (diretor) REFERENCES Prof(profID) ON DELETE SET NULL
);

CREATE TABLE StaffDoCurso (
	staffID	  INTEGER PRIMARY KEY,
	codigo	  INTEGER,
	FOREIGN KEY (codigo) REFERENCES Curso(codigo) ON DELETE CASCADE,
	FOREIGN KEY (staffID) REFERENCES Staff(staffID) ON DELETE CASCADE
);

CREATE TABLE Estudante (
	estudanteID	  INTEGER PRIMARY KEY,
	nome 		      TEXT NOT NULL,
	numTele		    VARCHAR(9) UNIQUE NOT NULL,
	dataNasc	    DATE NOT NULL,
	morada		    TEXT NOT NULL,
	regimeTotal   BIT NOT NULL,
	codigoCurso	  INTEGER,
	FOREIGN KEY (codigoCurso) REFERENCES Curso(codigo) ON DELETE SET NULL
);

CREATE TABLE Prof (
	profID    INTEGER PRIMARY KEY,
	nome      TEXT NOT NULL,
	numTele   VARCHAR(9) UNIQUE NOT NULL,
	dataNasc  DATE NOT NULL,
	morada    TEXT NOT NULL,
	nif       VARCHAR(9) UNIQUE,
	numGabin  INTEGER,
	FOREIGN KEY (numGabin) REFERENCES Gabinete(numero) ON DELETE SET NULL
);

CREATE TABLE Leciona  (
	profID        INTEGER,
	codigoCurso   INTEGER,
	PRIMARY KEY (profID, codigoCurso),
	FOREIGN KEY (profID) REFERENCES Prof(profID) ON DELETE CASCADE,
	FOREIGN KEY (codigoCurso) REFERENCES Curso(codigo) ON DELETE CASCADE
);

CREATE TABLE Classificacao (
	estudanteID   INTEGER NOT NULL,
	codigoCurso   INTEGER NOT NULL,
  valor         REAL CHECK (valor >= 0 and valor <= 20),
	PRIMARY KEY (estudanteID, codigoCurso),
	FOREIGN KEY (estudanteID) REFERENCES Estudante(estudanteID) ON DELETE CASCADE,
	FOREIGN KEY (codigoCurso) REFERENCES Curso(codigo) ON DELETE CASCADE
);

CREATE TABLE Lab (
	labID    INTEGER UNIQUE,
	nome    Text Not NULL,
	profID  INTEGER,
	PRIMARY KEY (labID, profID),
	FOREIGN KEY (profID) REFERENCES Prof(profID) ON DELETE SET NULL
);

CREATE TABLE ProfAssocLab (
	profID  INTEGER,
	labID   INTEGER,
	PRIMARY KEY (profID, labID),
	FOREIGN KEY (profID) REFERENCES Prof(profID) ON DELETE CASCADE,
	FOREIGN KEY (labID) REFERENCES Lab(labID) ON DELETE CASCADE
);

CREATE TABLE ComissaoExecutiva (
	profID  INTEGER PRIMARY KEY,
	FOREIGN KEY (profID) REFERENCES Prof(profID) ON DELETE CASCADE
);

CREATE TABLE ComissaoCientifica (
	codigoCurso   INTEGER,
	profID        INTEGER,
	PRIMARY KEY (codigoCurso, profID),
	FOREIGN KEY (codigoCurso) REFERENCES Curso(codigo) ON DELETE CASCADE
);

CREATE TABLE ComissaoAcompanhamento (
	codigoCurso   INTEGER,
	estudanteID   INTEGER,
	profID        INTEGER,
	PRIMARY KEY (codigoCurso, estudanteID, profID),
	FOREIGN KEY (codigoCurso) REFERENCES Curso(codigo) ON DELETE CASCADE,
	FOREIGN KEY (estudanteID) REFERENCES Estudante(estudanteID) ON DELETE SET NULL,
	FOREIGN KEY (profID) REFERENCES Prof(profID) ON DELETE SET NULL
);

CREATE TABLE Nucleo (
	nucleoID  INTEGER PRIMARY KEY,
	nome      Text NOT NULL,
	sala      Text UNIQUE
);

CREATE TABLE EstudanteNucleo (
	estudanteID   INTEGER,
	nucleoID      INTEGER,
	PRIMARY KEY (estudanteID, nucleoID),
	FOREIGN KEY (estudanteID) REFERENCES Estudante(estudanteID) ON DELETE CASCADE,
	FOREIGN KEY (nucleoID) REFERENCES Nucleo(nucleoID) ON DELETE CASCADE
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
