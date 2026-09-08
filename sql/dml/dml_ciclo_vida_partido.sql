--DML ----> CICLO DE VIDA DE UN PARTIDO 

--Datos necesarios
INSERT INTO edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
VALUES (1, 2026,'Canada-México-USA', 'United by Football', DATE '2026-06-11', DATE '2026-07-19');

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (1, 1, 'Estadio Prueba Norte', 'Bogotá', 45000);

INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
VALUES (2, 1, 'Estadio Oeste', 'Medellín', 37000);

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (1, 1, 'España', 'UEFA');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (2, 1, 'COLOMBIA', 'CONMEBOL');

INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
VALUES (3, 1, 'Alemania', 'UEFA');

COMMIT;

-- CICLO DE VIDA DE UN PARTIDO
INSERT INTO partido (id_partido, id_edicion, id_estadio, fecha_hora, fase)
VALUES (1, 1, 1, DATE '2026-06-12', 'Fase de Grupos');

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (1, 1, 1, 'local', 0);

INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (2, 1, 2, 'visitante', 0);

COMMIT;

-- ACTUALIZACIÓN MARCADOR FINAL
UPDATE participacion_partido
SET goles_marcados = 3
WHERE id_partido = 1 AND id_seleccion = 1;

UPDATE participacion_partido
SET goles_marcados = 2
WHERE id_partido = 1 AND id_seleccion = 2;

COMMIT;

--OPERACIONES INVALIDAS
--1. gol negativo
UPDATE participacion_partido
SET goles_marcados = -5 
WHERE id_partido = 1 AND id_seleccion = 1;

--2. Misma selección participando dos veces en el mismo partido
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (3, 1, 1, 'local', 5);

--3. Tercer participante en un mismo partido (equipo distinto)
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (4, 1, 3, 'visitante', 0);  

--COMPORTAMIENTO DE ON DELETE
-- Relación 1: participacion_partido -> partido (ON DELETE CASCADE)
SELECT COUNT(*) AS participaciones_antes
FROM participacion_partido WHERE id_partido = 1;

DELETE FROM partido WHERE id_partido = 1;
COMMIT;

SELECT COUNT(*) AS participaciones_despues
FROM participacion_partido WHERE id_partido = 1;

-- Relación 2: estadio -> edicion_mundial (sin ON DELETE, por defecto RESTRICT)
DELETE FROM edicion_mundial WHERE id_edicion = 1;

--Comprobaciones
SELECT * FROM edicion_mundial;
SELECT * FROM seleccion;
SELECT * FROM partido;
SELECT * FROM participacion_partido;
