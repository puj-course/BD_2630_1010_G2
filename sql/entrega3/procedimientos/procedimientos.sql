-- Procedimientos - Entrega 3 - Proyecto mundial FIFA 

SET SERVEROUTPUT ON; 

-- BLOQUE A: Carga masiva controlada de resultados de partidos 

-- 1. Registrar el resultado de un partido 
-- Recibe el partido y los goles tamto del local como del visitante
-- Valida los datos y calcula quien gano (G/E/P) y deja el estado en FINALIZADO
-- Si algo falla hace ROLLBACK

CREATE OR REPLACE PROCEDURE pr_registrar_resultado
  (p_id_partido IN partido.id_partido%TYPE,
   p_goles_local IN participacion_partido.goles_marcados%TYPE,
   p_goles_visitante IN participacion_partido.goless_marcados%TYPE)
AS
  v_estado  partido:estado%TYPE;
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
       AND conddicion = 'VISITANTE';

    IF SQL%ROWCOUNT = 0 THEN 
      RAISE e_sin_participacion;
    END IF;

  --6. el partido queda finalizado 
