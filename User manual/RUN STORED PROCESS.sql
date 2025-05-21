-- Crear un proyecto
CALL crud_proyectos('crear', NULL, 'Proyecto Ambiental', 'Reforestación en zonas urbanas', '2025-06-01', '2025-12-31', 1);

-- Actualizar un proyecto
CALL crud_proyectos('actualizar', 1, 'Proyecto Ambiental Modificado');

-- Eliminar un proyecto lógicamente
CALL crud_proyectos('eliminar', 1);

-- Leer un proyecto
CALL crud_proyectos('leer', 1);


-- Crear registro de horas
CALL crud_registro_horas('crear', NULL, 2, 1, '2025-05-20', 5.5, 'Colaboración en taller');

-- Actualizar registro de horas
CALL crud_registro_horas('actualizar', 1, NULL, NULL, NULL, 6.0);

-- Eliminar lógicamente
CALL crud_registro_horas('eliminar', 1);

-- Leer
CALL crud_registro_horas('leer', 1);


-- Crear evento
CALL crud_eventos('crear', NULL, 'Charla sobre Medio Ambiente', 'Evento educativo para concientizar', '2025-06-05 10:00', '2025-06-05 12:00', 'Auditorio Central', 1);

-- Actualizar evento
CALL crud_eventos('actualizar', 1, 'Charla Ambiental Modificada');

-- Eliminar
CALL crud_eventos('eliminar', 1);

-- Leer
CALL crud_eventos('leer', 1);

CALL crud_voluntarios('crear', NULL, 'Juan', 'Pérez', 'juan.perez@email.com', '123456789', 'Av. Siempre Viva 742', '1990-03-15');
CALL crud_voluntarios('actualizar', 1, NULL, NULL, NULL, '987654321', 'Calle Nueva 123', NULL);
CALL crud_voluntarios('eliminar', 1);
CALL crud_voluntarios('leer', 1);

CALL crud_asignaciones('crear', NULL, 1, 2, '2025-05-20', 'Coordinador');
CALL crud_asignaciones('actualizar', 1, NULL, NULL, NULL, 'Voluntario General');
CALL crud_asignaciones('eliminar', 1);
CALL crud_asignaciones('leer', 1);