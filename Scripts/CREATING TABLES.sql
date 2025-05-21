CREATE TABLE Voluntarios (
    id_voluntario SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(50),
    fecha_nacimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE TiposHabilidad (
    id_tip_habilidad SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE HabilidadesVoluntario (
    id_habilidades_voluntario SERIAL PRIMARY KEY,
    id_voluntario INTEGER REFERENCES Voluntarios(id_voluntario),
    id_tip_habilidad INTEGER REFERENCES TiposHabilidad(id_tip_habilidad),
    nivel VARCHAR(50),
    años_experiencia INTEGER,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE DisponibilidadVoluntario (
    id_dispo_voluntario SERIAL PRIMARY KEY,
    id_voluntario INTEGER REFERENCES Voluntarios(id_voluntario),
    dia_semana VARCHAR(15),
    hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hora_fin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE EstadosProyecto (
    id_estado_proyecto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    estado BOOLEAN DEFAULT TRUE
);


CREATE TABLE Proyectos (
    id_proyecto SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    descripcion TEXT,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_estado_proyecto INTEGER REFERENCES EstadosProyecto(id_estado_proyecto),
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE Causas (
    id_causa SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    estado BOOLEAN DEFAULT TRUE
);
CREATE TABLE ProyectosCausa (
    id_proyecto_causa SERIAL PRIMARY KEY,
    id_proyecto INTEGER REFERENCES Proyectos(id_proyecto),
    id_causa INTEGER REFERENCES Causas(id_causa),
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE AsignacionesProyecto (
    id_asignacion_proyecto SERIAL PRIMARY KEY,
    id_voluntario INTEGER REFERENCES Voluntarios(id_voluntario),
    id_proyecto INTEGER REFERENCES Proyectos(id_proyecto),
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rol VARCHAR(100),
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE RegistroHoras (
    id_registro_hora SERIAL PRIMARY KEY,
    id_voluntario INTEGER REFERENCES Voluntarios(id_voluntario),
    id_proyecto INTEGER REFERENCES Proyectos(id_proyecto),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    horas NUMERIC(10,2),
    descripcion TEXT,
    estado BOOLEAN DEFAULT TRUE
);


CREATE TABLE Eventos (
    id_evento SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    descripcion TEXT,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lugar VARCHAR(150),
    id_proyecto INTEGER REFERENCES Proyectos(id_proyecto),
    estado BOOLEAN DEFAULT TRUE
);


CREATE TABLE InscripcionesEvento (
    id_inscripcion_evento SERIAL PRIMARY KEY,
    id_voluntario INTEGER REFERENCES Voluntarios(id_voluntario),
    id_evento INTEGER REFERENCES Eventos(id_evento),
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    asistencia BOOLEAN DEFAULT FALSE,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE Donantes (
    id_donante SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    tipo_donante VARCHAR(50),
    contacto VARCHAR(100),
    email VARCHAR(150),
    estado BOOLEAN DEFAULT TRUE
);
CREATE TABLE Donaciones (
    id_donancion SERIAL PRIMARY KEY,
    id_donante INTEGER REFERENCES Donantes(id_donante),
    id_proyecto INTEGER REFERENCES Proyectos(id_proyecto),
    monto NUMERIC(10,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT,
    estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    rol VARCHAR(50),
    estado BOOLEAN DEFAULT TRUE
);