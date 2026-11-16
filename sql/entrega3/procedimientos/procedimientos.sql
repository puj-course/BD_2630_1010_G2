-- Procedimientos - Entrega 3 - Proyecto mundial FIFA 

SET SERVEROUTPUT ON; 

-- BLOQUE A: Carga masiva controlada de resultados de partidos 

-- 1. Registrar el resultado de un partido 
-- Recibe el partido y los goles tanto del local como del visitante
-- Valida los datos y calcula quien gano (G/E/P) y deja el estado en FINALIZADO
-- Si algo falla hace ROLLBACK

CREATE OR REPLACE PROCEDURE pr_registrar_resultado
  (p_id_partido IN partido.id_partido%TYPE,
   p_goles_local IN participacion_partido.goles_marcados%TYPE,
   p_goles_visitante IN participacion_partido.goles_marcados%TYPE)
AS
  v_estado  partido.estado%TYPE;
  v_res_local  participacion_partido.resultado%TYPE;
  v_res_visitante  participacion_partido.resultado%TYPE;

  e_goles_negativos EXCEPTION;
  e_sin_participacion EXCEPTION;
  e_partido_finalizado EXCEPTION;
BEGIN
  -- 1. los goles no pueden ser negativos 
  IF p_goles_local < 0 OR p_goles_visitante < 0 THEN 
    RAISE e_goles_negativos;
  END IF;

  -- 2. el partido debe existir y no estar finalizado
  SELECT estado 
    INTO v_estado 
    FROM partido
   WHERE id_partido = p_id_partido;

   IF v_estado = 'FINALIZADO' THEN
     RAISE e_partido_finalizado;
   END IF;

  -- 3. Calcular el resultado de cada selección 
  IF p_goles_local > p_goles_visitante THEN
     v_res_local := 'G';
     v_res_visitante := 'P';
  ELSIF p_goles_local < p_goles_visitante THEN
     v_res_local := 'P';
     v_res_visitante := 'G';
  ELSE
     v_res_local := 'E';
     v_res_visitante := 'E';
  END IF;

  -- 4. Guardar los goles y el resultado del local
  UPDATE participacion_partido
    SET goles_marcados = p_goles_local,
        resultado = v_res_local
     WHERE id_partido = p_id_partido
       AND condicion = 'LOCAL';
    
    IF SQL%ROWCOUNT = 0 THEN
      RAISE e_sin_participacion;
    END IF;

  -- 5. Guardar los goles y el resultado del visitante
  UPDATE participacion_partido
    SET goles_marcados = p_goles_visitante,
        resultado = v_res_visitante
     WHERE id_partido = p_id_partido 
       AND condicion = 'VISITANTE';

    IF SQL%ROWCOUNT = 0 THEN 
      RAISE e_sin_participacion;
    END IF;

  --6. el partido queda finalizado 
  UPDATE partido
     SET estado = 'FINALIZADO'
   WHERE id_partido = p_id_partido;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Resultado registrado: partido ' || p_id_partido ||
                       ' (' || p_goles_local || ' - ' || p_goles_visitante || ')');
EXCEPTION
  WHEN e_goles_negativos THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: los goles no pueden ser negativos.');
  WHEN e_partido_finalizado THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: el partido ' || p_id_partido || ' ya esta finalizado.');
  WHEN e_sin_participacion THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: el partido ' || p_id_partido || ' no tiene local y visitante registrados.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: el partido ' || p_id_partido || ' no existe.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END pr_registrar_resultado;
/


-- 2. Carga masiva controlada de resultados 
-- Cierra los partidos de la fase que aun no tienen resultado oficial (EN_JUEGO),
-- usando como marcador la suma de los goles que ya se cargaron en las estadisticas de los jugadores
-- Cada partido tiene su SAVEPOINT, si uno falla solo se deshace ese y sigue con los demas

CREATE OR REPLACE PROCEDURE pr_carga_masiva_resultados
  (p_id_fase IN fase.id_fase%TYPE)
