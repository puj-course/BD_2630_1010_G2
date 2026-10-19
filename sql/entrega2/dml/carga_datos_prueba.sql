-- Carga de datos de prueba - Modelo ampliado (Entrega 2)
-- Datos ficticios y coherentes entre si: los nombres de paises, ciudades y estadios son reales,
-- pero jugadores, arbitros, periodistas y resultados son inventados.

--Confederaciones
INSERT INTO confederacion VALUES (1, 'AFC', 'Confederacion Asiatica de Futbol');
INSERT INTO confederacion VALUES (2, 'CAF', 'Confederacion Africana de Futbol');
INSERT INTO confederacion VALUES (3, 'CONCACAF', 'Confederacion de Norteamerica, Centroamerica y el Caribe de Futbol');
INSERT INTO confederacion VALUES (4, 'CONMEBOL', 'Confederacion Sudamericana de Futbol');
INSERT INTO confederacion VALUES (5, 'OFC', 'Confederacion de Futbol de Oceania');
INSERT INTO confederacion VALUES (6, 'UEFA', 'Union de Asociaciones Europeas de Futbol');

--Federaciones
INSERT INTO federacion VALUES (1, 3, 'Mexico', 'MEX');
INSERT INTO federacion VALUES (2, 4, 'Colombia', 'COL');
INSERT INTO federacion VALUES (3, 1, 'Japon', 'JPN');
INSERT INTO federacion VALUES (4, 2, 'Marruecos', 'MAR');
INSERT INTO federacion VALUES (5, 3, 'Estados Unidos', 'USA');
INSERT INTO federacion VALUES (6, 4, 'Argentina', 'ARG');
INSERT INTO federacion VALUES (7, 6, 'Espana', 'ESP');
INSERT INTO federacion VALUES (8, 6, 'Francia', 'FRA');

--Edicion mundial
INSERT INTO edicion_mundial VALUES (1, 2026, 'Copa Mundial de la FIFA 2026', 'Unidos por el futbol', TO_DATE('2026-06-11','YYYY-MM-DD'), TO_DATE('2026-07-19','YYYY-MM-DD'), 26, 48);

--Ciudades sede
INSERT INTO ciudad_sede VALUES (1, 1, 'Ciudad de Mexico', 'Mexico');
INSERT INTO ciudad_sede VALUES (2, 1, 'Guadalajara', 'Mexico');
INSERT INTO ciudad_sede VALUES (3, 1, 'Los Angeles', 'Estados Unidos');
INSERT INTO ciudad_sede VALUES (4, 1, 'Toronto', 'Canada');

--Estadios
INSERT INTO estadio VALUES (1, 1, 'Estadio Azteca', 83000);
INSERT INTO estadio VALUES (2, 2, 'Estadio Akron', 48000);
INSERT INTO estadio VALUES (3, 3, 'SoFi Stadium', 70000);
INSERT INTO estadio VALUES (4, 4, 'BMO Field', 45000);

--Fases
INSERT INTO fase VALUES (1, 1, 'GRUPOS', 1, 32);
INSERT INTO fase VALUES (2, 1, 'DIECISEISAVOS', 2, 16);
INSERT INTO fase VALUES (3, 1, 'OCTAVOS', 3, 8);
INSERT INTO fase VALUES (4, 1, 'CUARTOS', 4, 4);
INSERT INTO fase VALUES (5, 1, 'SEMIFINAL', 5, 2);
INSERT INTO fase VALUES (6, 1, 'TERCER_PUESTO', 6, 1);
INSERT INTO fase VALUES (7, 1, 'FINAL', 7, 1);

--Grupos
INSERT INTO grupo VALUES (1, 1, 'A');
INSERT INTO grupo VALUES (2, 1, 'B');

