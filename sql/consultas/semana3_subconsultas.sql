--SEMANA 3: 
-- CONSULTAS 7, 8, 10 Y 11 

--Consulta 7: Selecciones invictas ----> es invicta si no existe ningún partido suyo donde haya anotado menos goles que su rival
SELECT s.pais
FROM MORENOLUIS.FIFA_SELECCION s
WHERE s.id_seleccion IN (
  SELECT id_seleccion FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO
  )
AND NOT EXISTS (
  SELECT 1 
  FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp_rival
  ON pp.id_partido = pp_rival.id_partido
  AND pp_rival.id_seleccion <>  pp.id_seleccion
  WHERE pp.id_seleccion = s.id_seleccion
  AND pp.goles_marcados < pp_rival.goles_marcados
  )
ORDER BY s.pais;

--Consulta 8: estadios cuya ocupación estimada esté por
--encima del promedio general de ocupación de todos los estadios (usando subconsulta correlacionada)
SELECT DISTINCT e.nombre AS estadio, e.ciudad 
FROM MORENOLUIS.FIFA_ESTADIO e 
WHERE (
  SELECT AVG(60 + MOD(p.id_partido *13, 35))
  FROM MORENOLUIS.FIFA_PARTIDO p
  WHERE p.id_estadio = e.id_estadio)
  >
  (SELECT AVG (60 + MOD(p2.id_partido *13,35))
  FROM MORENOLUIS.FIFA_PARTIDO p2
  )
ORDER BY estadio;

-- Consulta 10: Selecciones con condición exclusiva: selecciones que jugaron todos sus partidos como
--local, o que no jugaron ninguno como local (ejercicio análogo al operador de división del álgebra relacional).
SELECT s.pais, 
SUM (CASE WHEN pp.condicion = 'local' THEN 1 ELSE 0 END) AS partidos_local,
SUM (CASE WHEN pp.condicion = 'visitante' THEN 1 ELSE 0 END) AS partidos_visitante,
COUNT (*) AS total_partidos
FROM MORENOLUIS.FIFA_SELECCION s 
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
ON s.id_seleccion = pp.id_seleccion
GROUP BY s.pais
HAVING SUM (CASE WHEN pp.condicion = 'local' THEN 1 ELSE 0 END) = 0
  OR SUM(CASE WHEN pp.condicion = 'visitante' THEN 1 ELSE 0 END) = 0
ORDER BY s.pais;

--Consulta 11: Muestra únicamente las selecciones cuya diferencia de gol esté estrictamente por encima del
-- promedio general de diferencia de gol de todas las selecciones del dataset
WITH diferencia AS (
  SELECT s.pais,  SUM (pp.goles_marcados) - SUM(pp_rival.goles_marcados) AS diferencia_gol
  FROM MORENOLUIS.FIFA_SELECCION s
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
  ON s.id_seleccion = pp.id_seleccion
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp_rival
  ON pp.id_partido = pp_rival.id_partido
  AND pp_rival.id_seleccion <> pp.id_seleccion
  GROUP BY s.pais
  )
SELECT pais, diferencia_gol
FROM diferencia 
WHERE diferencia_gol > (SELECT AVG(diferencia_gol) FROM diferencia)
ORDER BY diferencia_gol DESC;