AS
  CURSOR c_partidos (p_fase NUMBER) IS
    SELECT id_partido
      FROM partido
     WHERE id_fase = p_fase
       AND estado = 'EN_JUEGO'
     ORDER BY fecha_hora;

  v_id_partido      partido.id_partido%TYPE;
  v_sel_local       seleccion.id_seleccion%TYPE;
  v_sel_visitante   seleccion.id_seleccion%TYPE;
  v_goles_local     NUMBER;
  v_goles_visitante NUMBER;
  v_estadisticas    NUMBER;
  v_res_local       CHAR(1);
  v_res_visitante   CHAR(1);
  v_cargados        NUMBER := 0;
  v_sin_datos       NUMBER := 0;
  v_fallidos        NUMBER := 0;
BEGIN
  OPEN c_partidos(p_id_fase);
  LOOP
    FETCH c_partidos INTO v_id_partido;
    EXIT WHEN c_partidos%NOTFOUND;

    SELECT COUNT(*)
      INTO v_estadisticas
      FROM estadistica_jugador_partido
     WHERE id_partido = v_id_partido;

    IF v_estadisticas = 0 THEN
      v_sin_datos := v_sin_datos + 1;
      DBMS_OUTPUT.PUT_LINE('Partido ' || v_id_partido || ': no tiene estadisticas, no se carga');
    ELSE
      SAVEPOINT sp_partido;
      BEGIN
        SELECT id_seleccion INTO v_sel_local
          FROM participacion_partido
         WHERE id_partido = v_id_partido AND condicion = 'LOCAL';

        SELECT id_seleccion INTO v_sel_visitante
          FROM participacion_partido
         WHERE id_partido = v_id_partido AND condicion = 'VISITANTE';

        -- goles de cada seleccion segun sus jugadores
        SELECT NVL(SUM(e.goles), 0)
          INTO v_goles_local
          FROM estadistica_jugador_partido e
          JOIN convocatoria_jugador c ON c.id_convocatoria = e.id_convocatoria
         WHERE e.id_partido = v_id_partido
           AND c.id_seleccion = v_sel_local;

        SELECT NVL(SUM(e.goles), 0)
          INTO v_goles_visitante
          FROM estadistica_jugador_partido e
          JOIN convocatoria_jugador c ON c.id_convocatoria = e.id_convocatoria
         WHERE e.id_partido = v_id_partido
           AND c.id_seleccion = v_sel_visitante;

        IF v_goles_local > v_goles_visitante THEN
          v_res_local := 'G';
          v_res_visitante := 'P';
        ELSIF v_goles_local = v_goles_visitante THEN
          v_res_local := 'E';
          v_res_visitante := 'E';
        ELSE
          v_res_local := 'P';
          v_res_visitante := 'G';
        END IF;

        UPDATE participacion_partido
           SET goles_marcados = v_goles_local, resultado = v_res_local
         WHERE id_partido = v_id_partido AND condicion = 'LOCAL';

        UPDATE participacion_partido
           SET goles_marcados = v_goles_visitante, resultado = v_res_visitante
         WHERE id_partido = v_id_partido AND condicion = 'VISITANTE';

        UPDATE partido
          SET estado = 'FINALIZADO'
         WHERE id_partido = v_id_partido;

        v_cargados := v_cargados + 1;
        DBMS_OUTPUT.PUT_LINE('Partido ' || v_id_partido || ': ' || v_goles_local || ' - ' || v_goles_visitante);
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK TO sp_partido;
          v_fallidos := v_fallidos + 1;
          DBMS_OUTPUT.PUT_LINE('Partido ' || v_id_partido || ': no se pudo cargar (' || SQLERRM || ')');
      END;
    END IF;
  END LOOP;
  CLOSE c_partidos;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Cargados: ' || v_cargados || ', sin estadisticas: ' || v_sin_datos
                       || ', con error: ' || v_fallidos);
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF c_partidos%ISOPEN THEN
      CLOSE c_partidos;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Error en la carga masiva: ' || SQLERRM);