--Selecciones
INSERT INTO seleccion VALUES (1, 1, 1, 1, 15);
INSERT INTO seleccion VALUES (2, 1, 2, 1, 12);
INSERT INTO seleccion VALUES (3, 1, 3, 1, 18);
INSERT INTO seleccion VALUES (4, 1, 4, 1, 13);
INSERT INTO seleccion VALUES (5, 1, 5, 2, 16);
INSERT INTO seleccion VALUES (6, 1, 6, 2, 1);
INSERT INTO seleccion VALUES (7, 1, 7, 2, 3);
INSERT INTO seleccion VALUES (8, 1, 8, 2, 2);

--Jugadores
INSERT INTO jugador VALUES (1, 'Diego', 'Ramirez Soto', TO_DATE('1996-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (2, 'Luis', 'Herrera Vega', TO_DATE('1998-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (3, 'Andres', 'Castillo Mora', TO_DATE('2000-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (4, 'Camilo', 'Rojas Pardo', TO_DATE('1995-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (5, 'Sebastian', 'Mejia Ortiz', TO_DATE('1997-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (6, 'Juan Pablo', 'Cardenas Rios', TO_DATE('1999-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (7, 'Haruto', 'Sato', TO_DATE('1994-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (8, 'Kenji', 'Watanabe', TO_DATE('1996-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (9, 'Riku', 'Tanaka', TO_DATE('1998-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (10, 'Youssef', 'El Idrissi', TO_DATE('1996-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (11, 'Hamza', 'Benali', TO_DATE('1998-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (12, 'Karim', 'Ouahbi', TO_DATE('2000-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (13, 'Ethan', 'Walker', TO_DATE('1995-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (14, 'Ryan', 'Mitchell', TO_DATE('1997-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (15, 'Tyler', 'Brooks', TO_DATE('1999-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (16, 'Matias', 'Gonzalez Paz', TO_DATE('1994-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (17, 'Nicolas', 'Ferreyra', TO_DATE('1996-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (18, 'Tomas', 'Aguirre Luna', TO_DATE('1998-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (19, 'Alvaro', 'Navarro Gil', TO_DATE('1996-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (20, 'Pablo', 'Serrano Ruiz', TO_DATE('1998-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (21, 'Hugo', 'Dominguez Leon', TO_DATE('2000-11-05','YYYY-MM-DD'), 'DELANTERO');
INSERT INTO jugador VALUES (22, 'Lucas', 'Moreau', TO_DATE('1995-03-14','YYYY-MM-DD'), 'PORTERO');
INSERT INTO jugador VALUES (23, 'Theo', 'Lefevre', TO_DATE('1997-07-22','YYYY-MM-DD'), 'DEFENSA');
INSERT INTO jugador VALUES (24, 'Antoine', 'Girard', TO_DATE('1999-11-05','YYYY-MM-DD'), 'DELANTERO');

--Convocatorias (3 jugadores por seleccion; el delantero es el capitan)
INSERT INTO convocatoria_jugador VALUES (1, 1, 1, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (2, 1, 2, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (3, 1, 3, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (4, 2, 4, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (5, 2, 5, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (6, 2, 6, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (7, 3, 7, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (8, 3, 8, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (9, 3, 9, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (10, 4, 10, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (11, 4, 11, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (12, 4, 12, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (13, 5, 13, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (14, 5, 14, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (15, 5, 15, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (16, 6, 16, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (17, 6, 17, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (18, 6, 18, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (19, 7, 19, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (20, 7, 20, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (21, 7, 21, 9, 'S');
INSERT INTO convocatoria_jugador VALUES (22, 8, 22, 1, 'N');
INSERT INTO convocatoria_jugador VALUES (23, 8, 23, 4, 'N');
INSERT INTO convocatoria_jugador VALUES (24, 8, 24, 9, 'S');

--Cuerpo tecnico
INSERT INTO cuerpo_tecnico VALUES (1, 1, 'Ricardo', 'Fuentes Lara', 'Mexico', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (2, 2, 'Hernan', 'Duarte Gil', 'Argentina', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (3, 2, 'Mauricio', 'Pena Rios', 'Colombia', 'PREPARADOR_FISICO');
INSERT INTO cuerpo_tecnico VALUES (4, 3, 'Takeshi', 'Morita', 'Japon', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (5, 4, 'Rachid', 'Amrani', 'Marruecos', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (6, 5, 'Mark', 'Henderson', 'Estados Unidos', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (7, 6, 'Gustavo', 'Ibarra Sosa', 'Argentina', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (8, 6, 'Federico', 'Molina', 'Argentina', 'ENTRENADOR_PORTEROS');
INSERT INTO cuerpo_tecnico VALUES (9, 7, 'Javier', 'Ortega Sanz', 'Espana', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (10, 8, 'Olivier', 'Bernard', 'Francia', 'ENTRENADOR_PRINCIPAL');
INSERT INTO cuerpo_tecnico VALUES (11, 8, 'Claire', 'Dubois', 'Francia', 'MEDICO');

--Arbitros
INSERT INTO arbitro VALUES (1, 1, 'Hiroshi', 'Kato', 'Japon', TO_DATE('1985-02-10','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (2, 2, 'Mustapha', 'Diallo', 'Senegal', TO_DATE('1984-06-18','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (3, 3, 'Carlos', 'Mendez', 'Costa Rica', TO_DATE('1986-09-01','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (4, 4, 'Fernando', 'Paredes', 'Uruguay', TO_DATE('1983-12-12','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (5, 5, 'James', 'Wilson', 'Nueva Zelanda', TO_DATE('1987-04-25','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (6, 6, 'Marco', 'Rossi', 'Italia', TO_DATE('1982-08-30','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (7, 6, 'Daniel', 'Koch', 'Alemania', TO_DATE('1988-01-15','YYYY-MM-DD'));
INSERT INTO arbitro VALUES (8, 4, 'Raul', 'Benitez', 'Paraguay', TO_DATE('1985-10-07','YYYY-MM-DD'));

--Partidos (12 de fase de grupos + 1 de dieciseisavos definido por penales)
INSERT INTO partido VALUES (1, 1, 1, 1, NULL, TO_DATE('2026-06-11 18:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 70550, 'N', 'N');
INSERT INTO partido VALUES (2, 1, 2, 1, NULL, TO_DATE('2026-06-12 13:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 40800, 'N', 'N');
INSERT INTO partido VALUES (3, 1, 3, 2, NULL, TO_DATE('2026-06-12 19:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 59500, 'N', 'N');
INSERT INTO partido VALUES (4, 1, 4, 2, NULL, TO_DATE('2026-06-13 16:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 38250, 'N', 'N');
INSERT INTO partido VALUES (5, 1, 2, 1, NULL, TO_DATE('2026-06-17 19:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 40800, 'N', 'N');
INSERT INTO partido VALUES (6, 1, 1, 1, NULL, TO_DATE('2026-06-18 13:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 70550, 'N', 'N');
INSERT INTO partido VALUES (7, 1, 3, 2, NULL, TO_DATE('2026-06-18 19:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 59500, 'N', 'N');
INSERT INTO partido VALUES (8, 1, 4, 2, NULL, TO_DATE('2026-06-19 16:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 38250, 'N', 'N');
INSERT INTO partido VALUES (9, 1, 1, 1, NULL, TO_DATE('2026-06-24 19:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 70550, 'N', 'N');
INSERT INTO partido VALUES (10, 1, 2, 1, NULL, TO_DATE('2026-06-24 19:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 40800, 'N', 'N');
INSERT INTO partido VALUES (11, 1, 3, 2, NULL, TO_DATE('2026-06-25 18:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 59500, 'N', 'N');
INSERT INTO partido VALUES (12, 1, 4, 2, NULL, TO_DATE('2026-06-25 18:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 38250, 'N', 'N');
INSERT INTO partido VALUES (13, 2, 1, NULL, 'D1', TO_DATE('2026-06-30 18:00','YYYY-MM-DD HH24:MI'), 'FINALIZADO', 70550, 'S', 'S');

--Participaciones (2 por partido: una LOCAL y una VISITANTE)
INSERT INTO participacion_partido VALUES (1, 1, 1, 'LOCAL', 1, NULL, 'E');
INSERT INTO participacion_partido VALUES (2, 1, 2, 'VISITANTE', 1, NULL, 'E');
INSERT INTO participacion_partido VALUES (3, 2, 3, 'LOCAL', 2, NULL, 'G');
INSERT INTO participacion_partido VALUES (4, 2, 4, 'VISITANTE', 0, NULL, 'P');
INSERT INTO participacion_partido VALUES (5, 3, 5, 'LOCAL', 0, NULL, 'P');
INSERT INTO participacion_partido VALUES (6, 3, 6, 'VISITANTE', 2, NULL, 'G');
INSERT INTO participacion_partido VALUES (7, 4, 7, 'LOCAL', 1, NULL, 'E');
INSERT INTO participacion_partido VALUES (8, 4, 8, 'VISITANTE', 1, NULL, 'E');
INSERT INTO participacion_partido VALUES (9, 5, 1, 'LOCAL', 2, NULL, 'G');
INSERT INTO participacion_partido VALUES (10, 5, 3, 'VISITANTE', 1, NULL, 'P');
INSERT INTO participacion_partido VALUES (11, 6, 2, 'LOCAL', 3, NULL, 'G');
INSERT INTO participacion_partido VALUES (12, 6, 4, 'VISITANTE', 0, NULL, 'P');
INSERT INTO participacion_partido VALUES (13, 7, 5, 'LOCAL', 1, NULL, 'P');
INSERT INTO participacion_partido VALUES (14, 7, 7, 'VISITANTE', 3, NULL, 'G');
INSERT INTO participacion_partido VALUES (15, 8, 6, 'LOCAL', 2, NULL, 'G');
INSERT INTO participacion_partido VALUES (16, 8, 8, 'VISITANTE', 1, NULL, 'P');
INSERT INTO participacion_partido VALUES (17, 9, 1, 'LOCAL', 0, NULL, 'P');
INSERT INTO participacion_partido VALUES (18, 9, 4, 'VISITANTE', 1, NULL, 'G');
INSERT INTO participacion_partido VALUES (19, 10, 2, 'LOCAL', 2, NULL, 'E');
INSERT INTO participacion_partido VALUES (20, 10, 3, 'VISITANTE', 2, NULL, 'E');
INSERT INTO participacion_partido VALUES (21, 11, 5, 'LOCAL', 2, NULL, 'E');
INSERT INTO participacion_partido VALUES (22, 11, 8, 'VISITANTE', 2, NULL, 'E');
INSERT INTO participacion_partido VALUES (23, 12, 6, 'LOCAL', 0, NULL, 'E');
INSERT INTO participacion_partido VALUES (24, 12, 7, 'VISITANTE', 0, NULL, 'E');
INSERT INTO participacion_partido VALUES (25, 13, 2, 'LOCAL', 1, 4, 'G');
INSERT INTO participacion_partido VALUES (26, 13, 7, 'VISITANTE', 1, 3, 'P');

--Asignacion arbitral (principal, 2 asistentes y VAR por partido)
INSERT INTO asignacion_arbitral VALUES (1, 1, 1, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (2, 1, 3, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (3, 1, 4, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (4, 1, 5, 'VAR');
INSERT INTO asignacion_arbitral VALUES (5, 2, 4, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (6, 2, 3, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (7, 2, 5, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (8, 2, 6, 'VAR');
INSERT INTO asignacion_arbitral VALUES (9, 3, 5, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (10, 3, 4, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (11, 3, 6, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (12, 3, 7, 'VAR');
INSERT INTO asignacion_arbitral VALUES (13, 4, 4, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (14, 4, 6, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (15, 4, 7, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (16, 4, 8, 'VAR');
INSERT INTO asignacion_arbitral VALUES (17, 5, 7, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (18, 5, 6, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (19, 5, 8, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (20, 5, 1, 'VAR');
INSERT INTO asignacion_arbitral VALUES (21, 6, 1, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (22, 6, 8, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (23, 6, 2, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (24, 6, 3, 'VAR');
INSERT INTO asignacion_arbitral VALUES (25, 7, 2, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (26, 7, 1, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (27, 7, 3, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (28, 7, 4, 'VAR');
INSERT INTO asignacion_arbitral VALUES (29, 8, 5, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (30, 8, 2, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (31, 8, 3, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (32, 8, 4, 'VAR');
INSERT INTO asignacion_arbitral VALUES (33, 9, 5, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (34, 9, 3, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (35, 9, 4, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (36, 9, 6, 'VAR');
INSERT INTO asignacion_arbitral VALUES (37, 10, 7, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (38, 10, 4, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (39, 10, 5, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (40, 10, 6, 'VAR');
INSERT INTO asignacion_arbitral VALUES (41, 11, 1, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (42, 11, 6, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (43, 11, 7, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (44, 11, 8, 'VAR');
INSERT INTO asignacion_arbitral VALUES (45, 12, 5, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (46, 12, 7, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (47, 12, 8, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (48, 12, 1, 'VAR');
INSERT INTO asignacion_arbitral VALUES (49, 13, 1, 'PRINCIPAL');
INSERT INTO asignacion_arbitral VALUES (50, 13, 8, 'ASISTENTE_1');
INSERT INTO asignacion_arbitral VALUES (51, 13, 2, 'ASISTENTE_2');
INSERT INTO asignacion_arbitral VALUES (52, 13, 3, 'VAR');

--Estadisticas por jugador y partido (los goles suman el marcador de cada seleccion)
INSERT INTO estadistica_jugador_partido VALUES (1, 1, 1, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (2, 1, 2, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (3, 1, 3, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (4, 1, 4, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (5, 1, 5, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (6, 1, 6, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (7, 2, 7, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (8, 2, 8, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (9, 2, 9, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (10, 2, 10, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (11, 2, 11, 0, NULL, 0, 0, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (12, 2, 12, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (13, 3, 13, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (14, 3, 14, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (15, 3, 15, 0, 80, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (16, 3, 16, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (17, 3, 17, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (18, 3, 18, 0, 80, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (19, 4, 19, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (20, 4, 20, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (21, 4, 21, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (22, 4, 22, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (23, 4, 23, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (24, 4, 24, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (25, 5, 1, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (26, 5, 2, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (27, 5, 3, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (28, 5, 7, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (29, 5, 8, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (30, 5, 9, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (31, 6, 4, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (32, 6, 5, 0, NULL, 1, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (33, 6, 6, 0, 80, 2, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (34, 6, 10, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (35, 6, 11, 0, NULL, 0, 0, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (36, 6, 12, 0, 80, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (37, 7, 13, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (38, 7, 14, 0, 70, 0, 1, 2, 'S');
INSERT INTO estadistica_jugador_partido VALUES (39, 7, 15, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (40, 7, 19, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (41, 7, 20, 0, NULL, 1, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (42, 7, 21, 0, NULL, 2, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (43, 8, 16, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (44, 8, 17, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (45, 8, 18, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (46, 8, 22, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (47, 8, 23, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (48, 8, 24, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (49, 9, 1, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (50, 9, 2, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (51, 9, 3, 0, 80, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (52, 9, 10, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (53, 9, 11, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (54, 9, 12, 0, 80, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (55, 10, 4, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (56, 10, 5, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (57, 10, 6, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (58, 10, 7, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (59, 10, 8, 0, NULL, 0, 1, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (60, 10, 9, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (61, 11, 13, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (62, 11, 14, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (63, 11, 15, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (64, 11, 22, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (65, 11, 23, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (66, 11, 24, 0, NULL, 2, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (67, 12, 16, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (68, 12, 17, 0, NULL, 0, 0, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (69, 12, 18, 0, 80, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (70, 12, 19, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (71, 12, 20, 0, NULL, 0, 0, 1, 'N');
INSERT INTO estadistica_jugador_partido VALUES (72, 12, 21, 0, 80, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (73, 13, 4, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (74, 13, 5, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (75, 13, 6, 0, NULL, 1, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (76, 13, 19, 0, NULL, 0, 0, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (77, 13, 20, 0, NULL, 0, 1, 0, 'N');
INSERT INTO estadistica_jugador_partido VALUES (78, 13, 21, 0, NULL, 1, 0, 0, 'N');

--Boleteria por partido y categoria (la suma vendida es igual a la asistencia y no supera la capacidad)
INSERT INTO entrada VALUES (1, 1, 'CATEGORIA_1', 450.00, 12450);
INSERT INTO entrada VALUES (2, 1, 'CATEGORIA_2', 250.00, 24900);
INSERT INTO entrada VALUES (3, 1, 'CATEGORIA_3', 120.00, 29050);
INSERT INTO entrada VALUES (4, 1, 'HOSPITALIDAD', 1500.00, 4150);
INSERT INTO entrada VALUES (5, 2, 'CATEGORIA_1', 450.00, 7200);
INSERT INTO entrada VALUES (6, 2, 'CATEGORIA_2', 250.00, 14400);
INSERT INTO entrada VALUES (7, 2, 'CATEGORIA_3', 120.00, 16800);
INSERT INTO entrada VALUES (8, 2, 'HOSPITALIDAD', 1500.00, 2400);
INSERT INTO entrada VALUES (9, 3, 'CATEGORIA_1', 450.00, 10500);
INSERT INTO entrada VALUES (10, 3, 'CATEGORIA_2', 250.00, 21000);
INSERT INTO entrada VALUES (11, 3, 'CATEGORIA_3', 120.00, 24500);
INSERT INTO entrada VALUES (12, 3, 'HOSPITALIDAD', 1500.00, 3500);
INSERT INTO entrada VALUES (13, 4, 'CATEGORIA_1', 450.00, 6750);
INSERT INTO entrada VALUES (14, 4, 'CATEGORIA_2', 250.00, 13500);
INSERT INTO entrada VALUES (15, 4, 'CATEGORIA_3', 120.00, 15750);
INSERT INTO entrada VALUES (16, 4, 'HOSPITALIDAD', 1500.00, 2250);
INSERT INTO entrada VALUES (17, 5, 'CATEGORIA_1', 450.00, 7200);
INSERT INTO entrada VALUES (18, 5, 'CATEGORIA_2', 250.00, 14400);
INSERT INTO entrada VALUES (19, 5, 'CATEGORIA_3', 120.00, 16800);
INSERT INTO entrada VALUES (20, 5, 'HOSPITALIDAD', 1500.00, 2400);
INSERT INTO entrada VALUES (21, 6, 'CATEGORIA_1', 450.00, 12450);
INSERT INTO entrada VALUES (22, 6, 'CATEGORIA_2', 250.00, 24900);
INSERT INTO entrada VALUES (23, 6, 'CATEGORIA_3', 120.00, 29050);
INSERT INTO entrada VALUES (24, 6, 'HOSPITALIDAD', 1500.00, 4150);
INSERT INTO entrada VALUES (25, 7, 'CATEGORIA_1', 450.00, 10500);
INSERT INTO entrada VALUES (26, 7, 'CATEGORIA_2', 250.00, 21000);
INSERT INTO entrada VALUES (27, 7, 'CATEGORIA_3', 120.00, 24500);
INSERT INTO entrada VALUES (28, 7, 'HOSPITALIDAD', 1500.00, 3500);
INSERT INTO entrada VALUES (29, 8, 'CATEGORIA_1', 450.00, 6750);
INSERT INTO entrada VALUES (30, 8, 'CATEGORIA_2', 250.00, 13500);
INSERT INTO entrada VALUES (31, 8, 'CATEGORIA_3', 120.00, 15750);
INSERT INTO entrada VALUES (32, 8, 'HOSPITALIDAD', 1500.00, 2250);
INSERT INTO entrada VALUES (33, 9, 'CATEGORIA_1', 450.00, 12450);
INSERT INTO entrada VALUES (34, 9, 'CATEGORIA_2', 250.00, 24900);
INSERT INTO entrada VALUES (35, 9, 'CATEGORIA_3', 120.00, 29050);
INSERT INTO entrada VALUES (36, 9, 'HOSPITALIDAD', 1500.00, 4150);
INSERT INTO entrada VALUES (37, 10, 'CATEGORIA_1', 450.00, 7200);
INSERT INTO entrada VALUES (38, 10, 'CATEGORIA_2', 250.00, 14400);
INSERT INTO entrada VALUES (39, 10, 'CATEGORIA_3', 120.00, 16800);
INSERT INTO entrada VALUES (40, 10, 'HOSPITALIDAD', 1500.00, 2400);
INSERT INTO entrada VALUES (41, 11, 'CATEGORIA_1', 450.00, 10500);
INSERT INTO entrada VALUES (42, 11, 'CATEGORIA_2', 250.00, 21000);
INSERT INTO entrada VALUES (43, 11, 'CATEGORIA_3', 120.00, 24500);
INSERT INTO entrada VALUES (44, 11, 'HOSPITALIDAD', 1500.00, 3500);
INSERT INTO entrada VALUES (45, 12, 'CATEGORIA_1', 450.00, 6750);
INSERT INTO entrada VALUES (46, 12, 'CATEGORIA_2', 250.00, 13500);
INSERT INTO entrada VALUES (47, 12, 'CATEGORIA_3', 120.00, 15750);
INSERT INTO entrada VALUES (48, 12, 'HOSPITALIDAD', 1500.00, 2250);
INSERT INTO entrada VALUES (49, 13, 'CATEGORIA_1', 450.00, 12450);
INSERT INTO entrada VALUES (50, 13, 'CATEGORIA_2', 250.00, 24900);
INSERT INTO entrada VALUES (51, 13, 'CATEGORIA_3', 120.00, 29050);
INSERT INTO entrada VALUES (52, 13, 'HOSPITALIDAD', 1500.00, 4150);

--Acreditaciones de prensa
INSERT INTO acreditacion_prensa VALUES (1, 1, 'ACR-2026-0001', 'Laura Gomez', 'Caracol Television', 'TELEVISION', 'Colombia');
INSERT INTO acreditacion_prensa VALUES (2, 1, 'ACR-2026-0002', 'Martin Suarez', 'Ole', 'PRENSA_ESCRITA', 'Argentina');
INSERT INTO acreditacion_prensa VALUES (3, 1, 'ACR-2026-0003', 'Sofia Hernandez', 'Televisa Deportes', 'TELEVISION', 'Mexico');
INSERT INTO acreditacion_prensa VALUES (4, 1, 'ACR-2026-0004', 'Kevin Adams', 'The Athletic', 'DIGITAL', 'Estados Unidos');
INSERT INTO acreditacion_prensa VALUES (5, 1, 'ACR-2026-0005', 'Yuki Nakamura', 'NHK Radio', 'RADIO', 'Japon');
INSERT INTO acreditacion_prensa VALUES (6, 1, 'ACR-2026-0006', 'Elena Martin', 'Diario AS', 'PRENSA_ESCRITA', 'Espana');

--Incidencias
INSERT INTO incidencia VALUES (1, 3, 'SEGURIDAD', 34, 'MEDIA', 'Ingreso de un aficionado al campo de juego; el partido se detuvo dos minutos.');
INSERT INTO incidencia VALUES (2, 6, 'LESION', 58, 'ALTA', 'Lesion de rodilla del defensa local; salio en camilla.');
INSERT INTO incidencia VALUES (3, 9, 'CLIMATICA', 71, 'MEDIA', 'Tormenta electrica; el partido se suspendio 25 minutos.');
INSERT INTO incidencia VALUES (4, 10, 'FALLA_TECNICA', 15, 'BAJA', 'Falla temporal en la comunicacion del VAR.');
INSERT INTO incidencia VALUES (5, 13, 'INTERRUPCION', 88, 'BAJA', 'Lanzamiento de objetos desde la tribuna norte.');

--Auditoria (ejemplos de cambios registrados; en la Entrega 3 la llenara el trigger de auditoria)
INSERT INTO auditoria_evento VALUES (1, 'PARTICIPACION_PARTIDO', 'UPDATE', 17, 'ADMIN_TORNEO', TO_DATE('2026-06-24 21:10','YYYY-MM-DD HH24:MI'), 'goles_marcados=0', 'goles_marcados=1');
INSERT INTO auditoria_evento VALUES (2, 'PARTIDO', 'UPDATE', 9, 'ADMIN_TORNEO', TO_DATE('2026-06-24 21:12','YYYY-MM-DD HH24:MI'), 'estado=EN_JUEGO', 'estado=FINALIZADO');
INSERT INTO auditoria_evento VALUES (3, 'INCIDENCIA', 'INSERT', 3, 'ADMIN_TORNEO', TO_DATE('2026-06-24 21:15','YYYY-MM-DD HH24:MI'), NULL, 'tipo=CLIMATICA, minuto=71');

COMMIT;

--Comprobacion: cantidad de filas por tabla
SELECT 'CONFEDERACION' AS tabla, COUNT(*) AS filas FROM confederacion
UNION ALL
SELECT 'FEDERACION' AS tabla, COUNT(*) AS filas FROM federacion
UNION ALL
SELECT 'EDICION_MUNDIAL' AS tabla, COUNT(*) AS filas FROM edicion_mundial
UNION ALL
SELECT 'CIUDAD_SEDE' AS tabla, COUNT(*) AS filas FROM ciudad_sede
UNION ALL
SELECT 'ESTADIO' AS tabla, COUNT(*) AS filas FROM estadio
UNION ALL
SELECT 'FASE' AS tabla, COUNT(*) AS filas FROM fase
UNION ALL
SELECT 'GRUPO' AS tabla, COUNT(*) AS filas FROM grupo
UNION ALL
SELECT 'SELECCION' AS tabla, COUNT(*) AS filas FROM seleccion
UNION ALL
SELECT 'PARTIDO' AS tabla, COUNT(*) AS filas FROM partido
UNION ALL
SELECT 'PARTICIPACION_PARTIDO' AS tabla, COUNT(*) AS filas FROM participacion_partido
UNION ALL
SELECT 'JUGADOR' AS tabla, COUNT(*) AS filas FROM jugador
UNION ALL
SELECT 'CONVOCATORIA_JUGADOR' AS tabla, COUNT(*) AS filas FROM convocatoria_jugador
UNION ALL
SELECT 'CUERPO_TECNICO' AS tabla, COUNT(*) AS filas FROM cuerpo_tecnico
UNION ALL
SELECT 'ARBITRO' AS tabla, COUNT(*) AS filas FROM arbitro
UNION ALL
SELECT 'ASIGNACION_ARBITRAL' AS tabla, COUNT(*) AS filas FROM asignacion_arbitral
UNION ALL
SELECT 'ESTADISTICA_JUGADOR_PARTIDO' AS tabla, COUNT(*) AS filas FROM estadistica_jugador_partido
UNION ALL
SELECT 'ENTRADA' AS tabla, COUNT(*) AS filas FROM entrada
UNION ALL
SELECT 'ACREDITACION_PRENSA' AS tabla, COUNT(*) AS filas FROM acreditacion_prensa
UNION ALL
SELECT 'INCIDENCIA' AS tabla, COUNT(*) AS filas FROM incidencia
UNION ALL
SELECT 'AUDITORIA_EVENTO' AS tabla, COUNT(*) AS filas FROM auditoria_evento;
