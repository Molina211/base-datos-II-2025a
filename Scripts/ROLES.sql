ROLES
-- ================================
-- 1. CREACIÓN DE USUARIOS (sin nombres reales)
-- ================================
CREATE USER usr_admin WITH PASSWORD '123';
CREATE USER usr_coordinador WITH PASSWORD '123';
CREATE USER usr_voluntario WITH PASSWORD '123';
CREATE USER usr_donante WITH PASSWORD '123';

-- ================================
-- 2. CREACIÓN DE ROLES (sin nombres personales)
-- ================================
CREATE ROLE role_admin_full;         -- Acceso total
CREATE ROLE role_project_manager;    -- Gestión de proyectos
CREATE ROLE role_volunteer;          -- Registro de horas y eventos
CREATE ROLE role_donor;              -- Donaciones únicamente

-- ================================
-- 3. PERMISOS POR ROL
-- ================================

-- role_admin_full: acceso total a todo
GRANT ALL PRIVILEGES ON DATABASE ongs_sistema TO role_admin_full;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin_full;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin_full;

-- role_project_manager: lectura y gestión de proyectos y eventos
GRANT CONNECT ON DATABASE ongs_sistema TO role_project_manager;

GRANT SELECT ON 
    proyectos,
    asignacionesproyecto,
    voluntarios,
    registrohoras,
    eventos,
    inscripcionesevento,
    donaciones
TO role_project_manager;

GRANT INSERT, UPDATE ON 
    asignacionesproyecto,
    registrohoras,
    eventos
TO role_project_manager;

-- role_volunteer: puede registrar horas y asistir a eventos
GRANT CONNECT ON DATABASE ongs_sistema TO role_volunteer;

GRANT SELECT ON 
    proyectos,
    eventos
TO role_volunteer;

GRANT INSERT ON 
    registrohoras,
    inscripcionesevento
TO role_volunteer;

-- role_donor: acceso limitado a donaciones y proyectos
GRANT CONNECT ON DATABASE ongs_sistema TO role_donor;

GRANT SELECT ON 
    proyectos
TO role_donor;

GRANT INSERT ON 
    donaciones
TO role_donor;

-- ================================
-- 4. ASIGNACIÓN DE ROLES A USUARIOS
-- ================================
GRANT role_admin_full TO usr_admin;
GRANT role_project_manager TO usr_coordinador;
GRANT role_volunteer TO usr_voluntario;
GRANT role_donor TO usr_donante;

