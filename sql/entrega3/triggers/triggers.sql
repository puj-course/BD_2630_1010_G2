-- Triggers entrega 3 - Proyecto Mundial FIFA

-- 1. Auditoria de partidos
-- guarda en auditoria_evento cada cambio que se haga en partido
CREATE OR REPLACE TRIGGER trg_auditoria_partido
AFTER INSERT OR UPDATE OR DELETE ON partido
FOR EACH ROW
DECLARE
  v_id auditoria_evento.id_auditoria%TYPE;
  v_operacion auditoria_evento.operacion%TYPE;
  v_registro auditoria_evento.id_registro%TYPE;
  v_antes auditoria_evento.valor_anterior%TYPE;
  v_despues auditoria_evento.valor_nuevo%TYPE;
BEGIN
  IF INSERTING THEN
    v_operacion := 'INSERT';
    v_registro := :NEW.id_partido;
    v_despues := 'estado=' || :NEW.estado;
  ELSIF UPDATING THEN
    v_operacion := 'UPDATE';
    v_registro := :NEW.id_partido;
    v_antes := 'estado=' || :OLD.estado;
    v_despues := 'estado=' || :NEW.estado;
  ELSE
    v_operacion := 'DELETE';
    v_registro := :OLD.id_partido;
    v_antes := 'estado=' || :OLD.estado;
  END IF;

  -- siguiente id
  SELECT NVL(MAX(id_auditoria), 0) + 1 INTO v_id FROM auditoria_evento;

  INSERT INTO auditoria_evento (id_auditoria, tabla_afectada, operacion, id_registro, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (v_id, 'PARTIDO', v_operacion, v_registro, USER, SYSDATE, v_antes, v_despues);
END trg_auditoria_partido;
/


-- 1. Auditoria de estadisticas
-- lo mismo pero para los goles y asistencias de cada jugador
CREATE OR REPLACE TRIGGER trg_auditoria_estadistica
AFTER INSERT OR UPDATE OR DELETE ON estadistica_jugador_partido
FOR EACH ROW
DECLARE
  v_id auditoria_evento.id_auditoria%TYPE;
  v_operacion auditoria_evento.operacion%TYPE;
  v_registro auditoria_evento.id_registro%TYPE;
  v_antes auditoria_evento.valor_anterior%TYPE;
  v_despues auditoria_evento.valor_nuevo%TYPE;
BEGIN
  IF INSERTING THEN
    v_operacion := 'INSERT';
    v_registro := :NEW.id_estadistica;
    v_despues := 'goles=' || :NEW.goles || ', asistencias=' || :NEW.asistencias;
  ELSIF UPDATING THEN
    v_operacion := 'UPDATE';
    v_registro := :NEW.id_estadistica;
    v_antes := 'goles=' || :OLD.goles || ', asistencias=' || :OLD.asistencias;
    v_despues := 'goles=' || :NEW.goles || ', asistencias=' || :NEW.asistencias;
  ELSE
    v_operacion := 'DELETE';
    v_registro := :OLD.id_estadistica;
    v_antes := 'goles=' || :OLD.goles || ', asistencias=' || :OLD.asistencias;
  END IF;

  SELECT NVL(MAX(id_auditoria), 0) + 1 INTO v_id FROM auditoria_evento;

  INSERT INTO auditoria_evento (id_auditoria, tabla_afectada, operacion, id_registro, usuario, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (v_id, 'ESTADISTICA_JUGADOR_PARTIDO', v_operacion, v_registro, USER, SYSDATE, v_antes, v_despues);
END trg_auditoria_estadistica;
/

-- 2. Validacion de rangos
-- no deja guardar goles ni asistencias negativas en las estadisticas
CREATE OR REPLACE TRIGGER trg_validar_rangos
BEFORE INSERT OR UPDATE ON estadistica_jugador_partido
FOR EACH ROW
BEGIN
  IF :NEW.goles < 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Los goles no pueden ser negativos');
  END IF;

  IF :NEW.asistencias < 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Las asistencias no pueden ser negativas');
  END IF;
END trg_validar_rangos;
/


-- 2. Validacion de rangos en el marcador
-- lo mismo pero para los goles de cada seleccion en el partido
CREATE OR REPLACE TRIGGER trg_validar_rangos_marcador
BEFORE INSERT OR UPDATE ON participacion_partido
FOR EACH ROW
BEGIN
  IF :NEW.goles_marcados < 0 OR :NEW.goles_penales < 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'El marcador no puede tener goles negativos');
  END IF;
END trg_validar_rangos_marcador;
/


