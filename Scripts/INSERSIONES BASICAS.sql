INSERT INTO Voluntarios (nombre, apellido, email, telefono, direccion, fecha_nacimiento, estado) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', '1234567890', 'Calle 1', '1990-01-01', TRUE),
('María', 'Gómez', 'maria.gomez@example.com', '2345678901', 'Calle 2', '1985-05-15', TRUE),
('Luis', 'Ramírez', 'luis.ramirez@example.com', '3456789012', 'Calle 3', '1992-03-10', FALSE),
('Ana', 'Torres', 'ana.torres@example.com', '4567890123', 'Calle 4', '1988-08-08', TRUE),
('Carlos', 'López', 'carlos.lopez@example.com', '5678901234', 'Calle 5', '1995-12-25', TRUE);

INSERT INTO TiposHabilidad (nombre, descripcion, estado) VALUES
('Primeros Auxilios', 'Capacitado para asistir en emergencias médicas básicas.', TRUE),
('Logística', 'Organización de eventos y recursos.', TRUE),
('Comunicación', 'Habilidades para transmitir mensajes claros.', TRUE),
('Diseño Gráfico', 'Uso de herramientas gráficas para difusión.', FALSE),
('Programación', 'Desarrollo de software y aplicaciones.', TRUE);

-- HabilidadesVoluntario
INSERT INTO HabilidadesVoluntario (id_voluntario, id_tip_habilidad, nivel, años_experiencia, estado) VALUES
(1, 1, 'Intermedio', 2, TRUE),
(2, 3, 'Avanzado', 4, TRUE),
(3, 5, 'Básico', 1, FALSE),
(4, 2, 'Intermedio', 3, TRUE),
(5, 4, 'Avanzado', 5, TRUE);

-- DisponibilidadVoluntario
INSERT INTO DisponibilidadVoluntario (id_voluntario, dia_semana, hora_inicio, hora_fin, estado) VALUES
(1, 'Lunes', '2023-01-01 08:00:00', '2023-01-01 12:00:00', TRUE),
(2, 'Martes', '2023-01-02 14:00:00', '2023-01-02 18:00:00', TRUE),
(3, 'Miércoles', '2023-01-03 09:00:00', '2023-01-03 13:00:00', FALSE),
(4, 'Jueves', '2023-01-04 10:00:00', '2023-01-04 14:00:00', TRUE),
(5, 'Viernes', '2023-01-05 16:00:00', '2023-01-05 20:00:00', TRUE);

-- EstadosProyecto
INSERT INTO EstadosProyecto (nombre, estado) VALUES
('En planificación', TRUE),
('En ejecución', TRUE),
('Finalizado', TRUE),
('Cancelado', FALSE),
('Pausado', TRUE);

-- Proyectos
INSERT INTO Proyectos (nombre, descripcion, fecha_inicio, fecha_fin, id_estado_proyecto, estado) VALUES
('Proyecto A', 'Apoyo escolar para niños.', '2024-01-01', '2024-06-01', 1, TRUE),
('Proyecto B', 'Campaña de reforestación.', '2024-02-01', '2024-08-01', 2, TRUE),
('Proyecto C', 'Reciclaje comunitario.', '2024-03-01', '2024-09-01', 3, TRUE),
('Proyecto D', 'Atención a adultos mayores.', '2024-04-01', '2024-10-01', 4, FALSE),
('Proyecto E', 'Talleres de programación.', '2024-05-01', '2024-11-01', 5, TRUE);

-- Causas
INSERT INTO Causas (nombre, descripcion, estado) VALUES
('Educación', 'Promoción de la educación en comunidades.', TRUE),
('Medio Ambiente', 'Protección del entorno natural.', TRUE),
('Salud', 'Mejorar el acceso a la salud.', TRUE),
('Tecnología', 'Fomentar habilidades tecnológicas.', FALSE),
('Inclusión Social', 'Apoyo a grupos vulnerables.', TRUE);

-- ProyectosCausa
INSERT INTO ProyectosCausa (id_proyecto, id_causa, estado) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE),
(4, 5, FALSE),
(5, 4, TRUE);

