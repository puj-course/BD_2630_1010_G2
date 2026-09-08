--Semana 4
-- Consultas 14 y 15

-- Consulta 14: Verificación de participaciones duplicadas
-- (misma selección repetida en el mismo partido)
SELECT id_partido, id_seleccion, COUNT(*) AS num_registros
FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO
GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1;

SELECT table_name FROM user_tables;

-- Consulta 15: A partir de una vista
WITH posiciones_con_grupo AS (
    SELECT
        v.id_edicion,
        s.confederacion AS grupo_simulado,
        v.pais,
        v.puntos,
        v.diferencia_gol
    FROM VW_TABLA_POSICIONES_PARCIAL v
    JOIN MORENOLUIS.FIFA_SELECCION s
        ON v.pais = s.pais AND v.id_edicion = s.id_edicion
),
maximos AS (
    SELECT id_edicion, grupo_simulado, MAX(puntos) AS max_puntos
    FROM posiciones_con_grupo
    GROUP BY id_edicion, grupo_simulado
)
SELECT p.id_edicion, p.grupo_simulado, p.pais, p.puntos, p.diferencia_gol
FROM posiciones_con_grupo p
JOIN maximos m
    ON p.id_edicion = m.id_edicion
    AND p.grupo_simulado = m.grupo_simulado
    AND p.puntos = m.max_puntos
ORDER BY p.id_edicion, p.grupo_simulado;