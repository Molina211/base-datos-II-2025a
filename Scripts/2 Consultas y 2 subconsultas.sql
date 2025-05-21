Listar voluntarios asignados a un proyecto específico

SELECT v.nombre, v.apellido, ap.rol, ap.fecha_asignacion
FROM Voluntarios v
JOIN AsignacionesProyecto ap ON v.id_voluntario = ap.id_voluntario
WHERE ap.id_proyecto = 1 AND ap.estado = TRUE;

Consulta 2: Total de horas registradas por cada voluntario por proyecto

SELECT v.nombre, v.apellido, p.nombre AS proyecto, SUM(rh.horas) AS total_horas
FROM RegistroHoras rh
JOIN Voluntarios v ON rh.id_voluntario = v.id_voluntario
JOIN Proyectos p ON rh.id_proyecto = p.id_proyecto
WHERE rh.estado = TRUE
GROUP BY v.nombre, v.apellido, p.nombre
ORDER BY total_horas DESC;

Subconsulta 1: Voluntarios que han registrado más de 20 horas en total

SELECT nombre, apellido
FROM Voluntarios
WHERE id_voluntario IN (
    SELECT id_voluntario
    FROM RegistroHoras
    WHERE estado = TRUE
    GROUP BY id_voluntario
    HAVING SUM(horas) > 20
);

Subconsulta 2: Nombre del proyecto con mayor número de asignaciones activas

SELECT nombre
FROM Proyectos
WHERE id_proyecto = (
    SELECT id_proyecto
    FROM AsignacionesProyecto
    WHERE estado = TRUE
    GROUP BY id_proyecto
    ORDER BY COUNT(id_voluntario) DESC
    LIMIT 1
);