END pr_carga_masiva_resultados;
/


-- BLOQUE B: Actualización de la tabla de posiciones por cada grupo

-- 3. Tabla de posiciones de un grupo 
-- Muestra las selecciones del grupo ordenada por puntos y diferencia de goles, usando las funciones fn_puntos_seleccion y fn_diferencia_gol

CREATE OR REPLACE PROCEDURE pr_tabla_posiciones
  (p_id_grupo IN grupo.id_grupo%TYPE)
AS
  CURSOR c_posiciones (p_grupo NUMBER) IS
    SELECT s.id_seleccion, f.pais
      FROM seleccion s
      JOIN federacion f ON f.id_federacion = s.id_federacion
     WHERE s.id_grupo = p_grupo
     ORDER BY fn_puntos_seleccion (s.id_seleccion) DESC,
              fn_diferencia_gol (s.id_seleccion) DESC,
              f.pais;

  v_nombre_grupo  grupo.nombre%TYPE;
  v_pais  federacion.pais%TYPE;
  v_puesto  NUMBER := 0;
  v_id_seleccion  seleccion.id_seleccion%TYPE;

BEGIN
 -- si el grupo no existe salta NO_DATA_FOUND
  SELECT nombre
    INTO v_nombre_grupo
    FROM grupo
   WHERE id_grupo = p_id_grupo;

  DBMS_OUTPUT.PUT_LINE('Tabla de posiciones - Grupo ' || v_nombre_grupo);

  OPEN c_posiciones(p_id_grupo);
  LOOP
    FETCH c_posiciones INTO v_id_seleccion, v_pais;
    EXIT WHEN c_posiciones%NOTFOUND;
    v_puesto := v_puesto + 1;
    DBMS_OUTPUT.PUT_LINE(v_puesto || '. ' || v_pais || ' - ' || fn_puntos_seleccion(v_id_seleccion) || ' pts - DG '|| fn_diferencia_gol(v_id_seleccion));
  END LOOP;
  CLOSE c_posiciones;

  IF v_puesto = 0 THEN
    DBMS_OUTPUT.PUT_LINE('El grupo no tiene selecciones');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: el grupo ' || p_id_grupo || ' no existe');
END pr_tabla_posiciones;
/


-- BLOQUE C: Cierre de fase

-- 4. Cierre de la fase de grupos (avance automatico de los clasificados)
-- Si todos los partidos de grupos estan FINALIZADO, pasan los 2 primeros de cada grupo
-- y se programan los partidos de la siguiente fase: 1A vs 2B, 1B vs 2A (y asi con C-D, E-F...)

CREATE OR REPLACE PROCEDURE pr_cierre_fase
  (p_id_fase IN fase.id_fase%TYPE)
AS
  CURSOR c_grupos (p_fase NUMBER) IS
    SELECT id_grupo, nombre
      FROM grupo
     WHERE id_fase = p_fase
     ORDER BY nombre;

  v_nombre_fase   fase.nombre%TYPE;
  v_siguiente     fase.id_fase%TYPE;
  v_pendientes    NUMBER;
  v_id_grupo      grupo.id_grupo%TYPE;
  v_nombre_grupo  grupo.nombre%TYPE;
  v_primero       seleccion.id_seleccion%TYPE;
  v_segundo       seleccion.id_seleccion%TYPE;
  v_ya_tiene      NUMBER;
  v_id_partido    partido.id_partido%TYPE;
  v_fecha         partido.fecha_hora%TYPE;
  v_creados       NUMBER := 0;
  e_partidos_pendientes EXCEPTION;
  e_no_es_grupos  EXCEPTION;
