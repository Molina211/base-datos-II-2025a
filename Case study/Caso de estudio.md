# Consulta CTE Completa: Voluntarios Activos y su Participación

## Objetivo

Obtener un informe consolidado de **voluntarios activos** en la organización, incluyendo información clave sobre sus **datos personales**, **habilidades**, **proyectos asignados**, **horas de participación**, **eventos**, **causas involucradas** y el **monto total de donaciones** que han recibido los proyectos donde participan.

---

## Finalidad de la Consulta CTE

Esta consulta permite:

- Visualizar la **participación integral de cada voluntario**.
- Relacionar la actividad del voluntario con **causas sociales y donaciones**.
- Identificar perfiles más comprometidos (por horas, eventos y habilidades).
- Apoyar decisiones sobre **asignación de recursos humanos y financieros**.
- Usarse como base para generar reportes ejecutivos o dashboards en BI.

---

## Explicación General de la Consulta (CTE)

La consulta se compone de varios **Common Table Expressions (CTEs)** que organizan la información por capas:

### 1. `HabilidadesVoluntarios`

Une las tablas `HabilidadesVoluntario` y `TiposHabilidad` para listar las habilidades activas de cada voluntario, incluyendo el nivel, usando `STRING_AGG`.

### 2. `HorasPorVoluntarioProyecto`

Suma las horas trabajadas por cada voluntario en los proyectos registrados en `RegistroHoras`.

### 3. `EventosVoluntarios`

Cuenta los eventos a los que se ha inscrito cada voluntario (`InscripcionesEvento`) y cuántos asistió efectivamente (`asistencia = TRUE`).

### 4. `CausasPorProyecto`

Agrupa las causas sociales asociadas a cada proyecto a través de la relación `ProyectosCausa`.

### 5. `DonacionesPorProyecto`

Suma el total donado a cada proyecto según los registros activos en la tabla `Donaciones`.

### Consulta Final (SELECT)

Une toda la información anterior usando `LEFT JOIN` para no perder voluntarios aunque no tengan todos los datos. Usa `COALESCE` para mostrar valores por defecto cuando no hay datos relacionados.

---

## Código SQL CTE Completo

```sql
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
```

## Conclusión

Esta consulta proporciona una **visión integral y estructurada** de la participación de cada voluntario en la organización.  
Su diseño modular con **CTEs (Common Table Expressions)** mejora la **claridad**, la **reutilización** y el **mantenimiento** del código SQL.  

Además, es ideal para:

- Generar **dashboards de impacto social**.
- Realizar **auditorías de participación y desempeño**.
- Apoyar la **toma de decisiones estratégicas** en temas de voluntariado, eventos y recaudación de fondos.
