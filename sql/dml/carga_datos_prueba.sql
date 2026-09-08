-- =====================================================================
rchivo: carga_datos_prueba.sql

-- =====================================================================

SET SERVEROUTPUT ON

DECLARE
  TYPE t_str_arr IS TABLE OF VARCHAR2(80);
  v_paises   t_str_arr := t_str_arr('Brasil','Argentina','Alemania','Francia','España','Italia',
                                     'Inglaterra','Portugal','Países Bajos','Bélgica','Croacia',
                                     'Uruguay','México','Colombia','Chile','Japón','Corea del Sur','Marruecos');
  v_confeds  t_str_arr := t_str_arr('CONMEBOL','CONMEBOL','UEFA','UEFA','UEFA','UEFA','UEFA','UEFA',
                                     'UEFA','UEFA','UEFA','CONMEBOL','CONCACAF','CONMEBOL','CONMEBOL',
                                     'AFC','AFC','CAF');
  v_ciudades t_str_arr := t_str_arr('Múnich','Milán','Mánchester','Lisboa','Ámsterdam','Bruselas',
                                     'Zagreb','Varsovia','Belgrado','Copenhague','Ciudad de México',
                                     'Bogotá','Santiago','Tokio','Seúl','Casablanca','São Paulo','Buenos Aires');

  TYPE t_num_arr IS TABLE OF NUMBER;
  v_anios       t_num_arr := t_num_arr(2030, 2034, 1998, 2002, 2010, 2014);
  v_capacidades t_num_arr := t_num_arr(45000,52000,68000,74000,81000,39000,56000,63000,49000,
                                        71000,44000,58000,66000,53000,47000,60000,42000,69000);

  v_id_edicion        NUMBER;
  v_estadio_base       NUMBER;
  v_seleccion_base      NUMBER;
  v_id_partido          NUMBER;
  v_id_participacion    NUMBER := 6000;
  v_fecha_inicio        DATE;
  v_fecha_fin           DATE;
  v_fecha_partido       DATE;
  v_local               NUMBER;
  v_visitante           NUMBER;
BEGIN
  FOR e IN 1..6 LOOP
    v_id_edicion   := 500 + e;
    v_fecha_inicio := TO_DATE('01/06/' || v_anios(e), 'DD/MM/YYYY');
    v_fecha_fin    := TO_DATE('15/07/' || v_anios(e), 'DD/MM/YYYY');

    INSERT INTO edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
    VALUES (v_id_edicion, v_anios(e), 'Sede de prueba ' || v_anios(e),
            'Lema de prueba ' || v_anios(e), v_fecha_inicio, v_fecha_fin);

    v_estadio_base   := 500 + (e-1)*18;
    v_seleccion_base := 500 + (e-1)*18;

    FOR i IN 1..18 LOOP
      INSERT INTO estadio (id_estadio, id_edicion, nombre, ciudad, capacidad)
      VALUES (v_estadio_base + i, v_id_edicion, 'Estadio Prueba ' || (v_estadio_base + i),
              v_ciudades(i), v_capacidades(i));

      INSERT INTO seleccion (id_seleccion, id_edicion, pais, confederacion)
      VALUES (v_seleccion_base + i, v_id_edicion, v_paises(i), v_confeds(i));
    END LOOP;

    FOR i IN 1..18 LOOP
      v_id_partido    := 5000 + (e-1)*18 + i;
      v_fecha_partido := v_fecha_inicio + TRUNC((i-1) * 44 / 18);
      v_local         := v_seleccion_base + i;
      v_visitante     := v_seleccion_base + MOD(i, 18) + 1;

      INSERT INTO partido (id_partido, id_edicion, id_estadio, fase, fecha_hora)
      VALUES (v_id_partido, v_id_edicion, v_estadio_base + i, 'Fase de Grupos', v_fecha_partido);

      v_id_participacion := v_id_participacion + 1;
      INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
      VALUES (v_id_participacion, v_id_partido, v_local, 'local', TRUNC(DBMS_RANDOM.VALUE(0,5)));

      v_id_participacion := v_id_participacion + 1;
      INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
      VALUES (v_id_participacion, v_id_partido, v_visitante, 'visitante', TRUNC(DBMS_RANDOM.VALUE(0,5)));
    END LOOP;
  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Carga masiva completada: 6 ediciones, 108 estadios, 108 selecciones, 108 partidos, 216 participaciones.');
END;
/

-- ---------------------------------------------------------------------
-- Verificacion: confirma que cada tabla llega al minimo de 100 filas
-- (guarda este resultado, sirve como evidencia para la sustentacion)
-- ---------------------------------------------------------------------
SELECT 'EDICION_MUNDIAL' AS tabla, COUNT(*) AS total FROM edicion_mundial
UNION ALL
SELECT 'ESTADIO', COUNT(*) FROM estadio
UNION ALL
SELECT 'SELECCION', COUNT(*) FROM seleccion
UNION ALL
SELECT 'PARTIDO', COUNT(*) FROM partido
UNION ALL
SELECT 'PARTICIPACION_PARTIDO', COUNT(*) FROM participacion_partido;