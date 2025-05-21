CREATE VIEW vista_voluntarios_habilidades AS
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    t.nombre AS habilidad,
    h.nivel,
    h.años_experiencia
FROM Voluntarios v
JOIN HabilidadesVoluntario h ON v.id_voluntario = h.id_voluntario
JOIN TiposHabilidad t ON h.id_tip_habilidad = t.id_tip_habilidad
WHERE v.estado = TRUE AND h.estado = TRUE AND t.estado = TRUE;

CREATE VIEW vista_asignaciones_proyecto AS
SELECT 
    a.id_asignacion_proyecto,
    v.nombre || ' ' || v.apellido AS voluntario,
    p.nombre AS proyecto,
    a.rol,
    a.fecha_asignacion
FROM AsignacionesProyecto a
JOIN Voluntarios v ON a.id_voluntario = v.id_voluntario
JOIN Proyectos p ON a.id_proyecto = p.id_proyecto
WHERE a.estado = TRUE AND v.estado = TRUE AND p.estado = TRUE;

CREATE VIEW vista_registro_horas AS
SELECT 
    v.nombre || ' ' || v.apellido AS voluntario,
    p.nombre AS proyecto,
    r.fecha,
    r.horas,
    r.descripcion
FROM RegistroHoras r
JOIN Voluntarios v ON r.id_voluntario = v.id_voluntario
JOIN Proyectos p ON r.id_proyecto = p.id_proyecto
WHERE r.estado = TRUE AND v.estado = TRUE AND p.estado = TRUE;

CREATE VIEW vista_eventos_inscritos AS
SELECT 
    e.id_evento,
    e.nombre,
    e.lugar,
    e.fecha_inicio,
    e.fecha_fin,
    COUNT(i.id_inscripcion_evento) AS total_inscritos
FROM Eventos e
LEFT JOIN InscripcionesEvento i ON e.id_evento = i.id_evento AND i.estado = TRUE
WHERE e.estado = TRUE
GROUP BY e.id_evento;

CREATE VIEW vista_disponibilidad_voluntarios AS
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    d.dia_semana,
    TO_CHAR(d.hora_inicio, 'HH24:MI') AS hora_inicio,
    TO_CHAR(d.hora_fin, 'HH24:MI') AS hora_fin
FROM Voluntarios v
JOIN DisponibilidadVoluntario d ON v.id_voluntario = d.id_voluntario
WHERE v.estado = TRUE AND d.estado = TRUE;
