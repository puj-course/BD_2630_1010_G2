--Consulta 1: Top 5 selecciones con más goles anotados
SELECT pais, goles_totales
FROM (
  SELECT s.pais AS pais, SUM (pp.goles_marcados) AS goles_totales
  FROM MORENOLUIS.FIFA_SELECCION s 
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
  ON s.id_seleccion = pp.id_seleccion
  GROUP BY s.pais
  ORDER BY goles_totales DESC
  )
WHERE ROWNUM <= 5;

--Conculta 3: selecciones con una mayor diferencia de gol (goles a favor menos goles recibidos en contra)
SELECT s.pais,
SUM (pp.goles_marcados) AS goles_favor,
SUM (pp_rival.goles_marcados) AS goles_contra,
SUM (pp.goles_marcados)- SUM (pp_rival.goles_marcados) AS diferencia_gol
FROM MORENOLUIS.FIFA_SELECCION s
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
ON s.id_seleccion = pp.id_seleccion
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp_rival
ON pp.id_partido = pp_rival.id_partido
AND pp_rival.id_seleccion <> pp.id_seleccion
GROUP BY s.pais
ORDER BY diferencia_gol DESC;

--Consulta 4: Partidos jugados por fase
SELECT fase, COUNT (*) AS num_partidos
FROM MORENOLUIS.FIFA_PARTIDO
GROUP BY fase
ORDER BY num_partidos DESC;

--Consulta 5: Para cada una de las edicionas, estadios con más partidos jugados
WITH partidos_por_estadio AS (
  SELECT p.id_edicion, e.nombre AS estadio, COUNT (*) AS n_partidos
  FROM MORENOLUIS.FIFA_PARTIDO p
  JOIN MORENOLUIS.FIFA_ESTADIO e 
  ON p.id_estadio = e.id_estadio
  GROUP BY p.id_edicion, e.nombre
  ),
maximos AS (
  SELECT id_edicion, MAX(n_partidos) AS max_partidos
  FROM partidos_por_estadio
  GROUP BY id_edicion
)
SELECT pe.id_edicion, pe.estadio, pe.n_partidos
FROM partidos_por_estadio pe
JOIN maximos m
ON pe.id_edicion = m.id_edicion
AND pe.n_partidos = m.max_partidos
ORDER BY pe.id_edicion;

--Consulta 9: Para cada estadio, el partido con un mayor marcador combinado
WITH goles_por_partido AS (
  SELECT p.id_partido, p.id_estadio, p.fase,
  SUM (pp.goles_marcados) AS goles_totales
  FROM MORENOLUIS.FIFA_PARTIDO p 
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
  ON p.id_partido = pp.id_partido
  GROUP BY p.id_partido, p.id_estadio, p.fase
  ),
max_por_estadio AS (
  SELECT id_estadio, MAX (goles_totales) AS max_goles
  FROM goles_por_partido   
  GROUP BY id_estadio
  )
SELECT e.nombre AS estadio, g.id_partido, g.fase, g.goles_totales
FROM goles_por_partido g
JOIN max_por_estadio m
ON g.id_estadio = m.id_estadio
AND g.goles_totales = m.max_goles
JOIN MORENOLUIS.FIFA_ESTADIO e 
On g.id_estadio = e.id_estadio
ORDER BY e.nombre;

--Consulta 12: Goles en fase de grupos vs fase eliminatoria por cada selección 
SELECT
s.pais,
SUM(CASE WHEN p.fase = 'Fase de Grupos' THEN pp.goles_marcados ELSE 0 END) AS goles_fase_grupos,
SUM(CASE WHEN p.fase <> 'Fase de Grupos' THEN pp.goles_marcados ELSE 0 END) AS goles_eliminatoria
FROM MORENOLUIS.FIFA_SELECCION s
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
ON s.id_seleccion = pp.id_seleccion
JOIN MORENOLUIS.FIFA_PARTIDO p
ON pp.id_partido = p.id_partido
GROUP BY s.pais
ORDER BY goles_fase_grupos DESC;

--Consulta 13: Estadios que hayan albergado partidos en más de una fase distinta 
SELECT e.nombre AS estadio,
COUNT (DISTINCT p.fase) AS n_fases_distintas
FROM MORENOLUIS.FIFA_ESTADIO e
JOIN MORENOLUIS.FIFA_PARTIDO p
ON e.id_estadio = p.id_estadio
GROUP BY e.nombre
HAVING COUNT (DISTINCT p.fase) > 1
ORDER BY n_fases_distintas DESC;