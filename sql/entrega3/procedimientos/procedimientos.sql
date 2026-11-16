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
