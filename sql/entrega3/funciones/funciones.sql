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