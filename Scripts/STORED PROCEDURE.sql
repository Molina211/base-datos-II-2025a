CRUD
CREATE OR REPLACE PROCEDURE crud_voluntarios(
    IN p_accion VARCHAR,               -- 'crear', 'leer', 'actualizar', 'eliminar'
    IN p_id_voluntario INTEGER DEFAULT NULL,
    IN p_nombre VARCHAR DEFAULT NULL,
    IN p_apellido VARCHAR DEFAULT NULL,
    IN p_email VARCHAR DEFAULT NULL,
    IN p_telefono VARCHAR DEFAULT NULL,
    IN p_direccion VARCHAR DEFAULT NULL,
    IN p_fecha_nacimiento TIMESTAMP DEFAULT NULL,
    IN p_estado BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_voluntario RECORD;
BEGIN
    IF p_accion = 'crear' THEN
        INSERT INTO Voluntarios (
            nombre, apellido, email, telefono, direccion, fecha_nacimiento, estado
        ) VALUES (
            p_nombre, p_apellido, p_email, p_telefono, p_direccion, 
            COALESCE(p_fecha_nacimiento, CURRENT_TIMESTAMP), 
            TRUE
        );
        RAISE NOTICE 'Voluntario creado correctamente.';

    ELSIF p_accion = 'actualizar' THEN
        UPDATE Voluntarios
        SET nombre = COALESCE(p_nombre, nombre),
            apellido = COALESCE(p_apellido, apellido),
            email = COALESCE(p_email, email),
            telefono = COALESCE(p_telefono, telefono),
            direccion = COALESCE(p_direccion, direccion),
            fecha_nacimiento = COALESCE(p_fecha_nacimiento, fecha_nacimiento),
            estado = COALESCE(p_estado, estado)
        WHERE id_voluntario = p_id_voluntario;
        RAISE NOTICE 'Voluntario actualizado correctamente.';

    ELSIF p_accion = 'eliminar' THEN
        UPDATE Voluntarios
        SET estado = FALSE
        WHERE id_voluntario = p_id_voluntario;
        RAISE NOTICE 'Voluntario eliminado lógicamente (estado = FALSE).';

    ELSIF p_accion = 'leer' THEN
        FOR v_voluntario IN
            SELECT * FROM Voluntarios
            WHERE id_voluntario = p_id_voluntario
        LOOP
            RAISE NOTICE 'ID: %, Nombre: % %, Email: %, Teléfono: %, Dirección: %, Estado: %',
                v_voluntario.id_voluntario,
                v_voluntario.nombre,
                v_voluntario.apellido,
                v_voluntario.email,
                v_voluntario.telefono,
                v_voluntario.direccion,
                v_voluntario.estado;
        END LOOP;

    ELSE
        RAISE EXCEPTION 'Acción no válida. Use: crear, leer, actualizar o eliminar.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE crud_proyectos(
    IN p_accion VARCHAR,
    IN p_id_proyecto INTEGER DEFAULT NULL,
    IN p_nombre VARCHAR DEFAULT NULL,
    IN p_descripcion TEXT DEFAULT NULL,
    IN p_fecha_inicio TIMESTAMP DEFAULT NULL,
    IN p_fecha_fin TIMESTAMP DEFAULT NULL,
    IN p_id_estado_proyecto INTEGER DEFAULT NULL,
    IN p_estado BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_proyecto RECORD;
BEGIN
    IF p_accion = 'crear' THEN
        INSERT INTO Proyectos(nombre, descripcion, fecha_inicio, fecha_fin, id_estado_proyecto, estado)
        VALUES (
            p_nombre, p_descripcion, 
            COALESCE(p_fecha_inicio, CURRENT_TIMESTAMP),
            COALESCE(p_fecha_fin, CURRENT_TIMESTAMP),
            p_id_estado_proyecto, TRUE
        );
        RAISE NOTICE 'Proyecto creado.';

    ELSIF p_accion = 'actualizar' THEN
        UPDATE Proyectos
        SET nombre = COALESCE(p_nombre, nombre),
            descripcion = COALESCE(p_descripcion, descripcion),
            fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
            fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
            id_estado_proyecto = COALESCE(p_id_estado_proyecto, id_estado_proyecto),
            estado = COALESCE(p_estado, estado)
        WHERE id_proyecto = p_id_proyecto;
        RAISE NOTICE 'Proyecto actualizado.';

    ELSIF p_accion = 'eliminar' THEN
        UPDATE Proyectos SET estado = FALSE WHERE id_proyecto = p_id_proyecto;
        RAISE NOTICE 'Proyecto eliminado lógicamente.';

    ELSIF p_accion = 'leer' THEN
        FOR v_proyecto IN
            SELECT * FROM Proyectos WHERE id_proyecto = p_id_proyecto
        LOOP
            RAISE NOTICE 'ID: %, Nombre: %, Estado: %, Fecha inicio: %, Fecha fin: %',
                v_proyecto.id_proyecto, v_proyecto.nombre, v_proyecto.estado, 
                v_proyecto.fecha_inicio, v_proyecto.fecha_fin;
        END LOOP;
    ELSE
        RAISE EXCEPTION 'Acción inválida.';
    END IF;
END;
$$;


CREATE OR REPLACE PROCEDURE crud_asignaciones_proyecto(
    IN p_accion VARCHAR,
    IN p_id_asignacion_proyecto INTEGER DEFAULT NULL,
    IN p_id_voluntario INTEGER DEFAULT NULL,
    IN p_id_proyecto INTEGER DEFAULT NULL,
    IN p_fecha_asignacion TIMESTAMP DEFAULT NULL,
    IN p_rol VARCHAR DEFAULT NULL,
    IN p_estado BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_asignacion RECORD;
BEGIN
    IF p_accion = 'crear' THEN
        INSERT INTO AsignacionesProyecto(
            id_voluntario, id_proyecto, fecha_asignacion, rol, estado
        ) VALUES (
            p_id_voluntario, p_id_proyecto, 
            COALESCE(p_fecha_asignacion, CURRENT_TIMESTAMP),
            p_rol, TRUE
        );
        RAISE NOTICE 'Asignación creada.';

    ELSIF p_accion = 'actualizar' THEN
        UPDATE AsignacionesProyecto
        SET id_voluntario = COALESCE(p_id_voluntario, id_voluntario),
            id_proyecto = COALESCE(p_id_proyecto, id_proyecto),
            fecha_asignacion = COALESCE(p_fecha_asignacion, fecha_asignacion),
            rol = COALESCE(p_rol, rol),
            estado = COALESCE(p_estado, estado)
        WHERE id_asignacion_proyecto = p_id_asignacion_proyecto;
        RAISE NOTICE 'Asignación actualizada.';

    ELSIF p_accion = 'eliminar' THEN
        UPDATE AsignacionesProyecto SET estado = FALSE WHERE id_asignacion_proyecto = p_id_asignacion_proyecto;
        RAISE NOTICE 'Asignación eliminada lógicamente.';

    ELSIF p_accion = 'leer' THEN
        FOR v_asignacion IN
            SELECT * FROM AsignacionesProyecto WHERE id_asignacion_proyecto = p_id_asignacion_proyecto
        LOOP
            RAISE NOTICE 'ID: %, Proyecto: %, Voluntario: %, Rol: %, Estado: %',
                v_asignacion.id_asignacion_proyecto, v_asignacion.id_proyecto,
                v_asignacion.id_voluntario, v_asignacion.rol, v_asignacion.estado;
        END LOOP;
    ELSE
        RAISE EXCEPTION 'Acción inválida.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE crud_registro_horas(
    IN p_accion VARCHAR,
    IN p_id_registro_hora INTEGER DEFAULT NULL,
    IN p_id_voluntario INTEGER DEFAULT NULL,
    IN p_id_proyecto INTEGER DEFAULT NULL,
    IN p_fecha TIMESTAMP DEFAULT NULL,
    IN p_horas NUMERIC DEFAULT NULL,
    IN p_descripcion TEXT DEFAULT NULL,
    IN p_estado BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_registro RECORD;
BEGIN
    IF p_accion = 'crear' THEN
        INSERT INTO RegistroHoras(
            id_voluntario, id_proyecto, fecha, horas, descripcion, estado
        ) VALUES (
            p_id_voluntario, p_id_proyecto,
            COALESCE(p_fecha, CURRENT_TIMESTAMP),
            p_horas, p_descripcion, TRUE
        );
        RAISE NOTICE 'Registro de horas creado.';

    ELSIF p_accion = 'actualizar' THEN
        UPDATE RegistroHoras
        SET id_voluntario = COALESCE(p_id_voluntario, id_voluntario),
            id_proyecto = COALESCE(p_id_proyecto, id_proyecto),
            fecha = COALESCE(p_fecha, fecha),
            horas = COALESCE(p_horas, horas),
            descripcion = COALESCE(p_descripcion, descripcion),
            estado = COALESCE(p_estado, estado)
        WHERE id_registro_hora = p_id_registro_hora;
        RAISE NOTICE 'Registro de horas actualizado.';

    ELSIF p_accion = 'eliminar' THEN
        UPDATE RegistroHoras SET estado = FALSE WHERE id_registro_hora = p_id_registro_hora;
        RAISE NOTICE 'Registro de horas eliminado lógicamente.';

    ELSIF p_accion = 'leer' THEN
        FOR v_registro IN
            SELECT * FROM RegistroHoras WHERE id_registro_hora = p_id_registro_hora
        LOOP
            RAISE NOTICE 'ID: %, Proyecto: %, Voluntario: %, Horas: %, Fecha: %, Estado: %',
                v_registro.id_registro_hora, v_registro.id_proyecto,
                v_registro.id_voluntario, v_registro.horas,
                v_registro.fecha, v_registro.estado;
        END LOOP;
    ELSE
        RAISE EXCEPTION 'Acción inválida.';
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE crud_eventos(
    IN p_accion VARCHAR,
    IN p_id_evento INTEGER DEFAULT NULL,
    IN p_nombre VARCHAR DEFAULT NULL,
    IN p_descripcion TEXT DEFAULT NULL,
    IN p_fecha_inicio TIMESTAMP DEFAULT NULL,
    IN p_fecha_fin TIMESTAMP DEFAULT NULL,
    IN p_lugar VARCHAR DEFAULT NULL,
    IN p_id_proyecto INTEGER DEFAULT NULL,
    IN p_estado BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_evento RECORD;
BEGIN
    IF p_accion = 'crear' THEN
        INSERT INTO Eventos(
            nombre, descripcion, fecha_inicio, fecha_fin,
            lugar, id_proyecto, estado
        ) VALUES (
            p_nombre, p_descripcion,
            COALESCE(p_fecha_inicio, CURRENT_TIMESTAMP),
            COALESCE(p_fecha_fin, CURRENT_TIMESTAMP),
            p_lugar, p_id_proyecto, TRUE
        );
        RAISE NOTICE 'Evento creado.';

    ELSIF p_accion = 'actualizar' THEN
        UPDATE Eventos
        SET nombre = COALESCE(p_nombre, nombre),
            descripcion = COALESCE(p_descripcion, descripcion),
            fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
            fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
            lugar = COALESCE(p_lugar, lugar),
            id_proyecto = COALESCE(p_id_proyecto, id_proyecto),
            estado = COALESCE(p_estado, estado)
        WHERE id_evento = p_id_evento;
        RAISE NOTICE 'Evento actualizado.';

    ELSIF p_accion = 'eliminar' THEN
        UPDATE Eventos SET estado = FALSE WHERE id_evento = p_id_evento;
        RAISE NOTICE 'Evento eliminado lógicamente.';

    ELSIF p_accion = 'leer' THEN
        FOR v_evento IN
            SELECT * FROM Eventos WHERE id_evento = p_id_evento
        LOOP
            RAISE NOTICE 'ID: %, Nombre: %, Proyecto: %, Lugar: %, Estado: %',
                v_evento.id_evento, v_evento.nombre, v_evento.id_proyecto,
                v_evento.lugar, v_evento.estado;
        END LOOP;
    ELSE
        RAISE EXCEPTION 'Acción inválida.';
    END IF;
END;
$$;
