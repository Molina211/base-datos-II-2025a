CTE

WITH HabilidadesVoluntarios AS (
    SELECT 
        hv.id_voluntario,
        STRING_AGG(th.nombre || ' (' || hv.nivel || ')', ', ') AS habilidades
    FROM HabilidadesVoluntario hv
    JOIN TiposHabilidad th ON hv.id_tip_habilidad = th.id_tip_habilidad
    WHERE hv.estado = TRUE AND th.estado = TRUE
    GROUP BY hv.id_voluntario
),
HorasPorVoluntarioProyecto AS (
    SELECT 
        id_voluntario,
        id_proyecto,
        SUM(horas) AS total_horas
    FROM RegistroHoras
    WHERE estado = TRUE
    GROUP BY id_voluntario, id_proyecto
),
EventosVoluntarios AS (
    SELECT 
        ie.id_voluntario,
        COUNT(DISTINCT ie.id_evento) AS total_eventos,
        SUM(CASE WHEN ie.asistencia THEN 1 ELSE 0 END) AS total_asistencias
    FROM InscripcionesEvento ie
    WHERE ie.estado = TRUE
    GROUP BY ie.id_voluntario
),
CausasPorProyecto AS (
    SELECT 
        pc.id_proyecto,
        STRING_AGG(c.nombre, ', ') AS causas
    FROM ProyectosCausa pc
    JOIN Causas c ON pc.id_causa = c.id_causa
    WHERE pc.estado = TRUE AND c.estado = TRUE
    GROUP BY pc.id_proyecto
),
DonacionesPorProyecto AS (
    SELECT 
        d.id_proyecto,
        SUM(d.monto) AS total_donado
    FROM Donaciones d
    WHERE d.estado = TRUE
    GROUP BY d.id_proyecto
)
SELECT 
    v.id_voluntario,
    v.nombre || ' ' || v.apellido AS nombre_completo,
    v.email,
    v.telefono,
    v.direccion,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, v.fecha_nacimiento)) AS edad,
    COALESCE(hv.habilidades, 'Sin habilidades') AS habilidades,
    p.nombre AS proyecto_asignado,
    COALESCE(hpp.total_horas, 0) AS horas_en_proyecto,
    COALESCE(cp.causas, 'Sin causas') AS causas_asociadas,
    COALESCE(dp.total_donado, 0) AS monto_total_donado,
    COALESCE(ev.total_eventos, 0) AS eventos_inscritos,
    COALESCE(ev.total_asistencias, 0) AS eventos_asistidos
FROM Voluntarios v
LEFT JOIN AsignacionesProyecto ap ON ap.id_voluntario = v.id_voluntario AND ap.estado = TRUE
LEFT JOIN Proyectos p ON ap.id_proyecto = p.id_proyecto AND p.estado = TRUE
LEFT JOIN HabilidadesVoluntarios hv ON hv.id_voluntario = v.id_voluntario
LEFT JOIN HorasPorVoluntarioProyecto hpp ON hpp.id_voluntario = v.id_voluntario AND hpp.id_proyecto = p.id_proyecto
LEFT JOIN CausasPorProyecto cp ON cp.id_proyecto = p.id_proyecto
LEFT JOIN DonacionesPorProyecto dp ON dp.id_proyecto = p.id_proyecto
LEFT JOIN EventosVoluntarios ev ON ev.id_voluntario = v.id_voluntario
WHERE v.estado = TRUE
ORDER BY nombre_completo;