-- AsignacionesProyecto
INSERT INTO AsignacionesProyecto (id_voluntario, id_proyecto, fecha_asignacion, rol, estado) VALUES
(1, 1, '2024-01-10', 'Coordinador', TRUE),
(2, 2, '2024-02-15', 'Asistente', TRUE),
(3, 3, '2024-03-20', 'Líder', FALSE),
(4, 4, '2024-04-25', 'Voluntario', TRUE),
(5, 5, '2024-05-05', 'Instructor', TRUE);

-- RegistroHoras
INSERT INTO RegistroHoras (id_voluntario, id_proyecto, fecha, horas, descripcion, estado) VALUES
(1, 1, '2024-01-12', 5.5, 'Clase de matemáticas', TRUE),
(2, 2, '2024-02-18', 4.0, 'Plantación de árboles', TRUE),
(3, 3, '2024-03-22', 3.5, 'Charla sobre reciclaje', TRUE),
(4, 4, '2024-04-28', 6.0, 'Apoyo logístico', FALSE),
(5, 5, '2024-05-07', 2.0, 'Sesión de codificación', TRUE);

-- Eventos
INSERT INTO Eventos (nombre, descripcion, fecha_inicio, fecha_fin, lugar, id_proyecto, estado) VALUES
('Evento A', 'Feria educativa.', '2024-02-01', '2024-02-02', 'Escuela Central', 1, TRUE),
('Evento B', 'Reforestación masiva.', '2024-03-01', '2024-03-01', 'Parque Nacional', 2, TRUE),
('Evento C', 'Jornada de reciclaje.', '2024-04-01', '2024-04-01', 'Centro Comunal', 3, TRUE),
('Evento D', 'Taller de inclusión.', '2024-05-01', '2024-05-02', 'Centro Social', 4, FALSE),
('Evento E', 'Hackathon juvenil.', '2024-06-01', '2024-06-02', 'Universidad', 5, TRUE);

-- InscripcionesEvento
INSERT INTO InscripcionesEvento (id_voluntario, id_evento, fecha_inscripcion, asistencia, estado) VALUES
(1, 1, '2024-01-20', TRUE, TRUE),
(2, 2, '2024-02-20', FALSE, TRUE),
(3, 3, '2024-03-25', TRUE, TRUE),
(4, 4, '2024-04-20', FALSE, FALSE),
(5, 5, '2024-05-25', TRUE, TRUE);

-- Donantes
INSERT INTO Donantes (nombre, tipo_donante, contacto, email, estado) VALUES
('Empresa X', 'Corporativo', 'Pedro Martínez', 'contacto@empresaX.com', TRUE),
('Fundación Y', 'ONG', 'Laura Díaz', 'info@fundaciony.org', TRUE),
('Persona A', 'Individual', 'Ana Gómez', 'ana.gomez@example.com', TRUE),
('Empresa Z', 'Corporativo', 'Carlos Ruiz', 'cruiz@empresaz.com', FALSE),
('Persona B', 'Individual', 'Luis Navarro', 'luis.navarro@example.com', TRUE);

-- Donaciones
INSERT INTO Donaciones (id_donante, id_proyecto, monto, fecha, comentario, estado) VALUES
(1, 1, 1000.00, '2024-01-05', 'Para material escolar.', TRUE),
(2, 2, 2500.00, '2024-02-10', 'Campaña ambiental.', TRUE),
(3, 3, 500.00, '2024-03-15', 'Apoyo comunitario.', TRUE),
(4, 4, 750.00, '2024-04-20', 'Evento de salud.', FALSE),
(5, 5, 1200.00, '2024-05-25', 'Taller tecnológico.', TRUE);

-- Usuarios
INSERT INTO Usuarios (nombre_usuario, email, rol, estado) VALUES
('admin1', 'admin1@example.com', 'Administrador', TRUE),
('voluntario1', 'vol1@example.com', 'Voluntario', TRUE),
('coordinador1', 'coord1@example.com', 'Coordinador', TRUE),
('admin2', 'admin2@example.com', 'Administrador', FALSE),
('invitado1', 'invitado1@example.com', 'Invitado', TRUE);
