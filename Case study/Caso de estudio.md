# Caso de Estudio: Planificación de asignación de voluntarios para un nuevo evento

**Objetivo**: Identificar voluntarios disponibles con ciertas habilidades necesarias para un nuevo evento asociado a un proyecto, y asignarlos provisionalmente si cumplen criterios de experiencia, disponibilidad y no están asignados aún al mismo proyecto.

---

## SQL: Consulta con CTEs

```sql
-- CASO DE ESTUDIO: PLANIFICACIÓN DE ASIGNACIÓN DE VOLUNTARIOS PARA UN NUEVO EVENTO

WITH EventoNuevo AS (
    -- 1. Seleccionar el evento más reciente (puede ser el nuevo)
    SELECT e.id_evento, e.nombre AS nombre_evento, e.id_proyecto, e.fecha_inicio, e.fecha_fin
    FROM Eventos e
    WHERE e.estado = TRUE
    ORDER BY e.fecha_inicio DESC
    LIMIT 1
),
ProyectoDelEvento AS (
    -- 2. Obtener detalles del proyecto asociado al evento
    SELECT p.id_proyecto, p.nombre AS nombre_proyecto
    FROM Proyectos p
    INNER JOIN EventoNuevo ev ON ev.id_proyecto = p.id_proyecto
    WHERE p.estado = TRUE
),
HabilidadesNecesarias AS (
    -- 3. Definir habilidades necesarias para este evento (por ejemplo, 'Organización')
    SELECT th.id_tip_habilidad, th.nombre AS habilidad_requerida
    FROM TiposHabilidad th
    WHERE th.nombre ILIKE 'Organización' AND th.estado = TRUE
),
VoluntariosConHabilidad AS (
    -- 4. Voluntarios que tienen la habilidad necesaria con al menos 2 años de experiencia
    SELECT hv.id_voluntario, hv.id_tip_habilidad, hv.nivel, hv.años_experiencia
    FROM HabilidadesVoluntario hv
    INNER JOIN HabilidadesNecesarias hn ON hn.id_tip_habilidad = hv.id_tip_habilidad
    WHERE hv.estado = TRUE AND hv.años_experiencia >= 2
),
DisponibilidadCompatible AS (
    -- 5. Filtrar voluntarios con disponibilidad en el día del evento
    SELECT dv.id_voluntario, dv.dia_semana, dv.hora_inicio, dv.hora_fin
    FROM DisponibilidadVoluntario dv
    INNER JOIN EventoNuevo ev ON TO_CHAR(ev.fecha_inicio, 'Day') ILIKE dv.dia_semana || '%'
    WHERE dv.estado = TRUE
),
VoluntariosElegibles AS (
    -- 6. Voluntarios que cumplen con habilidades Y disponibilidad
    SELECT DISTINCT v.id_voluntario
    FROM VoluntariosConHabilidad v
    INNER JOIN DisponibilidadCompatible d ON d.id_voluntario = v.id_voluntario
),
VoluntariosNoAsignados AS (
    -- 7. Voluntarios elegibles que aún no están asignados a este proyecto
    SELECT ve.id_voluntario
    FROM VoluntariosElegibles ve
    LEFT JOIN AsignacionesProyecto ap ON ap.id_voluntario = ve.id_voluntario 
        AND ap.id_proyecto = (SELECT id_proyecto FROM ProyectoDelEvento)
    WHERE ap.id_asignacion_proyecto IS NULL
)

-- RESULTADO FINAL: VOLUNTARIOS RECOMENDADOS PARA ASIGNAR AL EVENTO
SELECT 
    v.id_voluntario,
    v.nombre,
    v.apellido,
    v.email,
    v.telefono
FROM Voluntarios v
INNER JOIN VoluntariosNoAsignados va ON va.id_voluntario = v.id_voluntario
WHERE v.estado = TRUE
ORDER BY v.nombre, v.apellido;
```

---

## Resumen de Tablas Utilizadas

| Tabla                      | Descripción                                                  |
| -------------------------- | ------------------------------------------------------------ |
| `Eventos`                  | Evento nuevo a gestionar                                     |
| `Proyectos`                | Proyecto al que pertenece el evento                          |
| `TiposHabilidad`           | Habilidades necesarias para el evento                        |
| `HabilidadesVoluntario`    | Experiencia de los voluntarios en dichas habilidades         |
| `DisponibilidadVoluntario` | Disponibilidad semanal de los voluntarios                    |
| `AsignacionesProyecto`     | Verifica si el voluntario ya está asignado al proyecto       |
| `Voluntarios`              | Datos generales de los voluntarios elegibles para asignación |

---

Esta consulta permite planificar estratégicamente la asignación de voluntarios priorizando la experiencia, compatibilidad horaria y evitando duplicaciones en proyectos.
