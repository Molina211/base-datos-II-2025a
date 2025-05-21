TRIGERRS

CREATE TABLE auditoria_general (
    id_auditoria SERIAL PRIMARY KEY,
    tabla_afectada TEXT,
    operacion TEXT,
    usuario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores JSONB,
    datos_nuevos JSONB
);

CREATE OR REPLACE FUNCTION fn_auditoria_general()
RETURNS TRIGGER
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

CREATE TRIGGER trg_auditoria_voluntarios
AFTER INSERT OR UPDATE OR DELETE ON voluntarios
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_tiposhabilidad
AFTER INSERT OR UPDATE OR DELETE ON tiposhabilidad
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_habilidadesvoluntario
AFTER INSERT OR UPDATE OR DELETE ON habilidadesvoluntario
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_disponibilidadvoluntario
AFTER INSERT OR UPDATE OR DELETE ON disponibilidadvoluntario
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_estadosproyecto
AFTER INSERT OR UPDATE OR DELETE ON estadosproyecto
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_proyectos
AFTER INSERT OR UPDATE OR DELETE ON proyectos
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_causas
AFTER INSERT OR UPDATE OR DELETE ON causas
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_proyectoscausa
AFTER INSERT OR UPDATE OR DELETE ON proyectoscausa
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_asignacionesproyecto
AFTER INSERT OR UPDATE OR DELETE ON asignacionesproyecto
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_registrohoras
AFTER INSERT OR UPDATE OR DELETE ON registrohoras
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_eventos
AFTER INSERT OR UPDATE OR DELETE ON eventos
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_inscripcionesevento
AFTER INSERT OR UPDATE OR DELETE ON inscripcionesevento
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_donantes
AFTER INSERT OR UPDATE OR DELETE ON donantes
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_donaciones
AFTER INSERT OR UPDATE OR DELETE ON donaciones
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

CREATE TRIGGER trg_auditoria_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_general();

