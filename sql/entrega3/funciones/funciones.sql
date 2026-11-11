-- Funciones entrega 3 - Proyecto Mundial FIFA

-- 1. Diferencia de gol de una selección 
-- Goles a favor menos goles en contra en todos sus partidos jugados 

CREATE OR REPLACE FUNCTION fn_diferencia_gol 
 (p_id_seleccion IN seleccion.id_seleccion%TYPE)
RETURN NUMBER 
AS
 v_favor NUMBER;
 v_contra NUMBER;
BEGIN
-- goles que marcó la selección 
  SELECT NVL(SUM(goles_marcados), 0)
    INTO v_favor
    FROM participacion_partido
    WHERE id_seleccion = p_id_seleccion;

-- goles que les marcó el rival en esos partidos
  SELECT NVL(SUM(rival.goles_marcados), 0)
   INTO v_contra
   FROM participacion_partido pp
   JOIN participacion_partido rival 
   ON rival.id_partido = pp.id_partido
   AND rival.id_seleccion <> pp.id_seleccion
  WHERE pp.id_seleccion = p_id_seleccion;

RETURN v_favor - v_contra;
END fn_diferencia_gol;
/


-- 2. Puntos de una selección en la fase de grupos
-- Solo partidos de grupo que ya terminaron 
-- Ganar = 3 puntos, Empatar = 1 punto, Perder = 0 puntos

CREATE OR REPLACE FUNCTION fn_puntos_seleccion
  (p_id_seleccion IN seleccion.id_seleccion%TYPE)
RETURN NUMBER
AS
  v_puntos  NUMBER;
BEGIN
  SELECT NVL(SUM(CASE WHEN pp.resultado = 'G' THEN 3WHEN pp.resultado = 'E' THEN 1 ELSE 0 END), 0)
    INTO v_puntos
    FROM participacion_partido pp
    JOIN partido p ON p.id_partido = pp.id_partido
   WHERE pp.id_seleccion = p_id_seleccion
     AND p.id_grupo IS NOT NULL
     AND p.estado = 'FINALIZADO';

RETURN v_puntos;
END fn_puntos_seleccion;
/


-- 3. Goles de un jugador en una edicion del mundial   

CREATE OR REPLACE FUNCTION fn_goles_jugador_edicion
  (p_id_jugador IN jugador.id_jugador%TYPE, p_id_edicion IN edicion_mundial.id_edicion%TYPE)
RETURN NUMBER 
AS
  v_goles NUMBER;
BEGIN
  SELECT NVL(SUM(e.goles), 0)
    INTO v_goles
    FROM estadistica_jugador_edicion e
    JOIN convocatoria _jugador c ON c.id_convocatoria = e.id_convocatoria
   WHERE c.id_jugador = p_id_jugador
     AND s.id_edicion = p_id_edicion;

RETURN v_goles;
END fn_goles_jugador_edicion;
/


-- 4. Puesto de un jugador en el ranking de goleadores 
-- Si no ha marcado ningún gol no entra en ningún ranking

CREATE OR REPLACE FUNCTION fn_puesto_goleador
  (p_id_jugador IN jugador.id_jugador%TYPE,
   p_id_edicion IN edicion_mundial.id_edicion%TYPE)
RETURN NUMBER
AS
  v_mis_goles   NUMBER;
  v_por_encima  NUMBER;
BEGIN
  -- goles del jugador (usa la funcion 3)
  v_mis_goles := fn_goles_jugador_edicion(p_id_jugador, p_id_edicion);

  IF v_mis_goles = 0 THEN
  RETURN NULL;
  END IF;

  -- cuantos jugadores tienen mas goles en esa edicion
  SELECT COUNT(*)
    INTO v_por_encima
    FROM jugador j
   WHERE fn_goles_jugador_edicion(j.id_jugador, p_id_edicion) > v_mis_goles;

RETURN v_por_encima + 1;
END fn_puesto_goleador;
/