BEGIN
  SELECT nombre INTO v_nombre_fase FROM fase WHERE id_fase = p_id_fase;

  IF v_nombre_fase <> 'GRUPOS' THEN
    RAISE e_no_es_grupos;
  END IF;

  SELECT COUNT(*) INTO v_pendientes
    FROM partido
   WHERE id_fase = p_id_fase AND estado <> 'FINALIZADO';

  IF v_pendientes > 0 THEN
    RAISE e_partidos_pendientes;
  END IF;

  -- la siguiente fase es la de orden + 1
  SELECT f2.id_fase INTO v_siguiente
    FROM fase f1 JOIN fase f2 ON f2.id_edicion = f1.id_edicion AND f2.orden = f1.orden + 1
   WHERE f1.id_fase = p_id_fase;

  -- los partidos nuevos van despues del ultimo partido que haya
  SELECT MAX(fecha_hora) INTO v_fecha FROM partido;

  OPEN c_grupos(p_id_fase);
  LOOP
    FETCH c_grupos INTO v_id_grupo, v_nombre_grupo;
    EXIT WHEN c_grupos%NOTFOUND;

    -- primero de este grupo
    SELECT s.id_seleccion INTO v_primero
      FROM seleccion s
     WHERE s.id_grupo = v_id_grupo
     ORDER BY fn_puntos_seleccion(s.id_seleccion) DESC, fn_diferencia_gol(s.id_seleccion) DESC
     FETCH FIRST 1 ROWS ONLY;

    -- segundo del grupo pareja (A con B, C con D...)
    SELECT s.id_seleccion INTO v_segundo
      FROM seleccion s
      JOIN grupo g ON g.id_grupo = s.id_grupo
     WHERE g.id_fase = p_id_fase
       AND g.nombre = CASE WHEN MOD(ASCII(v_nombre_grupo) - 65, 2) = 0
                           THEN CHR(ASCII(v_nombre_grupo) + 1)
                           ELSE CHR(ASCII(v_nombre_grupo) - 1) END
     ORDER BY fn_puntos_seleccion(s.id_seleccion) DESC, fn_diferencia_gol(s.id_seleccion) DESC
     OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

    -- si el primero ya tiene partido en la siguiente fase no se crea otro
    SELECT COUNT(*) INTO v_ya_tiene
      FROM participacion_partido pp
      JOIN partido p ON p.id_partido = pp.id_partido
     WHERE p.id_fase = v_siguiente AND pp.id_seleccion = v_primero;

    IF v_ya_tiene = 0 THEN
      v_fecha := v_fecha + 1;
      SELECT NVL(MAX(id_partido), 0) + 1 INTO v_id_partido FROM partido;

      INSERT INTO partido (id_partido, id_fase, id_estadio, fecha_hora, estado)
      VALUES (v_id_partido, v_siguiente, 1, v_fecha, 'PROGRAMADO');

      INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
      VALUES ((SELECT NVL(MAX(id_participacion), 0) + 1 FROM participacion_partido), v_id_partido, v_primero, 'LOCAL', 0);

      INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
      VALUES ((SELECT NVL(MAX(id_participacion), 0) + 1 FROM participacion_partido), v_id_partido, v_segundo, 'VISITANTE', 0);

      v_creados := v_creados + 1;
      DBMS_OUTPUT.PUT_LINE('Grupo ' || v_nombre_grupo || ': se programo el partido ' || v_id_partido);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Grupo ' || v_nombre_grupo || ': el cruce ya estaba programado');
    END IF;
  END LOOP;
  CLOSE c_grupos;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Fase cerrada. Partidos nuevos: ' || v_creados);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: la fase ' || p_id_fase || ' no existe');
  WHEN e_no_es_grupos THEN
    DBMS_OUTPUT.PUT_LINE('Error: solo se puede cerrar la fase de grupos');
  WHEN e_partidos_pendientes THEN
    DBMS_OUTPUT.PUT_LINE('Error: faltan ' || v_pendientes || ' partido(s) por finalizar');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error al cerrar la fase: ' || SQLERRM);
END pr_cierre_fase;
/


-- PRUEBAS (con los datos de ejemplo de carga_datos_prueba.sql)

SET SERVEROUTPUT ON;

