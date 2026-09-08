
-- Vistas

-- Vista 1: tabla de posiciones parcial
CREATE OR REPLACE VIEW VW_TABLA_POSICIONES_PARCIAL AS
WITH rivales AS (
    SELECT
        pp1.id_partido,
        pp1.id_seleccion,
        pp1.goles_marcados AS gf,
        pp2.goles_marcados AS gc
    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp1
    JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp2
        ON pp1.id_partido = pp2.id_partido
       AND pp1.id_seleccion <> pp2.id_seleccion
)
SELECT
    s.id_edicion,
    s.pais AS pais,
    COUNT(*) AS partidos_jugados,
    SUM(CASE WHEN r.gf > r.gc THEN 1 ELSE 0 END) AS partidos_ganados,
    SUM(CASE WHEN r.gf = r.gc THEN 1 ELSE 0 END) AS partidos_empatados,
    SUM(CASE WHEN r.gf < r.gc THEN 1 ELSE 0 END) AS partidos_perdidos,
    SUM(r.gf) AS goles_favor,
    SUM(r.gc) AS goles_contra,
    SUM(r.gf) - SUM(r.gc) AS diferencia_gol,
    SUM(CASE WHEN r.gf > r.gc THEN 3 WHEN r.gf = r.gc THEN 1 ELSE 0 END) AS puntos
FROM rivales r
JOIN MORENOLUIS.FIFA_SELECCION s
    ON s.id_seleccion = r.id_seleccion
GROUP BY s.id_edicion, s.pais;


-- Vista 2: goleadores acumulados
CREATE OR REPLACE VIEW VW_GOLEADORES_ACUMULADOS AS
SELECT
    s.id_edicion,
    s.pais,
    SUM(pp.goles_marcados) AS goles_totales
FROM MORENOLUIS.FIFA_SELECCION s
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
    ON pp.id_seleccion = s.id_seleccion
GROUP BY s.id_edicion, s.pais;


-- Vista 3: ocupacion por estadio (usa la tabla propia ASISTENCIA_PARTIDO)
CREATE OR REPLACE VIEW VW_OCUPACION_ESTADIO AS
SELECT
    e.id_estadio,
    e.nombre AS estadio,
    e.ciudad,
    e.capacidad,
    COUNT(p.id_partido) AS partidos_jugados,
    ROUND(AVG(ap.asistencia_real / e.capacidad * 100), 2) AS ocupacion_pct
FROM MORENOLUIS.FIFA_ESTADIO e
JOIN MORENOLUIS.FIFA_PARTIDO p
    ON p.id_estadio = e.id_estadio
JOIN ASISTENCIA_PARTIDO ap
    ON ap.id_partido = p.id_partido
GROUP BY e.id_estadio, e.nombre, e.ciudad, e.capacidad;


-- Vista 4: partidos con marcador y sede
CREATE OR REPLACE VIEW VW_PARTIDOS_MARCADOR_SEDE AS
SELECT
    p.id_partido,
    ed.anio,
    p.fase,
    p.fecha_hora,
    e.nombre AS estadio,
    e.ciudad,
    MAX(CASE WHEN pp.condicion = 'local'     THEN s.pais END) AS seleccion_local,
    MAX(CASE WHEN pp.condicion = 'local'     THEN pp.goles_marcados END) AS goles_local,
    MAX(CASE WHEN pp.condicion = 'visitante' THEN s.pais END) AS seleccion_visitante,
    MAX(CASE WHEN pp.condicion = 'visitante' THEN pp.goles_marcados END) AS goles_visitante
FROM MORENOLUIS.FIFA_PARTIDO p
JOIN MORENOLUIS.FIFA_ESTADIO e
    ON e.id_estadio = p.id_estadio
JOIN MORENOLUIS.FIFA_EDICION_MUNDIAL ed
    ON ed.id_edicion = p.id_edicion
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
    ON pp.id_partido = p.id_partido
JOIN MORENOLUIS.FIFA_SELECCION s
    ON s.id_seleccion = pp.id_seleccion
GROUP BY p.id_partido, ed.anio, p.fase, p.fecha_hora, e.nombre, e.ciudad;


-- Vista 5: diferencia de gol por seleccion
CREATE OR REPLACE VIEW VW_DIFERENCIA_GOL_SELECCION AS
WITH rivales AS (
    SELECT
        pp1.id_seleccion,
        pp1.goles_marcados AS gf,
        pp2.goles_marcados AS gc
    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp1
    JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp2
        ON pp1.id_partido = pp2.id_partido
       AND pp1.id_seleccion <> pp2.id_seleccion
)
SELECT
    s.id_edicion,
    s.pais,
    SUM(r.gf) AS goles_favor,
    SUM(r.gc) AS goles_contra,
    SUM(r.gf) - SUM(r.gc) AS diferencia_gol
FROM rivales r
JOIN MORENOLUIS.FIFA_SELECCION s
    ON s.id_seleccion = r.id_seleccion
GROUP BY s.id_edicion, s.pais;