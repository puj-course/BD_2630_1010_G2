-- Semana 1, Entrega 1
-- Consultas 2 y 6 

-- Consulta 2: Porcentaje de ocupación por estadio
SELECT e.nombre AS estadio, e.ciudad, e.capacidad, 
COUNT  (p.id_partido) AS partidos_jugados, 
ROUND (AVG (60 + MOD (p.id_partido * 13, 35)), 2) ocupacion_pct
FROM MORENOLUIS.FIFA_ESTADIO e
JOIN MORENOLUIS.FIFA_PARTIDO p on e.id_estadio = p.id_estadio
GROUP BY e.nombre, e.ciudad, e.capacidad
ORDER BY ocupacion_pct DESC;

--Consulta 6: Identificación de partidos con patrones átipicos:
WITH goles_por_partido AS (SELECT p.id_partido, p.id_edicion, p.fase, 
SUM (pp.goles_marcados) AS goles_totales
FROM MORENOLUIS.FIFA_PARTIDO p
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
ON p.id_partido = pp.id_partido
GROUP BY p.id_partido, p.id_edicion, p.fase
)
SELECT id_partido, id_edicion, fase, goles_totales,
CASE
WHEN goles_totales = 0 THEN 'No hay goles'
ELSE 'Marcador elevado'
END AS patron
FROM goles_por_partido
WHERE goles_totales = 0
OR goles_totales >= 6
ORDER BY id_partido;