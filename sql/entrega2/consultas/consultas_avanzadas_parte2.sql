-- Semana 4, Entrega 2
-- Consultas avanzadas parte 2

--Consulta 5: Resultados de todos los partidos (local vs visitante)
SELECT p.id_partido, fa.nombre AS fase,
fl.pais AS local, loc.goles_marcados AS goles_del_local,
vis.goles_marcados AS goles_visitante, fv.pais AS visitante,
es.nombre AS estadio
FROM partido p
JOIN fase fa ON p.id_fase = fa.id_fase
JOIN estadio es ON p.id_estadio = es.id_estadio
JOIN participacion_partido loc ON p.id_partido = loc.id_partido AND loc.condicion = 'LOCAL'
JOIN participacion_partido vis ON p.id_partido = vis.id_partido AND vis.condicion = 'VISITANTE'
JOIN seleccion sl ON loc.id_seleccion = sl.id_seleccion
JOIN federacion fl ON sl.id_federacion = fl.id_federacion
JOIN seleccion sv ON vis.id_seleccion = sv.id_seleccion
JOIN federacion fv ON sv.id_federacion = fv.id_federacion
ORDER BY p.fecha_hora;

--Consulta 6: Rendimiento por confederación
SELECT c.sigla AS confederacion,
COUNT(DISTINCT s.id_seleccion) AS selecciones,
COUNT(*) AS partidos_jugados,
SUM(pp.goles_marcados) AS total_goles,
SUM(CASE WHEN pp.resultado = 'G' THEN 1 ELSE 0 END) AS victorias
FROM confederacion c
JOIN federacion f ON c.id_confederacion = f.id_confederacion
JOIN seleccion s ON f.id_federacion = s.id_federacion
JOIN participacion_partido pp ON s.id_seleccion = pp.id_seleccion
GROUP BY c.sigla
ORDER BY total_goles DESC;

--Consulta 7: Partidos asignados a cada árbitro
SELECT a.nombres, a.apellidos, c.sigla AS confederacion,
COUNT(*) AS partidos_asignados,
SUM(CASE WHEN aa.rol = 'PRINCIPAL' THEN 1 ELSE 0 END) AS como_principal
FROM arbitro a
JOIN confederacion c ON a.id_confederacion = c.id_confederacion
JOIN asignacion_arbitral aa ON a.id_arbitro = aa.id_arbitro
GROUP BY a.nombres, a.apellidos, c.sigla
ORDER BY como_principal DESC, partidos_asignados DESC;

--Consulta 8: Resumen general de la edición
SELECT emundial.anio, emundial.nombre_oficial,
COUNT(DISTINCT p.id_partido) AS partidos,
SUM(pp.goles_marcados) AS total_goles,
ROUND(SUM(pp.goles_marcados) / COUNT(DISTINCT p.id_partido), 2) AS promedio_goles
FROM edicion_mundial emundial
JOIN fase fa ON emundial.id_edicion = fa.id_edicion
JOIN partido p ON fa.id_fase = p.id_fase
JOIN participacion_partido pp ON p.id_partido = pp.id_partido
GROUP BY emundial.anio, emundial.nombre_oficial;