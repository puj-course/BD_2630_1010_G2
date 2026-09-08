--DDL Modelo inicial

--Limpieza previa
DROP TABLE participacion_partido;
DROP TABLE partido;
DROP TABLE seleccion;
DROP TABLE estadio;
DROP TABLE edicion_mundial;
DROP TABLE asistencia_partido;

--1. Edición mundial 
CREATE TABLE edicion_mundial (
  id_edicion    NUMBER PRIMARY KEY,
  anio          NUMBER(4) NOT NULL,
  pais_sede     VARCHAR2 (100) NOT NULL,
  lema          VARCHAR2 (200) NOT NULL,
  fecha_inicio  DATE NOT NULL,
  fecha_fin     DATE NOT NULL,
  CONSTRAINT chk_edicion_fechas CHECK (fecha_fin > fecha_inicio)
);

--2. Estadio
CREATE TABLE estadio (
  id_estadio    NUMBER PRIMARY KEY,
  id_edicion    NUMBER NOT NULL,
  nombre        VARCHAR2(150) NOT NULL,
  ciudad        VARCHAR2 (100) NOT NULL,
  capacidad     NUMBER NOT NULL,
  CONSTRAINT fk_estadio_edicion
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial (id_edicion),
  CONSTRAINT chk_estadio_capacidad CHECK (capacidad > 0  AND capacidad <= 150000)
);

--3. Seleccion
CREATE TABLE seleccion (
  id_seleccion    NUMBER PRIMARY KEY,
  id_edicion      NUMBER NOT NULL,
  pais            VARCHAR2(100) NOT NULL,
  confederacion   VARCHAR2(50) NOT NULL,
  CONSTRAINT fk_seleccion_edicion
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial (id_edicion),
  CONSTRAINT uq_seleccion_pais_edicion UNIQUE (id_edicion, pais)
);

--4. PARTIDO
CREATE TABLE partido (
  id_partido    NUMBER PRIMARY KEY,
  id_edicion    NUMBER NOT NULL,
  id_estadio    NUMBER NOT NULL,
  fase          VARCHAR2(50) NOT NULL,
  fecha_hora    DATE NOT NULL,
  CONSTRAINT fk_partido_edicion
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial (id_edicion),
  CONSTRAINT fk_partido_estadio
    FOREIGN KEY (id_estadio) REFERENCES estadio (id_estadio),
  CONSTRAINT uq_partido_estadio_fechahora UNIQUE (id_estadio, fecha_hora)
);

--5. Participación partido
  id_participacion    NUMBER PRIMARY KEY,
  id_partido          NUMBER NOT NULL,
  id_seleccion        NUMBER NOT NULL,
  condicion           VARCHAR2(20) NOT NULL,
  goles_marcados      NUMBER NOT NULL,
  CONSTRAINT fk_participaciones_partido
    FOREIGN KEY (id_partido) REFERENCES partido (id_partido)
    ON DELETE CASCADE,
  CONSTRAINT fk_partidos_seleccion
    FOREIGN KEY (id_seleccion) REFERENCES seleccion (id_seleccion),
  CONSTRAINT chk_participacion_goles CHECK (goles_marcados >= 0),
  CONSTRAINT chk_participacion_condicion CHECK (condicion IN ('local', 'visitante')),
  CONSTRAINT uq_participacion_partido_seleccion UNIQUE (id_partido, id_seleccion),
  CONSTRAINT uq_participacion_partido_condicion UNIQUE (id_partido, condicion)
);

--------------------------------------------------------------------
-- Tabla auxiliar ASISTENCIA_PARTIDO
-- MORENOLUIS.FIFA_ESTADIO / FIFA_PARTIDO no tienen ningun atributo de
-- asistencia y son de solo lectura, asi que esta tabla propia guarda la
-- asistencia estimada por partido para poder calcular el % de ocupacion
-- (Vista 3, Consulta 2, Consulta 8).
-- IMPORTANTE: id_partido AQUI se refiere a MORENOLUIS.FIFA_PARTIDO, no
-- a la tabla PARTIDO propia de arriba (esa es para el ciclo de vida en
-- sql/dml/dml_ciclo_vida_partido.sql, un conjunto de datos separado).
-- Por eso no lleva FOREIGN KEY: no se puede declarar una FK contra una
-- tabla de otro esquema que no controlamos.
--------------------------------------------------------------------
CREATE TABLE asistencia_partido (
  id_partido       NUMBER PRIMARY KEY,
  asistencia_real  NUMBER NOT NULL,
  CONSTRAINT chk_asistencia_no_negativa CHECK (asistencia_real >= 0)
);

--Índices

CREATE INDEX idx_partido_edicion ON partido(id_edicion);

CREATE INDEX idx_participacion_seleccion ON participacion_partido(id_seleccion);

--Comprobación
SELECT table_name FROM user_tables 
WHERE table_name IN ('EDICION_MUNDIAL','ESTADIO','SELECCION','PARTIDO', 'PARTICIPACION_PARTIDO','ASISTENCIA_PARTIDO');
