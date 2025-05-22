# Consulta CTE Completa: Voluntarios Activos y su Participación

## Objetivo

Generar un informe detallado sobre los **voluntarios activos** en la organización, integrando información clave como sus **datos personales**, **habilidades**, **proyectos asignados**, **horas de trabajo**, **eventos en los que participan**, **causas sociales asociadas** y el **monto de donaciones** recibidas por los proyectos en los que colaboran.

---

## Finalidad de la Consulta CTE

Esta consulta permite:

- Visualizar la **participación integral** de cada voluntario dentro de la organización.
- Relacionar su actividad con **causas sociales** y los **fondos recaudados**.
- Identificar voluntarios con mayor compromiso, según **horas**, **asistencias** y **habilidades**.
- Respaldar la toma de decisiones en **gestión del voluntariado** y **asignación de recursos**.
- Ser fuente de datos para **reportes ejecutivos** y **dashboards en herramientas BI**.

---

## Explicación General de la Consulta (CTE)

Esta consulta está organizada en múltiples **Common Table Expressions (CTEs)** que estructuran la información paso a paso:

### 1. `HabilidadesVoluntarios`

Consolida las habilidades activas de cada voluntario usando `STRING_AGG` para combinarlas en una sola cadena:

- **Fuente:** `HabilidadesVoluntario`, `TiposHabilidad`.
- **Criterio:** Solo habilidades y tipos activos (`estado = TRUE`).

### 2. `HorasPorVoluntarioProyecto`

Calcula la **suma total de horas** trabajadas por cada voluntario en los proyectos:

- **Fuente:** `RegistroHoras`.
- **Agrupación:** por `id_voluntario` y `id_proyecto`.

### 3. `EventosVoluntarios`

Determina la participación en eventos:

- Cuenta eventos inscritos (`total_eventos`).
- Suma eventos con asistencia efectiva (`total_asistencias`).
- **Fuente:** `InscripcionesEvento`.

### 4. `CausasPorProyecto`

Relaciona los proyectos con sus respectivas **causas sociales**, consolidándolas:

- **Fuente:** `ProyectosCausa`, `Causas`.
- Solo relaciones activas.

### 5. `DonacionesPorProyecto`

Suma el **total de donaciones recibidas** por cada proyecto:

- **Fuente:** `Donaciones`.
- Agrupado por `id_proyecto`, considerando solo registros activos.

---

## Consulta Final (SELECT)

En la consulta principal:

- Se integran todas las CTEs mediante `LEFT JOIN` para **preservar voluntarios sin datos relacionados**.
- Se usa `COALESCE` para definir **valores por defecto** en los campos nulos.
- El resultado muestra un perfil completo por voluntario: datos personales, habilidades, proyecto asignado, horas, causas, eventos y donaciones.

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
