--Tabla de posiciones por grupo
SELECT g.nombre AS grupo, f.pais AS seleccion,
count(*) AS partidos_jugados,
SUM(CASE WHEN pp.resultado = 'G' THEN 1 ELSE 0 END) AS ganados,
SUM(CASE WHEN pp.resultado = 'E' THEN 1 ELSE 0 END) AS empatados,
SUM(CASE WHEN pp.resultado = 'P' THEN 1 ELSE 0 END) AS perdidos,
SUM(pp.goles_marcados) AS goles_a_favor,
SUM(CASE WHEN pp.resultado = 'G' THEN 3 WHEN pp.resultado = 'E' THEN 1 ELSE 0 END) AS puntos
FROM participacion_partido pp
JOIN partido p ON pp.id_partido = p.id_partido
JOIN grupo g ON p.id_grupo = g.id_grupo
JOIN seleccion s ON pp.id_seleccion = s.id_seleccion
JOIN federacion f ON s.id_federacion = f.id_federacion
GROUP BY g.nombre, f.pais
ORDER BY g.nombre, puntos DESC;

--Goleadores del torneo
SELECT j.nombres, j.apellidos, f.pais AS seleccion,
SUM(e.goles) AS total_goles
FROM estadistica_jugador_partido e
JOIN convocatoria_jugador c ON e.id_convocatoria = c.id_convocatoria
JOIN jugador j ON c.id_jugador = j.id_jugador
JOIN seleccion s ON c.id_seleccion = s.id_seleccion
JOIN federacion f ON s.id_federacion = f.id_federacion
GROUP BY j.nombres, j.apellidos, f.pais
HAVING SUM(e.goles) > 0
ORDER BY total_goles DESC;

-- Porcentaje de ocupación por estadio
SELECT es.nombre AS estadio, es.capacidad,
COUNT(p.id_partido) AS partidos,
AVG(p.asistencia) AS asistencia_promedio,
ROUND(AVG(p.asistencia) * 100 / es.capacidad, 2) AS ocupacion_pct
from estadio es
join partido p ON es.id_estadio = p.id_estadio
group by es.nombre, es.capacidad
order by ocupacion_pct DESC;

--Partidos y goles por fase
SELECT fa.nombre AS fase,
COUNT(DISTINCT p.id_partido) AS partidos,
SUM(pp.goles_marcados) AS total_goles
FROM fase fa
JOIN partido p ON fa.id_fase = p.id_fase
JOIN participacion_partido pp ON p.id_partido = pp.id_partido
group BY fa.nombre
ORDER BY total_goles DESC;