-- 3. Tabla de posiciones
-- Grupo A: Colombia 5, Japon 4, Mexico 4, Marruecos 3
EXEC pr_tabla_posiciones(1);
-- Grupo B: Argentina 7, Espana 5, Francia 2, Estados Unidos 1
EXEC pr_tabla_posiciones(2);
-- Error: el grupo 99 no existe
EXEC pr_tabla_posiciones(99);

-- 1. Registrar resultado, con un partido de prueba (Argentina vs Francia en dieciseisavos)
INSERT INTO partido (id_partido, id_fase, id_estadio, id_grupo, codigo_llave, fecha_hora, estado)
VALUES (14, 2, 2, NULL, 'D2', TO_DATE('2026-07-01 18:00','YYYY-MM-DD HH24:MI'), 'PROGRAMADO');
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (27, 14, 6, 'LOCAL', 0);
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (28, 14, 8, 'VISITANTE', 0);
COMMIT;

-- Error: los goles no pueden ser negativos
EXEC pr_registrar_resultado(14, -1, 0);
-- Error: el partido 99 no existe
EXEC pr_registrar_resultado(99, 1, 0);
-- Resultado registrado: partido 14 (2 - 1)
EXEC pr_registrar_resultado(14, 2, 1);
-- Error: el partido 14 ya esta finalizado
EXEC pr_registrar_resultado(14, 3, 0);

SELECT condicion, goles_marcados, resultado
  FROM participacion_partido
 WHERE id_partido = 14;  -- LOCAL 2 G, VISITANTE 1 P

-- 2. Carga masiva: el partido 14 se pone EN_JUEGO (ya se jugo) y se le cargan las estadisticas
-- (Argentina 1 gol con la convocatoria 18, Francia 2 goles con la 24)
UPDATE partido SET estado = 'EN_JUEGO' WHERE id_partido = 14;
UPDATE participacion_partido SET goles_marcados = 0, resultado = NULL WHERE id_partido = 14;
INSERT INTO estadistica_jugador_partido VALUES (79, 14, 18, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (80, 14, 24, 0, NULL, 2, 0, 1, 'N');
COMMIT;

-- Partido 14: 1 - 2 / Cargados: 1, sin estadisticas: 0, con error: 0
EXEC pr_carga_masiva_resultados(2);

SELECT condicion, goles_marcados, resultado
  FROM participacion_partido
 WHERE id_partido = 14;  -- LOCAL 1 P, VISITANTE 2 G

-- Cargados: 0 (ya no hay partidos en juego)
EXEC pr_carga_masiva_resultados(2);

-- se borra el partido de prueba (sus participaciones y estadisticas se borran por el ON DELETE CASCADE)
DELETE FROM partido WHERE id_partido = 14;
COMMIT;

-- 4. Cierre de fase
-- Error: la fase 99 no existe
EXEC pr_cierre_fase(99);
-- Error: solo se puede cerrar la fase de grupos
EXEC pr_cierre_fase(2);
-- Grupo A: el cruce ya estaba programado (Colombia vs Espana)
-- Grupo B: se programo el partido 14 (Argentina vs Japon) / Partidos nuevos: 1
EXEC pr_cierre_fase(1);
-- Otra vez: los dos cruces ya estaban programados / Partidos nuevos: 0
EXEC pr_cierre_fase(1);

SELECT p.id_partido, p.estado, f.pais, pp.condicion
  FROM partido p
  JOIN participacion_partido pp ON pp.id_partido = p.id_partido
  JOIN seleccion s ON s.id_seleccion = pp.id_seleccion
  JOIN federacion f ON f.id_federacion = s.id_federacion
 WHERE p.id_fase = 2
 ORDER BY p.id_partido, pp.condicion;  -- partido 13 Colombia-Espana y partido 14 Argentina-Japon

-- se borra el partido que creo el cierre para dejar los datos como estaban
DELETE FROM partido WHERE id_fase = 2 AND id_partido > 13;
COMMIT;