CTE

WITH asignaciones_activas AS (
    SELECT id_proyecto, COUNT(DISTINCT id_voluntario) AS total_voluntarios
    FROM asignacionesproyecto
    WHERE estado = TRUE
    GROUP BY id_proyecto
),
registro_horas_totales AS (
    SELECT id_proyecto, SUM(horas) AS total_horas
    FROM registrohoras
    WHERE estado = TRUE
    GROUP BY id_proyecto
),
proyectos_info AS (
    SELECT p.id_proyecto, p.nombre, p.descripcion, p.id_estado_proyecto, p.estado
    FROM proyectos p
    WHERE p.estado = TRUE
),
estados_proyecto AS (
    SELECT id_estado_proyecto, nombre
    FROM estadosproyecto
    WHERE estado = TRUE
),
proyectos_completo AS (
    SELECT 
        p.nombre AS proyecto,
        p.descripcion,
        e.nombre AS estado_proyecto,
        COALESCE(a.total_voluntarios, 0) AS total_voluntarios,
        COALESCE(r.total_horas, 0) AS total_horas_registradas
    FROM proyectos_info p
    LEFT JOIN asignaciones_activas a ON p.id_proyecto = a.id_proyecto
    LEFT JOIN registro_horas_totales r ON p.id_proyecto = r.id_proyecto
    LEFT JOIN estados_proyecto e ON p.id_estado_proyecto = e.id_estado_proyecto
)
SELECT *
FROM proyectos_completo
ORDER BY total_voluntarios DESC, total_horas_registradas DESC
LIMIT 5;


WITH ProyectoInfo AS (
    SELECT 
        p.id_proyecto,
        p.nombre AS nombre_proyecto,
        c.nombre AS causa,
        COUNT(DISTINCT ap.id_voluntario) AS total_voluntarios
    FROM Proyectos p
    JOIN ProyectosCausa pc ON p.id_proyecto = pc.id_proyecto
    JOIN Causas c ON pc.id_causa = c.id_causa
    JOIN AsignacionesProyecto ap ON p.id_proyecto = ap.id_proyecto
    WHERE p.estado = TRUE AND pc.estado = TRUE
    GROUP BY p.id_proyecto, p.nombre, c.nombre
),
HorasTotales AS (
    SELECT 
        id_proyecto, 
        SUM(horas) AS total_horas
    FROM RegistroHoras
    WHERE estado = TRUE
    GROUP BY id_proyecto
)
SELECT 
    pi.nombre_proyecto,
    pi.causa,
    pi.total_voluntarios,
    COALESCE(ht.total_horas, 0) AS total_horas
FROM ProyectoInfo pi
LEFT JOIN HorasTotales ht ON pi.id_proyecto = ht.id_proyecto;




WITH ProyectoCausas AS (
    SELECT 
        p.id_proyecto,
        c.nombre AS causa
    FROM Proyectos p
    JOIN ProyectosCausa pc ON p.id_proyecto = pc.id_proyecto
    JOIN Causas c ON pc.id_causa = c.id_causa
    WHERE pc.estado = TRUE
),
DonacionesAgrupadas AS (
    SELECT 
        dc.causa,
        COUNT(DISTINCT d.id_donante) AS donantes_unicos,
        SUM(d.monto) AS total_donado
    FROM Donaciones d
    JOIN ProyectoCausas dc ON d.id_proyecto = dc.id_proyecto
    WHERE d.estado = TRUE
    GROUP BY dc.causa
)
SELECT * FROM DonacionesAgrupadas
ORDER BY total_donado DESC;
