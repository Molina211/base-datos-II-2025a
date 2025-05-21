FUNCIONES 

 Ver voluntarios con sus habilidades y nivel

CREATE VIEW VistaHabilidadesVoluntarios AS
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    th.nombre AS habilidad,
    hv.nivel,
    hv.años_experiencia
FROM HabilidadesVoluntario hv
JOIN Voluntarios v ON hv.id_voluntario = v.id_voluntario
JOIN TiposHabilidad th ON hv.id_tip_habilidad = th.id_tip_habilidad
WHERE hv.estado = TRUE AND v.estado = TRUE AND th.estado = TRUE;

-- SELECT
SELECT * FROM VistaHabilidadesVoluntarios;


Ver voluntarios disponibles por día

CREATE VIEW VistaDisponibilidadVoluntarios AS
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    d.dia_semana,
    d.hora_inicio,
    d.hora_fin
FROM DisponibilidadVoluntario d
JOIN Voluntarios v ON d.id_voluntario = v.id_voluntario
WHERE d.estado = TRUE AND v.estado = TRUE;

-- SELECT
SELECT * FROM VistaDisponibilidadVoluntarios WHERE dia_semana = 'Lunes';


 Ver proyectos con su estado y causas asociadas

CREATE VIEW VistaProyectosCausas AS
SELECT 
    p.id_proyecto,
    p.nombre AS nombre_proyecto,
    ep.nombre AS estado_proyecto,
    c.nombre AS causa
FROM Proyectos p
JOIN EstadosProyecto ep ON p.id_estado_proyecto = ep.id_estado_proyecto
JOIN ProyectosCausa pc ON p.id_proyecto = pc.id_proyecto
JOIN Causas c ON pc.id_causa = c.id_causa
WHERE p.estado = TRUE AND ep.estado = TRUE AND c.estado = TRUE;

-- SELECT
SELECT * FROM VistaProyectosCausas WHERE causa ILIKE '%educación%';


Ver horas trabajadas por voluntario en cada proyecto

CREATE VIEW VistaHorasVoluntarios AS
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    p.nombre AS proyecto,
    SUM(rh.horas) AS total_horas
FROM RegistroHoras rh
JOIN Voluntarios v ON rh.id_voluntario = v.id_voluntario
JOIN Proyectos p ON rh.id_proyecto = p.id_proyecto
WHERE rh.estado = TRUE AND v.estado = TRUE AND p.estado = TRUE
GROUP BY v.id_voluntario, nombre_completo, proyecto;

-- SELECT
SELECT * FROM VistaHorasVoluntarios ORDER BY total_horas DESC;


Ver eventos con voluntarios inscritos y su asistencia

CREATE VIEW VistaInscripcionesEventos AS
SELECT 
    e.nombre AS evento,
    v.nombre || ' ' || v.apellido AS voluntario,
    ie.fecha_inscripcion,
    CASE WHEN ie.asistencia THEN 'Asistió' ELSE 'No asistió' END AS asistencia
FROM InscripcionesEvento ie
JOIN Voluntarios v ON ie.id_voluntario = v.id_voluntario
JOIN Eventos e ON ie.id_evento = e.id_evento
WHERE ie.estado = TRUE AND e.estado = TRUE AND v.estado = TRUE;

-- SELECT
SELECT * FROM VistaInscripcionesEventos WHERE asistencia = 'Asistió';


Ver resumen de donaciones por proyecto

CREATE VIEW VistaDonacionesProyecto AS
SELECT 
    p.nombre AS proyecto,
    SUM(d.monto) AS total_donado
FROM Donaciones d
JOIN Proyectos p ON d.id_proyecto = p.id_proyecto
WHERE d.estado = TRUE AND p.estado = TRUE
GROUP BY p.nombre;

-- SELECT
SELECT * FROM VistaDonacionesProyecto ORDER BY total_donado DESC;

