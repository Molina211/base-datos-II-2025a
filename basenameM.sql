--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: crud_asignaciones_proyecto(character varying, integer, integer, integer, timestamp without time zone, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: grupo2
--

CREATE PROCEDURE public.crud_asignaciones_proyecto(IN p_accion character varying, IN p_id_asignacion_proyecto integer DEFAULT NULL::integer, IN p_id_voluntario integer DEFAULT NULL::integer, IN p_id_proyecto integer DEFAULT NULL::integer, IN p_fecha_asignacion timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_rol character varying DEFAULT NULL::character varying, IN p_estado boolean DEFAULT NULL::boolean)
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


ALTER PROCEDURE public.crud_asignaciones_proyecto(IN p_accion character varying, IN p_id_asignacion_proyecto integer, IN p_id_voluntario integer, IN p_id_proyecto integer, IN p_fecha_asignacion timestamp without time zone, IN p_rol character varying, IN p_estado boolean) OWNER TO grupo2;

--
-- Name: crud_eventos(character varying, integer, character varying, text, timestamp without time zone, timestamp without time zone, character varying, integer, boolean); Type: PROCEDURE; Schema: public; Owner: grupo2
--

CREATE PROCEDURE public.crud_eventos(IN p_accion character varying, IN p_id_evento integer DEFAULT NULL::integer, IN p_nombre character varying DEFAULT NULL::character varying, IN p_descripcion text DEFAULT NULL::text, IN p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_lugar character varying DEFAULT NULL::character varying, IN p_id_proyecto integer DEFAULT NULL::integer, IN p_estado boolean DEFAULT NULL::boolean)
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


ALTER PROCEDURE public.crud_eventos(IN p_accion character varying, IN p_id_evento integer, IN p_nombre character varying, IN p_descripcion text, IN p_fecha_inicio timestamp without time zone, IN p_fecha_fin timestamp without time zone, IN p_lugar character varying, IN p_id_proyecto integer, IN p_estado boolean) OWNER TO grupo2;

--
-- Name: crud_proyectos(character varying, integer, character varying, text, timestamp without time zone, timestamp without time zone, integer, boolean); Type: PROCEDURE; Schema: public; Owner: grupo2
--

CREATE PROCEDURE public.crud_proyectos(IN p_accion character varying, IN p_id_proyecto integer DEFAULT NULL::integer, IN p_nombre character varying DEFAULT NULL::character varying, IN p_descripcion text DEFAULT NULL::text, IN p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_id_estado_proyecto integer DEFAULT NULL::integer, IN p_estado boolean DEFAULT NULL::boolean)
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


ALTER PROCEDURE public.crud_proyectos(IN p_accion character varying, IN p_id_proyecto integer, IN p_nombre character varying, IN p_descripcion text, IN p_fecha_inicio timestamp without time zone, IN p_fecha_fin timestamp without time zone, IN p_id_estado_proyecto integer, IN p_estado boolean) OWNER TO grupo2;

--
-- Name: crud_registro_horas(character varying, integer, integer, integer, timestamp without time zone, numeric, text, boolean); Type: PROCEDURE; Schema: public; Owner: grupo2
--

CREATE PROCEDURE public.crud_registro_horas(IN p_accion character varying, IN p_id_registro_hora integer DEFAULT NULL::integer, IN p_id_voluntario integer DEFAULT NULL::integer, IN p_id_proyecto integer DEFAULT NULL::integer, IN p_fecha timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_horas numeric DEFAULT NULL::numeric, IN p_descripcion text DEFAULT NULL::text, IN p_estado boolean DEFAULT NULL::boolean)
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


ALTER PROCEDURE public.crud_registro_horas(IN p_accion character varying, IN p_id_registro_hora integer, IN p_id_voluntario integer, IN p_id_proyecto integer, IN p_fecha timestamp without time zone, IN p_horas numeric, IN p_descripcion text, IN p_estado boolean) OWNER TO grupo2;

--
-- Name: crud_voluntarios(character varying, integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean); Type: PROCEDURE; Schema: public; Owner: grupo2
--

CREATE PROCEDURE public.crud_voluntarios(IN p_accion character varying, IN p_id_voluntario integer DEFAULT NULL::integer, IN p_nombre character varying DEFAULT NULL::character varying, IN p_apellido character varying DEFAULT NULL::character varying, IN p_email character varying DEFAULT NULL::character varying, IN p_telefono character varying DEFAULT NULL::character varying, IN p_direccion character varying DEFAULT NULL::character varying, IN p_fecha_nacimiento timestamp without time zone DEFAULT NULL::timestamp without time zone, IN p_estado boolean DEFAULT NULL::boolean)
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


ALTER PROCEDURE public.crud_voluntarios(IN p_accion character varying, IN p_id_voluntario integer, IN p_nombre character varying, IN p_apellido character varying, IN p_email character varying, IN p_telefono character varying, IN p_direccion character varying, IN p_fecha_nacimiento timestamp without time zone, IN p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_auditoria_general(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_auditoria_general() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_operacion TEXT;
    v_datos_anteriores JSONB;
    v_datos_nuevos JSONB;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_operacion := 'INSERT';
        v_datos_anteriores := NULL;
        v_datos_nuevos := to_jsonb(NEW);
    ELSIF TG_OP = 'UPDATE' THEN
        v_operacion := 'UPDATE';
        v_datos_anteriores := to_jsonb(OLD);
        v_datos_nuevos := to_jsonb(NEW);
    ELSIF TG_OP = 'DELETE' THEN
        v_operacion := 'DELETE';
        v_datos_anteriores := to_jsonb(OLD);
        v_datos_nuevos := NULL;
    END IF;

    INSERT INTO auditoria_general(tabla_afectada, operacion, usuario, datos_anteriores, datos_nuevos)
    VALUES (TG_TABLE_NAME, v_operacion, current_user, v_datos_anteriores, v_datos_nuevos);

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_auditoria_general() OWNER TO grupo2;

--
-- Name: fn_cambiar_estado_asignacion(integer, boolean); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_cambiar_estado_asignacion(p_id integer, p_estado boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE asignacionesproyecto
    SET estado = p_estado
    WHERE id_asignacion_proyecto = p_id;
END;
$$;


ALTER FUNCTION public.fn_cambiar_estado_asignacion(p_id integer, p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_cambiar_estado_evento(integer, boolean); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_cambiar_estado_evento(p_id integer, p_estado boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE eventos
    SET estado = p_estado
    WHERE id_evento = p_id;
END;
$$;


ALTER FUNCTION public.fn_cambiar_estado_evento(p_id integer, p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_cambiar_estado_proyecto(integer, boolean); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_cambiar_estado_proyecto(p_id integer, p_estado boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE proyectos
    SET estado = p_estado
    WHERE id_proyecto = p_id;
END;
$$;


ALTER FUNCTION public.fn_cambiar_estado_proyecto(p_id integer, p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_cambiar_estado_registrohora(integer, boolean); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_cambiar_estado_registrohora(p_id integer, p_estado boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE registrohoras
    SET estado = p_estado
    WHERE id_registro_hora = p_id;
END;
$$;


ALTER FUNCTION public.fn_cambiar_estado_registrohora(p_id integer, p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_cambiar_estado_voluntario(integer, boolean); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_cambiar_estado_voluntario(p_id integer, p_estado boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE voluntarios
    SET estado = p_estado
    WHERE id_voluntario = p_id;
END;
$$;


ALTER FUNCTION public.fn_cambiar_estado_voluntario(p_id integer, p_estado boolean) OWNER TO grupo2;

--
-- Name: fn_listar_asignaciones_activas(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_listar_asignaciones_activas() RETURNS TABLE(id_asignacion_proyecto integer, id_voluntario integer, id_proyecto integer, fecha_asignacion timestamp without time zone, rol character varying, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id_asignacion_proyecto, id_voluntario, id_proyecto, fecha_asignacion, rol, estado
    FROM asignacionesproyecto
    WHERE estado = TRUE;
END;
$$;


ALTER FUNCTION public.fn_listar_asignaciones_activas() OWNER TO grupo2;

--
-- Name: fn_listar_eventos_activos(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_listar_eventos_activos() RETURNS TABLE(id_evento integer, nombre character varying, descripcion text, fecha_inicio timestamp without time zone, fecha_fin timestamp without time zone, lugar character varying, id_proyecto integer, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id_evento, nombre, descripcion, fecha_inicio, fecha_fin, lugar, id_proyecto, estado
    FROM eventos
    WHERE estado = TRUE;
END;
$$;


ALTER FUNCTION public.fn_listar_eventos_activos() OWNER TO grupo2;

--
-- Name: fn_listar_proyectos_activos(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_listar_proyectos_activos() RETURNS TABLE(id_proyecto integer, nombre character varying, descripcion text, fecha_inicio timestamp without time zone, fecha_fin timestamp without time zone, id_estado_proyecto integer, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id_proyecto, nombre, descripcion, fecha_inicio, fecha_fin, id_estado_proyecto, estado
    FROM proyectos
    WHERE estado = TRUE;
END;
$$;


ALTER FUNCTION public.fn_listar_proyectos_activos() OWNER TO grupo2;

--
-- Name: fn_listar_registrohoras_activos(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_listar_registrohoras_activos() RETURNS TABLE(id_registro_hora integer, id_voluntario integer, id_proyecto integer, fecha timestamp without time zone, horas numeric, descripcion text, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id_registro_hora, id_voluntario, id_proyecto, fecha, horas, descripcion, estado
    FROM registrohoras
    WHERE estado = TRUE;
END;
$$;


ALTER FUNCTION public.fn_listar_registrohoras_activos() OWNER TO grupo2;

--
-- Name: fn_listar_voluntarios_activos(); Type: FUNCTION; Schema: public; Owner: grupo2
--

CREATE FUNCTION public.fn_listar_voluntarios_activos() RETURNS TABLE(id_voluntario integer, nombre character varying, apellido character varying, email character varying, telefono character varying, direccion character varying, fecha_nacimiento timestamp without time zone, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id_voluntario, nombre, apellido, email, telefono, direccion, fecha_nacimiento, estado
    FROM voluntarios
    WHERE estado = TRUE;
END;
$$;


ALTER FUNCTION public.fn_listar_voluntarios_activos() OWNER TO grupo2;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asignacionesproyecto; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.asignacionesproyecto (
    id_asignacion_proyecto integer NOT NULL,
    id_voluntario integer,
    id_proyecto integer,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    rol character varying(100),
    estado boolean DEFAULT true
);


ALTER TABLE public.asignacionesproyecto OWNER TO grupo2;

--
-- Name: asignacionesproyecto_id_asignacion_proyecto_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.asignacionesproyecto_id_asignacion_proyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asignacionesproyecto_id_asignacion_proyecto_seq OWNER TO grupo2;

--
-- Name: asignacionesproyecto_id_asignacion_proyecto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.asignacionesproyecto_id_asignacion_proyecto_seq OWNED BY public.asignacionesproyecto.id_asignacion_proyecto;


--
-- Name: auditoria_general; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.auditoria_general (
    id_auditoria integer NOT NULL,
    tabla_afectada text,
    operacion text,
    usuario text,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores jsonb,
    datos_nuevos jsonb
);


ALTER TABLE public.auditoria_general OWNER TO grupo2;

--
-- Name: auditoria_general_id_auditoria_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.auditoria_general_id_auditoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_general_id_auditoria_seq OWNER TO grupo2;

--
-- Name: auditoria_general_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.auditoria_general_id_auditoria_seq OWNED BY public.auditoria_general.id_auditoria;


--
-- Name: causas; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.causas (
    id_causa integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    estado boolean DEFAULT true
);


ALTER TABLE public.causas OWNER TO grupo2;

--
-- Name: causas_id_causa_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.causas_id_causa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.causas_id_causa_seq OWNER TO grupo2;

--
-- Name: causas_id_causa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.causas_id_causa_seq OWNED BY public.causas.id_causa;


--
-- Name: disponibilidadvoluntario; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.disponibilidadvoluntario (
    id_dispo_voluntario integer NOT NULL,
    id_voluntario integer,
    dia_semana character varying(15),
    hora_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    hora_fin timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado boolean DEFAULT true
);


ALTER TABLE public.disponibilidadvoluntario OWNER TO grupo2;

--
-- Name: disponibilidadvoluntario_id_dispo_voluntario_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.disponibilidadvoluntario_id_dispo_voluntario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.disponibilidadvoluntario_id_dispo_voluntario_seq OWNER TO grupo2;

--
-- Name: disponibilidadvoluntario_id_dispo_voluntario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.disponibilidadvoluntario_id_dispo_voluntario_seq OWNED BY public.disponibilidadvoluntario.id_dispo_voluntario;


--
-- Name: donaciones; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.donaciones (
    id_donancion integer NOT NULL,
    id_donante integer,
    id_proyecto integer,
    monto numeric(10,2),
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    comentario text,
    estado boolean DEFAULT true
);


ALTER TABLE public.donaciones OWNER TO grupo2;

--
-- Name: donaciones_id_donancion_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.donaciones_id_donancion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donaciones_id_donancion_seq OWNER TO grupo2;

--
-- Name: donaciones_id_donancion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.donaciones_id_donancion_seq OWNED BY public.donaciones.id_donancion;


--
-- Name: donantes; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.donantes (
    id_donante integer NOT NULL,
    nombre character varying(150),
    tipo_donante character varying(50),
    contacto character varying(100),
    email character varying(150),
    estado boolean DEFAULT true
);


ALTER TABLE public.donantes OWNER TO grupo2;

--
-- Name: donantes_id_donante_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.donantes_id_donante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donantes_id_donante_seq OWNER TO grupo2;

--
-- Name: donantes_id_donante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.donantes_id_donante_seq OWNED BY public.donantes.id_donante;


--
-- Name: estadosproyecto; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.estadosproyecto (
    id_estado_proyecto integer NOT NULL,
    nombre character varying(50) NOT NULL,
    estado boolean DEFAULT true
);


ALTER TABLE public.estadosproyecto OWNER TO grupo2;

--
-- Name: estadosproyecto_id_estado_proyecto_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.estadosproyecto_id_estado_proyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estadosproyecto_id_estado_proyecto_seq OWNER TO grupo2;

--
-- Name: estadosproyecto_id_estado_proyecto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.estadosproyecto_id_estado_proyecto_seq OWNED BY public.estadosproyecto.id_estado_proyecto;


--
-- Name: eventos; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.eventos (
    id_evento integer NOT NULL,
    nombre character varying(150),
    descripcion text,
    fecha_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_fin timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    lugar character varying(150),
    id_proyecto integer,
    estado boolean DEFAULT true
);


ALTER TABLE public.eventos OWNER TO grupo2;

--
-- Name: eventos_id_evento_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.eventos_id_evento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eventos_id_evento_seq OWNER TO grupo2;

--
-- Name: eventos_id_evento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.eventos_id_evento_seq OWNED BY public.eventos.id_evento;


--
-- Name: habilidadesvoluntario; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.habilidadesvoluntario (
    id_habilidades_voluntario integer NOT NULL,
    id_voluntario integer,
    id_tip_habilidad integer,
    nivel character varying(50),
    "años_experiencia" integer,
    estado boolean DEFAULT true
);


ALTER TABLE public.habilidadesvoluntario OWNER TO grupo2;

--
-- Name: habilidadesvoluntario_id_habilidades_voluntario_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.habilidadesvoluntario_id_habilidades_voluntario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.habilidadesvoluntario_id_habilidades_voluntario_seq OWNER TO grupo2;

--
-- Name: habilidadesvoluntario_id_habilidades_voluntario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.habilidadesvoluntario_id_habilidades_voluntario_seq OWNED BY public.habilidadesvoluntario.id_habilidades_voluntario;


--
-- Name: inscripcionesevento; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.inscripcionesevento (
    id_inscripcion_evento integer NOT NULL,
    id_voluntario integer,
    id_evento integer,
    fecha_inscripcion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    asistencia boolean DEFAULT false,
    estado boolean DEFAULT true
);


ALTER TABLE public.inscripcionesevento OWNER TO grupo2;

--
-- Name: inscripcionesevento_id_inscripcion_evento_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.inscripcionesevento_id_inscripcion_evento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inscripcionesevento_id_inscripcion_evento_seq OWNER TO grupo2;

--
-- Name: inscripcionesevento_id_inscripcion_evento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.inscripcionesevento_id_inscripcion_evento_seq OWNED BY public.inscripcionesevento.id_inscripcion_evento;


--
-- Name: proyectos; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.proyectos (
    id_proyecto integer NOT NULL,
    nombre character varying(150),
    descripcion text,
    fecha_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_fin timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_estado_proyecto integer,
    estado boolean DEFAULT true
);


ALTER TABLE public.proyectos OWNER TO grupo2;

--
-- Name: proyectos_id_proyecto_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.proyectos_id_proyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proyectos_id_proyecto_seq OWNER TO grupo2;

--
-- Name: proyectos_id_proyecto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.proyectos_id_proyecto_seq OWNED BY public.proyectos.id_proyecto;


--
-- Name: proyectoscausa; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.proyectoscausa (
    id_proyecto_causa integer NOT NULL,
    id_proyecto integer,
    id_causa integer,
    estado boolean DEFAULT true
);


ALTER TABLE public.proyectoscausa OWNER TO grupo2;

--
-- Name: proyectoscausa_id_proyecto_causa_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.proyectoscausa_id_proyecto_causa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proyectoscausa_id_proyecto_causa_seq OWNER TO grupo2;

--
-- Name: proyectoscausa_id_proyecto_causa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.proyectoscausa_id_proyecto_causa_seq OWNED BY public.proyectoscausa.id_proyecto_causa;


--
-- Name: registrohoras; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.registrohoras (
    id_registro_hora integer NOT NULL,
    id_voluntario integer,
    id_proyecto integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    horas numeric(10,2),
    descripcion text,
    estado boolean DEFAULT true
);


ALTER TABLE public.registrohoras OWNER TO grupo2;

--
-- Name: registrohoras_id_registro_hora_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.registrohoras_id_registro_hora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registrohoras_id_registro_hora_seq OWNER TO grupo2;

--
-- Name: registrohoras_id_registro_hora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.registrohoras_id_registro_hora_seq OWNED BY public.registrohoras.id_registro_hora;


--
-- Name: tiposhabilidad; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.tiposhabilidad (
    id_tip_habilidad integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    estado boolean DEFAULT true
);


ALTER TABLE public.tiposhabilidad OWNER TO grupo2;

--
-- Name: tiposhabilidad_id_tip_habilidad_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.tiposhabilidad_id_tip_habilidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tiposhabilidad_id_tip_habilidad_seq OWNER TO grupo2;

--
-- Name: tiposhabilidad_id_tip_habilidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.tiposhabilidad_id_tip_habilidad_seq OWNED BY public.tiposhabilidad.id_tip_habilidad;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre_usuario character varying(50),
    email character varying(100),
    rol character varying(50),
    estado boolean DEFAULT true
);


ALTER TABLE public.usuarios OWNER TO grupo2;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO grupo2;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- Name: voluntarios; Type: TABLE; Schema: public; Owner: grupo2
--

CREATE TABLE public.voluntarios (
    id_voluntario integer NOT NULL,
    nombre character varying(100),
    apellido character varying(100),
    email character varying(150),
    telefono character varying(20),
    direccion character varying(50),
    fecha_nacimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado boolean DEFAULT true
);


ALTER TABLE public.voluntarios OWNER TO grupo2;

--
-- Name: vista_asignaciones_proyecto; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vista_asignaciones_proyecto AS
 SELECT a.id_asignacion_proyecto,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS voluntario,
    p.nombre AS proyecto,
    a.rol,
    a.fecha_asignacion
   FROM ((public.asignacionesproyecto a
     JOIN public.voluntarios v ON ((a.id_voluntario = v.id_voluntario)))
     JOIN public.proyectos p ON ((a.id_proyecto = p.id_proyecto)))
  WHERE ((a.estado = true) AND (v.estado = true) AND (p.estado = true));


ALTER VIEW public.vista_asignaciones_proyecto OWNER TO grupo2;

--
-- Name: vista_disponibilidad_voluntarios; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vista_disponibilidad_voluntarios AS
 SELECT v.id_voluntario,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_completo,
    d.dia_semana,
    to_char(d.hora_inicio, 'HH24:MI'::text) AS hora_inicio,
    to_char(d.hora_fin, 'HH24:MI'::text) AS hora_fin
   FROM (public.voluntarios v
     JOIN public.disponibilidadvoluntario d ON ((v.id_voluntario = d.id_voluntario)))
  WHERE ((v.estado = true) AND (d.estado = true));


ALTER VIEW public.vista_disponibilidad_voluntarios OWNER TO grupo2;

--
-- Name: vista_eventos_inscritos; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vista_eventos_inscritos AS
SELECT
    NULL::integer AS id_evento,
    NULL::character varying(150) AS nombre,
    NULL::character varying(150) AS lugar,
    NULL::timestamp without time zone AS fecha_inicio,
    NULL::timestamp without time zone AS fecha_fin,
    NULL::bigint AS total_inscritos;


ALTER VIEW public.vista_eventos_inscritos OWNER TO grupo2;

--
-- Name: vista_registro_horas; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vista_registro_horas AS
 SELECT (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS voluntario,
    p.nombre AS proyecto,
    r.fecha,
    r.horas,
    r.descripcion
   FROM ((public.registrohoras r
     JOIN public.voluntarios v ON ((r.id_voluntario = v.id_voluntario)))
     JOIN public.proyectos p ON ((r.id_proyecto = p.id_proyecto)))
  WHERE ((r.estado = true) AND (v.estado = true) AND (p.estado = true));


ALTER VIEW public.vista_registro_horas OWNER TO grupo2;

--
-- Name: vista_voluntarios_habilidades; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vista_voluntarios_habilidades AS
 SELECT v.id_voluntario,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_completo,
    t.nombre AS habilidad,
    h.nivel,
    h."años_experiencia"
   FROM ((public.voluntarios v
     JOIN public.habilidadesvoluntario h ON ((v.id_voluntario = h.id_voluntario)))
     JOIN public.tiposhabilidad t ON ((h.id_tip_habilidad = t.id_tip_habilidad)))
  WHERE ((v.estado = true) AND (h.estado = true) AND (t.estado = true));


ALTER VIEW public.vista_voluntarios_habilidades OWNER TO grupo2;

--
-- Name: vistaasignacionesproyecto; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistaasignacionesproyecto AS
 SELECT p.nombre AS proyecto,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_voluntario,
    ap.rol,
    ap.fecha_asignacion
   FROM ((public.asignacionesproyecto ap
     JOIN public.voluntarios v ON ((ap.id_voluntario = v.id_voluntario)))
     JOIN public.proyectos p ON ((ap.id_proyecto = p.id_proyecto)))
  WHERE ((ap.estado = true) AND (v.estado = true) AND (p.estado = true));


ALTER VIEW public.vistaasignacionesproyecto OWNER TO grupo2;

--
-- Name: vistadisponibilidadvoluntarios; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistadisponibilidadvoluntarios AS
 SELECT v.id_voluntario,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_completo,
    d.dia_semana,
    d.hora_inicio,
    d.hora_fin
   FROM (public.disponibilidadvoluntario d
     JOIN public.voluntarios v ON ((d.id_voluntario = v.id_voluntario)))
  WHERE ((d.estado = true) AND (v.estado = true));


ALTER VIEW public.vistadisponibilidadvoluntarios OWNER TO grupo2;

--
-- Name: vistadonacionesproyecto; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistadonacionesproyecto AS
 SELECT p.nombre AS proyecto,
    sum(d.monto) AS total_donado
   FROM (public.donaciones d
     JOIN public.proyectos p ON ((d.id_proyecto = p.id_proyecto)))
  WHERE ((d.estado = true) AND (p.estado = true))
  GROUP BY p.nombre;


ALTER VIEW public.vistadonacionesproyecto OWNER TO grupo2;

--
-- Name: vistahabilidadesvoluntarios; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistahabilidadesvoluntarios AS
 SELECT v.id_voluntario,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_completo,
    th.nombre AS habilidad,
    hv.nivel,
    hv."años_experiencia"
   FROM ((public.habilidadesvoluntario hv
     JOIN public.voluntarios v ON ((hv.id_voluntario = v.id_voluntario)))
     JOIN public.tiposhabilidad th ON ((hv.id_tip_habilidad = th.id_tip_habilidad)))
  WHERE ((hv.estado = true) AND (v.estado = true) AND (th.estado = true));


ALTER VIEW public.vistahabilidadesvoluntarios OWNER TO grupo2;

--
-- Name: vistahorasvoluntarios; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistahorasvoluntarios AS
 SELECT v.id_voluntario,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS nombre_completo,
    p.nombre AS proyecto,
    sum(rh.horas) AS total_horas
   FROM ((public.registrohoras rh
     JOIN public.voluntarios v ON ((rh.id_voluntario = v.id_voluntario)))
     JOIN public.proyectos p ON ((rh.id_proyecto = p.id_proyecto)))
  WHERE ((rh.estado = true) AND (v.estado = true) AND (p.estado = true))
  GROUP BY v.id_voluntario, (((v.nombre)::text || ' '::text) || (v.apellido)::text), p.nombre;


ALTER VIEW public.vistahorasvoluntarios OWNER TO grupo2;

--
-- Name: vistainscripcioneseventos; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistainscripcioneseventos AS
 SELECT e.nombre AS evento,
    (((v.nombre)::text || ' '::text) || (v.apellido)::text) AS voluntario,
    ie.fecha_inscripcion,
        CASE
            WHEN ie.asistencia THEN 'Asistió'::text
            ELSE 'No asistió'::text
        END AS asistencia
   FROM ((public.inscripcionesevento ie
     JOIN public.voluntarios v ON ((ie.id_voluntario = v.id_voluntario)))
     JOIN public.eventos e ON ((ie.id_evento = e.id_evento)))
  WHERE ((ie.estado = true) AND (e.estado = true) AND (v.estado = true));


ALTER VIEW public.vistainscripcioneseventos OWNER TO grupo2;

--
-- Name: vistaproyectoscausas; Type: VIEW; Schema: public; Owner: grupo2
--

CREATE VIEW public.vistaproyectoscausas AS
 SELECT p.id_proyecto,
    p.nombre AS nombre_proyecto,
    ep.nombre AS estado_proyecto,
    c.nombre AS causa
   FROM (((public.proyectos p
     JOIN public.estadosproyecto ep ON ((p.id_estado_proyecto = ep.id_estado_proyecto)))
     JOIN public.proyectoscausa pc ON ((p.id_proyecto = pc.id_proyecto)))
     JOIN public.causas c ON ((pc.id_causa = c.id_causa)))
  WHERE ((p.estado = true) AND (ep.estado = true) AND (c.estado = true));


ALTER VIEW public.vistaproyectoscausas OWNER TO grupo2;

--
-- Name: voluntarios_id_voluntario_seq; Type: SEQUENCE; Schema: public; Owner: grupo2
--

CREATE SEQUENCE public.voluntarios_id_voluntario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.voluntarios_id_voluntario_seq OWNER TO grupo2;

--
-- Name: voluntarios_id_voluntario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grupo2
--

ALTER SEQUENCE public.voluntarios_id_voluntario_seq OWNED BY public.voluntarios.id_voluntario;


--
-- Name: asignacionesproyecto id_asignacion_proyecto; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.asignacionesproyecto ALTER COLUMN id_asignacion_proyecto SET DEFAULT nextval('public.asignacionesproyecto_id_asignacion_proyecto_seq'::regclass);


--
-- Name: auditoria_general id_auditoria; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.auditoria_general ALTER COLUMN id_auditoria SET DEFAULT nextval('public.auditoria_general_id_auditoria_seq'::regclass);


--
-- Name: causas id_causa; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.causas ALTER COLUMN id_causa SET DEFAULT nextval('public.causas_id_causa_seq'::regclass);


--
-- Name: disponibilidadvoluntario id_dispo_voluntario; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.disponibilidadvoluntario ALTER COLUMN id_dispo_voluntario SET DEFAULT nextval('public.disponibilidadvoluntario_id_dispo_voluntario_seq'::regclass);


--
-- Name: donaciones id_donancion; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donaciones ALTER COLUMN id_donancion SET DEFAULT nextval('public.donaciones_id_donancion_seq'::regclass);


--
-- Name: donantes id_donante; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donantes ALTER COLUMN id_donante SET DEFAULT nextval('public.donantes_id_donante_seq'::regclass);


--
-- Name: estadosproyecto id_estado_proyecto; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.estadosproyecto ALTER COLUMN id_estado_proyecto SET DEFAULT nextval('public.estadosproyecto_id_estado_proyecto_seq'::regclass);


--
-- Name: eventos id_evento; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.eventos ALTER COLUMN id_evento SET DEFAULT nextval('public.eventos_id_evento_seq'::regclass);


--
-- Name: habilidadesvoluntario id_habilidades_voluntario; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.habilidadesvoluntario ALTER COLUMN id_habilidades_voluntario SET DEFAULT nextval('public.habilidadesvoluntario_id_habilidades_voluntario_seq'::regclass);


--
-- Name: inscripcionesevento id_inscripcion_evento; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.inscripcionesevento ALTER COLUMN id_inscripcion_evento SET DEFAULT nextval('public.inscripcionesevento_id_inscripcion_evento_seq'::regclass);


--
-- Name: proyectos id_proyecto; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectos ALTER COLUMN id_proyecto SET DEFAULT nextval('public.proyectos_id_proyecto_seq'::regclass);


--
-- Name: proyectoscausa id_proyecto_causa; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectoscausa ALTER COLUMN id_proyecto_causa SET DEFAULT nextval('public.proyectoscausa_id_proyecto_causa_seq'::regclass);


--
-- Name: registrohoras id_registro_hora; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.registrohoras ALTER COLUMN id_registro_hora SET DEFAULT nextval('public.registrohoras_id_registro_hora_seq'::regclass);


--
-- Name: tiposhabilidad id_tip_habilidad; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.tiposhabilidad ALTER COLUMN id_tip_habilidad SET DEFAULT nextval('public.tiposhabilidad_id_tip_habilidad_seq'::regclass);


--
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- Name: voluntarios id_voluntario; Type: DEFAULT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.voluntarios ALTER COLUMN id_voluntario SET DEFAULT nextval('public.voluntarios_id_voluntario_seq'::regclass);


--
-- Data for Name: asignacionesproyecto; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.asignacionesproyecto (id_asignacion_proyecto, id_voluntario, id_proyecto, fecha_asignacion, rol, estado) FROM stdin;
1	1	1	2024-01-10 00:00:00	Coordinador	t
2	2	2	2024-02-15 00:00:00	Asistente	t
3	3	3	2024-03-20 00:00:00	Líder	f
4	4	4	2024-04-25 00:00:00	Voluntario	t
6	3	2	2025-05-21 04:52:12.968961	Supervisor	t
5	5	3	2024-05-05 00:00:00	Coordinador	f
\.


--
-- Data for Name: auditoria_general; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.auditoria_general (id_auditoria, tabla_afectada, operacion, usuario, fecha, datos_anteriores, datos_nuevos) FROM stdin;
1	proyectos	INSERT	grupo2	2025-05-21 04:39:37.040266	\N	{"estado": true, "nombre": "Proyecto Ambiental", "fecha_fin": "2025-12-31T00:00:00", "descripcion": "Reforestación en zonas urbanas", "id_proyecto": 6, "fecha_inicio": "2025-06-01T00:00:00", "id_estado_proyecto": 1}
2	proyectos	UPDATE	grupo2	2025-05-21 04:51:02.976958	{"estado": true, "nombre": "Proyecto A", "fecha_fin": "2024-06-01T00:00:00", "descripcion": "Apoyo escolar para niños.", "id_proyecto": 1, "fecha_inicio": "2024-01-01T00:00:00", "id_estado_proyecto": 1}	{"estado": true, "nombre": "Proyecto Ambiental Modificado", "fecha_fin": "2024-06-01T00:00:00", "descripcion": "Apoyo escolar para niños.", "id_proyecto": 1, "fecha_inicio": "2024-01-01T00:00:00", "id_estado_proyecto": 1}
3	asignacionesproyecto	INSERT	grupo2	2025-05-21 04:52:12.968961	\N	{"rol": "Supervisor", "estado": true, "id_proyecto": 2, "id_voluntario": 3, "fecha_asignacion": "2025-05-21T04:52:12.968961", "id_asignacion_proyecto": 6}
4	asignacionesproyecto	UPDATE	grupo2	2025-05-21 04:54:11.28428	{"rol": "Instructor", "estado": true, "id_proyecto": 5, "id_voluntario": 5, "fecha_asignacion": "2024-05-05T00:00:00", "id_asignacion_proyecto": 5}	{"rol": "Coordinador", "estado": true, "id_proyecto": 3, "id_voluntario": 5, "fecha_asignacion": "2024-05-05T00:00:00", "id_asignacion_proyecto": 5}
5	asignacionesproyecto	UPDATE	grupo2	2025-05-21 04:54:39.313612	{"rol": "Coordinador", "estado": true, "id_proyecto": 3, "id_voluntario": 5, "fecha_asignacion": "2024-05-05T00:00:00", "id_asignacion_proyecto": 5}	{"rol": "Coordinador", "estado": false, "id_proyecto": 3, "id_voluntario": 5, "fecha_asignacion": "2024-05-05T00:00:00", "id_asignacion_proyecto": 5}
6	voluntarios	INSERT	grupo2	2025-05-21 04:57:33.935938	\N	{"email": "laura.gomez@email.com", "estado": true, "nombre": "Laura", "apellido": "Gómez", "telefono": "123456789", "direccion": "Av. Libertad 456", "id_voluntario": 6, "fecha_nacimiento": "2025-05-21T04:57:33.935938"}
7	proyectos	UPDATE	grupo2	2025-05-21 04:57:51.664285	{"estado": true, "nombre": "Proyecto Ambiental Modificado", "fecha_fin": "2024-06-01T00:00:00", "descripcion": "Apoyo escolar para niños.", "id_proyecto": 1, "fecha_inicio": "2024-01-01T00:00:00", "id_estado_proyecto": 1}	{"estado": true, "nombre": "Proyecto Ambiental Modificado", "fecha_fin": "2024-06-01T00:00:00", "descripcion": "Nuevo enfoque del proyecto ecológico.", "id_proyecto": 1, "fecha_inicio": "2024-01-01T00:00:00", "id_estado_proyecto": 1}
9	causas	DELETE	grupo2	2025-05-21 05:00:58.841357	{"estado": true, "nombre": "Salud", "id_causa": 3, "descripcion": "Mejorar el acceso a la salud."}	\N
10	proyectoscausa	DELETE	grupo2	2025-05-21 05:00:58.841357	{"estado": true, "id_causa": 3, "id_proyecto": 3, "id_proyecto_causa": 3}	\N
11	registrohoras	INSERT	grupo2	2025-05-21 05:19:42.018317	\N	{"fecha": "2025-05-21T00:00:00", "horas": 4.00, "estado": true, "descripcion": null, "id_proyecto": 2, "id_voluntario": 1, "id_registro_hora": 6}
12	registrohoras	UPDATE	grupo2	2025-05-21 05:21:20.722893	{"fecha": "2024-02-18T00:00:00", "horas": 4.00, "estado": true, "descripcion": "Plantación de árboles", "id_proyecto": 2, "id_voluntario": 2, "id_registro_hora": 2}	{"fecha": "2024-02-18T00:00:00", "horas": 5.00, "estado": true, "descripcion": "Plantación de árboles", "id_proyecto": 2, "id_voluntario": 2, "id_registro_hora": 2}
13	registrohoras	DELETE	grupo2	2025-05-21 05:22:09.485709	{"fecha": "2024-02-18T00:00:00", "horas": 5.00, "estado": true, "descripcion": "Plantación de árboles", "id_proyecto": 2, "id_voluntario": 2, "id_registro_hora": 2}	\N
\.


--
-- Data for Name: causas; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.causas (id_causa, nombre, descripcion, estado) FROM stdin;
1	Educación	Promoción de la educación en comunidades.	t
2	Medio Ambiente	Protección del entorno natural.	t
4	Tecnología	Fomentar habilidades tecnológicas.	f
5	Inclusión Social	Apoyo a grupos vulnerables.	t
\.


--
-- Data for Name: disponibilidadvoluntario; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.disponibilidadvoluntario (id_dispo_voluntario, id_voluntario, dia_semana, hora_inicio, hora_fin, estado) FROM stdin;
1	1	Lunes	2023-01-01 08:00:00	2023-01-01 12:00:00	t
2	2	Martes	2023-01-02 14:00:00	2023-01-02 18:00:00	t
3	3	Miércoles	2023-01-03 09:00:00	2023-01-03 13:00:00	f
4	4	Jueves	2023-01-04 10:00:00	2023-01-04 14:00:00	t
5	5	Viernes	2023-01-05 16:00:00	2023-01-05 20:00:00	t
\.


--
-- Data for Name: donaciones; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.donaciones (id_donancion, id_donante, id_proyecto, monto, fecha, comentario, estado) FROM stdin;
1	1	1	1000.00	2024-01-05 00:00:00	Para material escolar.	t
2	2	2	2500.00	2024-02-10 00:00:00	Campaña ambiental.	t
3	3	3	500.00	2024-03-15 00:00:00	Apoyo comunitario.	t
4	4	4	750.00	2024-04-20 00:00:00	Evento de salud.	f
5	5	5	1200.00	2024-05-25 00:00:00	Taller tecnológico.	t
\.


--
-- Data for Name: donantes; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.donantes (id_donante, nombre, tipo_donante, contacto, email, estado) FROM stdin;
1	Empresa X	Corporativo	Pedro Martínez	contacto@empresaX.com	t
2	Fundación Y	ONG	Laura Díaz	info@fundaciony.org	t
3	Persona A	Individual	Ana Gómez	ana.gomez@example.com	t
4	Empresa Z	Corporativo	Carlos Ruiz	cruiz@empresaz.com	f
5	Persona B	Individual	Luis Navarro	luis.navarro@example.com	t
\.


--
-- Data for Name: estadosproyecto; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.estadosproyecto (id_estado_proyecto, nombre, estado) FROM stdin;
1	En planificación	t
2	En ejecución	t
3	Finalizado	t
4	Cancelado	f
5	Pausado	t
\.


--
-- Data for Name: eventos; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.eventos (id_evento, nombre, descripcion, fecha_inicio, fecha_fin, lugar, id_proyecto, estado) FROM stdin;
1	Evento A	Feria educativa.	2024-02-01 00:00:00	2024-02-02 00:00:00	Escuela Central	1	t
2	Evento B	Reforestación masiva.	2024-03-01 00:00:00	2024-03-01 00:00:00	Parque Nacional	2	t
3	Evento C	Jornada de reciclaje.	2024-04-01 00:00:00	2024-04-01 00:00:00	Centro Comunal	3	t
4	Evento D	Taller de inclusión.	2024-05-01 00:00:00	2024-05-02 00:00:00	Centro Social	4	f
5	Evento E	Hackathon juvenil.	2024-06-01 00:00:00	2024-06-02 00:00:00	Universidad	5	t
\.


--
-- Data for Name: habilidadesvoluntario; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.habilidadesvoluntario (id_habilidades_voluntario, id_voluntario, id_tip_habilidad, nivel, "años_experiencia", estado) FROM stdin;
1	1	1	Intermedio	2	t
2	2	3	Avanzado	4	t
3	3	5	Básico	1	f
4	4	2	Intermedio	3	t
5	5	4	Avanzado	5	t
\.


--
-- Data for Name: inscripcionesevento; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.inscripcionesevento (id_inscripcion_evento, id_voluntario, id_evento, fecha_inscripcion, asistencia, estado) FROM stdin;
1	1	1	2024-01-20 00:00:00	t	t
2	2	2	2024-02-20 00:00:00	f	t
3	3	3	2024-03-25 00:00:00	t	t
4	4	4	2024-04-20 00:00:00	f	f
5	5	5	2024-05-25 00:00:00	t	t
\.


--
-- Data for Name: proyectos; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.proyectos (id_proyecto, nombre, descripcion, fecha_inicio, fecha_fin, id_estado_proyecto, estado) FROM stdin;
2	Proyecto B	Campaña de reforestación.	2024-02-01 00:00:00	2024-08-01 00:00:00	2	t
3	Proyecto C	Reciclaje comunitario.	2024-03-01 00:00:00	2024-09-01 00:00:00	3	t
4	Proyecto D	Atención a adultos mayores.	2024-04-01 00:00:00	2024-10-01 00:00:00	4	f
5	Proyecto E	Talleres de programación.	2024-05-01 00:00:00	2024-11-01 00:00:00	5	t
6	Proyecto Ambiental	Reforestación en zonas urbanas	2025-06-01 00:00:00	2025-12-31 00:00:00	1	t
1	Proyecto Ambiental Modificado	Nuevo enfoque del proyecto ecológico.	2024-01-01 00:00:00	2024-06-01 00:00:00	1	t
\.


--
-- Data for Name: proyectoscausa; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.proyectoscausa (id_proyecto_causa, id_proyecto, id_causa, estado) FROM stdin;
1	1	1	t
2	2	2	t
4	4	5	f
5	5	4	t
\.


--
-- Data for Name: registrohoras; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.registrohoras (id_registro_hora, id_voluntario, id_proyecto, fecha, horas, descripcion, estado) FROM stdin;
1	1	1	2024-01-12 00:00:00	5.50	Clase de matemáticas	t
3	3	3	2024-03-22 00:00:00	3.50	Charla sobre reciclaje	t
4	4	4	2024-04-28 00:00:00	6.00	Apoyo logístico	f
5	5	5	2024-05-07 00:00:00	2.00	Sesión de codificación	t
6	1	2	2025-05-21 00:00:00	4.00	\N	t
\.


--
-- Data for Name: tiposhabilidad; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.tiposhabilidad (id_tip_habilidad, nombre, descripcion, estado) FROM stdin;
1	Primeros Auxilios	Capacitado para asistir en emergencias médicas básicas.	t
2	Logística	Organización de eventos y recursos.	t
3	Comunicación	Habilidades para transmitir mensajes claros.	t
4	Diseño Gráfico	Uso de herramientas gráficas para difusión.	f
5	Programación	Desarrollo de software y aplicaciones.	t
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.usuarios (id_usuario, nombre_usuario, email, rol, estado) FROM stdin;
1	admin1	admin1@example.com	Administrador	t
2	voluntario1	vol1@example.com	Voluntario	t
3	coordinador1	coord1@example.com	Coordinador	t
4	admin2	admin2@example.com	Administrador	f
5	invitado1	invitado1@example.com	Invitado	t
\.


--
-- Data for Name: voluntarios; Type: TABLE DATA; Schema: public; Owner: grupo2
--

COPY public.voluntarios (id_voluntario, nombre, apellido, email, telefono, direccion, fecha_nacimiento, estado) FROM stdin;
1	Juan	Pérez	juan.perez@example.com	1234567890	Calle 1	1990-01-01 00:00:00	t
2	María	Gómez	maria.gomez@example.com	2345678901	Calle 2	1985-05-15 00:00:00	t
3	Luis	Ramírez	luis.ramirez@example.com	3456789012	Calle 3	1992-03-10 00:00:00	f
4	Ana	Torres	ana.torres@example.com	4567890123	Calle 4	1988-08-08 00:00:00	t
5	Carlos	López	carlos.lopez@example.com	5678901234	Calle 5	1995-12-25 00:00:00	t
6	Laura	Gómez	laura.gomez@email.com	123456789	Av. Libertad 456	2025-05-21 04:57:33.935938	t
\.


--
-- Name: asignacionesproyecto_id_asignacion_proyecto_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.asignacionesproyecto_id_asignacion_proyecto_seq', 6, true);


--
-- Name: auditoria_general_id_auditoria_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.auditoria_general_id_auditoria_seq', 13, true);


--
-- Name: causas_id_causa_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.causas_id_causa_seq', 5, true);


--
-- Name: disponibilidadvoluntario_id_dispo_voluntario_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.disponibilidadvoluntario_id_dispo_voluntario_seq', 5, true);


--
-- Name: donaciones_id_donancion_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.donaciones_id_donancion_seq', 5, true);


--
-- Name: donantes_id_donante_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.donantes_id_donante_seq', 5, true);


--
-- Name: estadosproyecto_id_estado_proyecto_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.estadosproyecto_id_estado_proyecto_seq', 5, true);


--
-- Name: eventos_id_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.eventos_id_evento_seq', 5, true);


--
-- Name: habilidadesvoluntario_id_habilidades_voluntario_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.habilidadesvoluntario_id_habilidades_voluntario_seq', 5, true);


--
-- Name: inscripcionesevento_id_inscripcion_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.inscripcionesevento_id_inscripcion_evento_seq', 5, true);


--
-- Name: proyectos_id_proyecto_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.proyectos_id_proyecto_seq', 6, true);


--
-- Name: proyectoscausa_id_proyecto_causa_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.proyectoscausa_id_proyecto_causa_seq', 5, true);


--
-- Name: registrohoras_id_registro_hora_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.registrohoras_id_registro_hora_seq', 6, true);


--
-- Name: tiposhabilidad_id_tip_habilidad_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.tiposhabilidad_id_tip_habilidad_seq', 5, true);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 5, true);


--
-- Name: voluntarios_id_voluntario_seq; Type: SEQUENCE SET; Schema: public; Owner: grupo2
--

SELECT pg_catalog.setval('public.voluntarios_id_voluntario_seq', 6, true);


--
-- Name: asignacionesproyecto asignacionesproyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.asignacionesproyecto
    ADD CONSTRAINT asignacionesproyecto_pkey PRIMARY KEY (id_asignacion_proyecto);


--
-- Name: auditoria_general auditoria_general_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.auditoria_general
    ADD CONSTRAINT auditoria_general_pkey PRIMARY KEY (id_auditoria);


--
-- Name: causas causas_nombre_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.causas
    ADD CONSTRAINT causas_nombre_key UNIQUE (nombre);


--
-- Name: causas causas_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.causas
    ADD CONSTRAINT causas_pkey PRIMARY KEY (id_causa);


--
-- Name: disponibilidadvoluntario disponibilidadvoluntario_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.disponibilidadvoluntario
    ADD CONSTRAINT disponibilidadvoluntario_pkey PRIMARY KEY (id_dispo_voluntario);


--
-- Name: donaciones donaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donaciones
    ADD CONSTRAINT donaciones_pkey PRIMARY KEY (id_donancion);


--
-- Name: donantes donantes_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donantes
    ADD CONSTRAINT donantes_pkey PRIMARY KEY (id_donante);


--
-- Name: estadosproyecto estadosproyecto_nombre_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.estadosproyecto
    ADD CONSTRAINT estadosproyecto_nombre_key UNIQUE (nombre);


--
-- Name: estadosproyecto estadosproyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.estadosproyecto
    ADD CONSTRAINT estadosproyecto_pkey PRIMARY KEY (id_estado_proyecto);


--
-- Name: eventos eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_pkey PRIMARY KEY (id_evento);


--
-- Name: habilidadesvoluntario habilidadesvoluntario_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.habilidadesvoluntario
    ADD CONSTRAINT habilidadesvoluntario_pkey PRIMARY KEY (id_habilidades_voluntario);


--
-- Name: inscripcionesevento inscripcionesevento_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.inscripcionesevento
    ADD CONSTRAINT inscripcionesevento_pkey PRIMARY KEY (id_inscripcion_evento);


--
-- Name: proyectos proyectos_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_pkey PRIMARY KEY (id_proyecto);


--
-- Name: proyectoscausa proyectoscausa_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectoscausa
    ADD CONSTRAINT proyectoscausa_pkey PRIMARY KEY (id_proyecto_causa);


--
-- Name: registrohoras registrohoras_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.registrohoras
    ADD CONSTRAINT registrohoras_pkey PRIMARY KEY (id_registro_hora);


--
-- Name: tiposhabilidad tiposhabilidad_nombre_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.tiposhabilidad
    ADD CONSTRAINT tiposhabilidad_nombre_key UNIQUE (nombre);


--
-- Name: tiposhabilidad tiposhabilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.tiposhabilidad
    ADD CONSTRAINT tiposhabilidad_pkey PRIMARY KEY (id_tip_habilidad);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_nombre_usuario_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: voluntarios voluntarios_email_key; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.voluntarios
    ADD CONSTRAINT voluntarios_email_key UNIQUE (email);


--
-- Name: voluntarios voluntarios_pkey; Type: CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.voluntarios
    ADD CONSTRAINT voluntarios_pkey PRIMARY KEY (id_voluntario);


--
-- Name: idx_hab_habilidad_id; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_hab_habilidad_id ON public.habilidadesvoluntario USING btree (id_habilidades_voluntario);


--
-- Name: idx_hab_voluntario_id; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_hab_voluntario_id ON public.habilidadesvoluntario USING btree (id_voluntario);


--
-- Name: idx_hash_hab_habilidad_id; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_hash_hab_habilidad_id ON public.habilidadesvoluntario USING hash (id_habilidades_voluntario);


--
-- Name: idx_hash_hab_voluntario_id; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_hash_hab_voluntario_id ON public.habilidadesvoluntario USING hash (id_voluntario);


--
-- Name: idx_proyectos_fecha_inicio; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_proyectos_fecha_inicio ON public.proyectos USING btree (fecha_inicio);


--
-- Name: idx_proyectos_nombre_hash; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_proyectos_nombre_hash ON public.proyectos USING hash (nombre);


--
-- Name: idx_registro_voluntario_id; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_registro_voluntario_id ON public.registrohoras USING btree (id_voluntario);


--
-- Name: idx_voluntarios_email; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_voluntarios_email ON public.voluntarios USING btree (email);


--
-- Name: idx_voluntarios_telefono_hash; Type: INDEX; Schema: public; Owner: grupo2
--

CREATE INDEX idx_voluntarios_telefono_hash ON public.voluntarios USING hash (telefono);


--
-- Name: vista_eventos_inscritos _RETURN; Type: RULE; Schema: public; Owner: grupo2
--

CREATE OR REPLACE VIEW public.vista_eventos_inscritos AS
 SELECT e.id_evento,
    e.nombre,
    e.lugar,
    e.fecha_inicio,
    e.fecha_fin,
    count(i.id_inscripcion_evento) AS total_inscritos
   FROM (public.eventos e
     LEFT JOIN public.inscripcionesevento i ON (((e.id_evento = i.id_evento) AND (i.estado = true))))
  WHERE (e.estado = true)
  GROUP BY e.id_evento;


--
-- Name: asignacionesproyecto trg_auditoria_asignacionesproyecto; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_asignacionesproyecto AFTER INSERT OR DELETE OR UPDATE ON public.asignacionesproyecto FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: causas trg_auditoria_causas; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_causas AFTER INSERT OR DELETE OR UPDATE ON public.causas FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: disponibilidadvoluntario trg_auditoria_disponibilidadvoluntario; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_disponibilidadvoluntario AFTER INSERT OR DELETE OR UPDATE ON public.disponibilidadvoluntario FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: donaciones trg_auditoria_donaciones; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_donaciones AFTER INSERT OR DELETE OR UPDATE ON public.donaciones FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: donantes trg_auditoria_donantes; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_donantes AFTER INSERT OR DELETE OR UPDATE ON public.donantes FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: estadosproyecto trg_auditoria_estadosproyecto; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_estadosproyecto AFTER INSERT OR DELETE OR UPDATE ON public.estadosproyecto FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: eventos trg_auditoria_eventos; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_eventos AFTER INSERT OR DELETE OR UPDATE ON public.eventos FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: habilidadesvoluntario trg_auditoria_habilidadesvoluntario; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_habilidadesvoluntario AFTER INSERT OR DELETE OR UPDATE ON public.habilidadesvoluntario FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: inscripcionesevento trg_auditoria_inscripcionesevento; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_inscripcionesevento AFTER INSERT OR DELETE OR UPDATE ON public.inscripcionesevento FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: proyectos trg_auditoria_proyectos; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_proyectos AFTER INSERT OR DELETE OR UPDATE ON public.proyectos FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: proyectoscausa trg_auditoria_proyectoscausa; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_proyectoscausa AFTER INSERT OR DELETE OR UPDATE ON public.proyectoscausa FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: registrohoras trg_auditoria_registrohoras; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_registrohoras AFTER INSERT OR DELETE OR UPDATE ON public.registrohoras FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: tiposhabilidad trg_auditoria_tiposhabilidad; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_tiposhabilidad AFTER INSERT OR DELETE OR UPDATE ON public.tiposhabilidad FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: usuarios trg_auditoria_usuarios; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_usuarios AFTER INSERT OR DELETE OR UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: voluntarios trg_auditoria_voluntarios; Type: TRIGGER; Schema: public; Owner: grupo2
--

CREATE TRIGGER trg_auditoria_voluntarios AFTER INSERT OR DELETE OR UPDATE ON public.voluntarios FOR EACH ROW EXECUTE FUNCTION public.fn_auditoria_general();


--
-- Name: asignacionesproyecto asignacionesproyecto_id_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.asignacionesproyecto
    ADD CONSTRAINT asignacionesproyecto_id_proyecto_fkey FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id_proyecto);


--
-- Name: asignacionesproyecto asignacionesproyecto_id_voluntario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.asignacionesproyecto
    ADD CONSTRAINT asignacionesproyecto_id_voluntario_fkey FOREIGN KEY (id_voluntario) REFERENCES public.voluntarios(id_voluntario);


--
-- Name: disponibilidadvoluntario disponibilidadvoluntario_id_voluntario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.disponibilidadvoluntario
    ADD CONSTRAINT disponibilidadvoluntario_id_voluntario_fkey FOREIGN KEY (id_voluntario) REFERENCES public.voluntarios(id_voluntario);


--
-- Name: donaciones donaciones_id_donante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donaciones
    ADD CONSTRAINT donaciones_id_donante_fkey FOREIGN KEY (id_donante) REFERENCES public.donantes(id_donante);


--
-- Name: donaciones donaciones_id_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.donaciones
    ADD CONSTRAINT donaciones_id_proyecto_fkey FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id_proyecto);


--
-- Name: eventos eventos_id_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_id_proyecto_fkey FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id_proyecto);


--
-- Name: habilidadesvoluntario habilidadesvoluntario_id_tip_habilidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.habilidadesvoluntario
    ADD CONSTRAINT habilidadesvoluntario_id_tip_habilidad_fkey FOREIGN KEY (id_tip_habilidad) REFERENCES public.tiposhabilidad(id_tip_habilidad);


--
-- Name: habilidadesvoluntario habilidadesvoluntario_id_voluntario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.habilidadesvoluntario
    ADD CONSTRAINT habilidadesvoluntario_id_voluntario_fkey FOREIGN KEY (id_voluntario) REFERENCES public.voluntarios(id_voluntario);


--
-- Name: inscripcionesevento inscripcionesevento_id_evento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.inscripcionesevento
    ADD CONSTRAINT inscripcionesevento_id_evento_fkey FOREIGN KEY (id_evento) REFERENCES public.eventos(id_evento);


--
-- Name: inscripcionesevento inscripcionesevento_id_voluntario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.inscripcionesevento
    ADD CONSTRAINT inscripcionesevento_id_voluntario_fkey FOREIGN KEY (id_voluntario) REFERENCES public.voluntarios(id_voluntario);


--
-- Name: proyectos proyectos_id_estado_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_id_estado_proyecto_fkey FOREIGN KEY (id_estado_proyecto) REFERENCES public.estadosproyecto(id_estado_proyecto);


--
-- Name: proyectoscausa proyectoscausa_id_causa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectoscausa
    ADD CONSTRAINT proyectoscausa_id_causa_fkey FOREIGN KEY (id_causa) REFERENCES public.causas(id_causa) ON DELETE CASCADE;


--
-- Name: proyectoscausa proyectoscausa_id_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.proyectoscausa
    ADD CONSTRAINT proyectoscausa_id_proyecto_fkey FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id_proyecto);


--
-- Name: registrohoras registrohoras_id_proyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.registrohoras
    ADD CONSTRAINT registrohoras_id_proyecto_fkey FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id_proyecto);


--
-- Name: registrohoras registrohoras_id_voluntario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grupo2
--

ALTER TABLE ONLY public.registrohoras
    ADD CONSTRAINT registrohoras_id_voluntario_fkey FOREIGN KEY (id_voluntario) REFERENCES public.voluntarios(id_voluntario);


--
-- Name: TABLE asignacionesproyecto; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.asignacionesproyecto TO role_admin_full;
GRANT SELECT,INSERT,UPDATE ON TABLE public.asignacionesproyecto TO role_project_manager;


--
-- Name: SEQUENCE asignacionesproyecto_id_asignacion_proyecto_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.asignacionesproyecto_id_asignacion_proyecto_seq TO role_admin_full;


--
-- Name: TABLE auditoria_general; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.auditoria_general TO role_admin_full;


--
-- Name: SEQUENCE auditoria_general_id_auditoria_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.auditoria_general_id_auditoria_seq TO role_admin_full;


--
-- Name: TABLE causas; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.causas TO role_admin_full;


--
-- Name: SEQUENCE causas_id_causa_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.causas_id_causa_seq TO role_admin_full;


--
-- Name: TABLE disponibilidadvoluntario; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.disponibilidadvoluntario TO role_admin_full;


--
-- Name: SEQUENCE disponibilidadvoluntario_id_dispo_voluntario_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.disponibilidadvoluntario_id_dispo_voluntario_seq TO role_admin_full;


--
-- Name: TABLE donaciones; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.donaciones TO role_admin_full;
GRANT SELECT ON TABLE public.donaciones TO role_project_manager;
GRANT INSERT ON TABLE public.donaciones TO role_donor;


--
-- Name: SEQUENCE donaciones_id_donancion_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.donaciones_id_donancion_seq TO role_admin_full;


--
-- Name: TABLE donantes; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.donantes TO role_admin_full;


--
-- Name: SEQUENCE donantes_id_donante_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.donantes_id_donante_seq TO role_admin_full;


--
-- Name: TABLE estadosproyecto; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.estadosproyecto TO role_admin_full;


--
-- Name: SEQUENCE estadosproyecto_id_estado_proyecto_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.estadosproyecto_id_estado_proyecto_seq TO role_admin_full;


--
-- Name: TABLE eventos; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.eventos TO role_admin_full;
GRANT SELECT,INSERT,UPDATE ON TABLE public.eventos TO role_project_manager;
GRANT SELECT ON TABLE public.eventos TO role_volunteer;


--
-- Name: SEQUENCE eventos_id_evento_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.eventos_id_evento_seq TO role_admin_full;


--
-- Name: TABLE habilidadesvoluntario; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.habilidadesvoluntario TO role_admin_full;


--
-- Name: SEQUENCE habilidadesvoluntario_id_habilidades_voluntario_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.habilidadesvoluntario_id_habilidades_voluntario_seq TO role_admin_full;


--
-- Name: TABLE inscripcionesevento; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.inscripcionesevento TO role_admin_full;
GRANT SELECT ON TABLE public.inscripcionesevento TO role_project_manager;
GRANT INSERT ON TABLE public.inscripcionesevento TO role_volunteer;


--
-- Name: SEQUENCE inscripcionesevento_id_inscripcion_evento_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.inscripcionesevento_id_inscripcion_evento_seq TO role_admin_full;


--
-- Name: TABLE proyectos; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.proyectos TO role_admin_full;
GRANT SELECT ON TABLE public.proyectos TO role_project_manager;
GRANT SELECT ON TABLE public.proyectos TO role_volunteer;
GRANT SELECT ON TABLE public.proyectos TO role_donor;


--
-- Name: SEQUENCE proyectos_id_proyecto_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.proyectos_id_proyecto_seq TO role_admin_full;


--
-- Name: TABLE proyectoscausa; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.proyectoscausa TO role_admin_full;


--
-- Name: SEQUENCE proyectoscausa_id_proyecto_causa_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.proyectoscausa_id_proyecto_causa_seq TO role_admin_full;


--
-- Name: TABLE registrohoras; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.registrohoras TO role_admin_full;
GRANT SELECT,INSERT,UPDATE ON TABLE public.registrohoras TO role_project_manager;
GRANT INSERT ON TABLE public.registrohoras TO role_volunteer;


--
-- Name: SEQUENCE registrohoras_id_registro_hora_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.registrohoras_id_registro_hora_seq TO role_admin_full;


--
-- Name: TABLE tiposhabilidad; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.tiposhabilidad TO role_admin_full;


--
-- Name: SEQUENCE tiposhabilidad_id_tip_habilidad_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.tiposhabilidad_id_tip_habilidad_seq TO role_admin_full;


--
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.usuarios TO role_admin_full;


--
-- Name: SEQUENCE usuarios_id_usuario_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO role_admin_full;


--
-- Name: TABLE voluntarios; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.voluntarios TO role_admin_full;
GRANT SELECT ON TABLE public.voluntarios TO role_project_manager;


--
-- Name: TABLE vista_asignaciones_proyecto; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.vista_asignaciones_proyecto TO role_admin_full;


--
-- Name: TABLE vista_disponibilidad_voluntarios; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.vista_disponibilidad_voluntarios TO role_admin_full;


--
-- Name: TABLE vista_eventos_inscritos; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.vista_eventos_inscritos TO role_admin_full;


--
-- Name: TABLE vista_registro_horas; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.vista_registro_horas TO role_admin_full;


--
-- Name: TABLE vista_voluntarios_habilidades; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON TABLE public.vista_voluntarios_habilidades TO role_admin_full;


--
-- Name: SEQUENCE voluntarios_id_voluntario_seq; Type: ACL; Schema: public; Owner: grupo2
--

GRANT ALL ON SEQUENCE public.voluntarios_id_voluntario_seq TO role_admin_full;


--
-- PostgreSQL database dump complete
--

