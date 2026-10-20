-- ddl modelo ampliado

--Limpieza previa 
BEGIN
    FOR t IN (SELECT column_value AS nombre FROM TABLE(sys.odcivarchar2list(
        'AUDITORIA_EVENTO',
        'INCIDENCIA',
        'ACREDITACION_PRENSA',
        'ENTRADA',
        'ESTADISTICA_JUGADOR_PARTIDO',
        'ASIGNACION_ARBITRAL',
        'ARBITRO',
        'CUERPO_TECNICO',
        'CONVOCATORIA_JUGADOR',
        'JUGADOR',
        'PARTICIPACION_PARTIDO',
        'PARTIDO',
        'SELECCION',
        'GRUPO',
        'FASE',
        'ESTADIO',
        'CIUDAD_SEDE',
        'EDICION_MUNDIAL',
        'FEDERACION',
        'CONFEDERACION'
    ))) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || t.nombre || ' CASCADE CONSTRAINTS PURGE';
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE != -942 THEN RAISE; END IF;
        END;
    END LOOP;
END;
/

--Confederacion
CREATE TABLE confederacion (
    id_confederacion number,
    sigla varchar2(10) NOT NULL,
    nombre varchar2(150) NOT NULL,
    CONSTRAINT pk_confederacion PRIMARY KEY (id_confederacion),
    CONSTRAINT uq_confederacion_sigla UNIQUE (sigla),
    CONSTRAINT chk_confederacion_sigla CHECK (sigla IN ('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA'))
);

--Federacion
CREATE TABLE federacion (
    id_federacion number,
    id_confederacion number NOT NULL,
    pais varchar2(100) NOT NULL,
    codigo_fifa char(3) NOT NULL,
    CONSTRAINT pk_federacion PRIMARY KEY (id_federacion),
    CONSTRAINT uq_federacion_pais UNIQUE (pais),
    CONSTRAINT uq_federacion_codigo UNIQUE (codigo_fifa),
    CONSTRAINT chk_federacion_codigo CHECK (codigo_fifa = UPPER(codigo_fifa)),
    CONSTRAINT fk_federacion_confederacion FOREIGN KEY (id_confederacion)
    REFERENCES confederacion(id_confederacion) -- restrictivo: catalogo maestro
);

--Edicion mundial
CREATE TABLE edicion_mundial (
    id_edicion number,
    anio number(4) NOT NULL,
    nombre_oficial varchar2(150) NOT NULL,
    lema varchar2(200) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    cupo_convocatoria number(2) NOT NULL,
    num_selecciones number(3) NOT NULL,
    CONSTRAINT pk_edicion_mundial PRIMARY KEY (id_edicion),
    CONSTRAINT uq_edicion_anio UNIQUE (anio),
    CONSTRAINT chk_edicion_fechas CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT chk_edicion_cupo CHECK (cupo_convocatoria > 0),
    CONSTRAINT chk_edicion_num_selecciones CHECK (num_selecciones > 0)
);

--Ciudad sede
CREATE TABLE ciudad_sede (
    id_ciudad number,
    id_edicion number NOT NULL,
    nombre varchar2(100) NOT NULL,
    pais varchar2(100) NOT NULL,
    CONSTRAINT pk_ciudad_sede PRIMARY KEY (id_ciudad),
    CONSTRAINT uq_ciudad_sede_edicion_nombre_pais UNIQUE (id_edicion, nombre, pais),
    CONSTRAINT fk_ciudad_sede_edicion FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial(id_edicion) 
);
--Estadio
CREATE TABLE estadio (
    id_estadio number,
    id_ciudad number NOT NULL,
    nombre varchar2(150) NOT NULL,
    capacidad number NOT NULL,
    CONSTRAINT pk_estadio PRIMARY KEY (id_estadio),
    CONSTRAINT uq_estadio_ciudad_nombre UNIQUE (id_ciudad, nombre),
    CONSTRAINT chk_estadio_capacidad CHECK (capacidad > 0 AND capacidad <= 150000),
    CONSTRAINT fk_estadio_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad_sede(id_ciudad) 
);

--Fase
CREATE TABLE fase (
    id_fase number,
    id_edicion number NOT NULL,
    nombre varchar2(50) NOT NULL,
    orden number(2) NOT NULL,
    num_clasificados number(3),
    CONSTRAINT pk_fase PRIMARY KEY (id_fase),
    CONSTRAINT uq_fase_edicion_nombre UNIQUE (id_edicion, nombre),
    CONSTRAINT uq_fase_edicion_orden UNIQUE (id_edicion, orden),
    CONSTRAINT chk_fase_nombre CHECK (nombre IN ('GRUPOS','DIECISEISAVOS','OCTAVOS','CUARTOS',
        'SEMIFINAL','TERCER_PUESTO','FINAL')),
    CONSTRAINT chk_fase_orden CHECK (orden BETWEEN 1 AND 7),
    CONSTRAINT chk_fase_clasificados CHECK (num_clasificados >= 0),
    CONSTRAINT fk_fase_edicion FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial(id_edicion) -- restrictivo: las fases son la estructura del torneo
);

--Grupo
CREATE TABLE grupo (
    id_grupo number,
    id_fase number NOT NULL,
    nombre char(1) NOT NULL,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT uq_grupo_fase_nombre UNIQUE (id_fase, nombre),
    CONSTRAINT chk_grupo_nombre CHECK (nombre BETWEEN 'A' AND 'L'),
    CONSTRAINT fk_grupo_fase FOREIGN KEY (id_fase)
        REFERENCES fase(id_fase) -- restrictivo: no se borra una fase con grupos
);

--Seleccion
CREATE TABLE seleccion (
    id_seleccion number,
    id_edicion number NOT NULL,
    id_federacion number NOT NULL,
    id_grupo number,
    ranking_fifa number(3),
    CONSTRAINT pk_seleccion PRIMARY KEY (id_seleccion),
    CONSTRAINT uq_seleccion_edicion_federacion UNIQUE (id_edicion, id_federacion),
    CONSTRAINT chk_seleccion_ranking CHECK (ranking_fifa > 0),
    CONSTRAINT fk_seleccion_edicion FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial(id_edicion), -- restrictivo: no se borra una edicion con selecciones
    CONSTRAINT fk_seleccion_federacion FOREIGN KEY (id_federacion)
        REFERENCES federacion(id_federacion), -- restrictivo: se conserva el historial del pais
    CONSTRAINT fk_seleccion_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo(id_grupo) -- restrictivo: no se borra un grupo con selecciones
);

--Partido
CREATE TABLE partido (
    id_partido number,
    id_fase number NOT NULL,
    id_estadio number NOT NULL,
    id_grupo number,
    codigo_llave varchar2(10),
    fecha_hora date NOT NULL,
    estado varchar2(20) DEFAULT 'PROGRAMADO' NOT NULL,
    asistencia number,
    definido_por_penales char(1) DEFAULT 'N' NOT NULL,
    tiempo_extra char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_partido PRIMARY KEY (id_partido),
    CONSTRAINT uq_partido_estadio_fechahora UNIQUE (id_estadio, fecha_hora),
    CONSTRAINT chk_partido_estado CHECK (estado IN ('PROGRAMADO','EN_JUEGO','FINALIZADO','SUSPENDIDO')),
    CONSTRAINT chk_partido_asistencia CHECK (asistencia >= 0),
    CONSTRAINT chk_partido_penales CHECK (definido_por_penales IN ('S','N')),
    CONSTRAINT chk_partido_tiempo_extra CHECK (tiempo_extra IN ('S','N')),
    CONSTRAINT chk_partido_grupo_llave CHECK (id_grupo IS NULL OR codigo_llave IS NULL), -- no puede ser de grupos y de eliminatoria a la vez
    CONSTRAINT fk_partido_fase FOREIGN KEY (id_fase)
        REFERENCES fase(id_fase), -- restrictivo: no se borra una fase con partidos
    CONSTRAINT fk_partido_estadio FOREIGN KEY (id_estadio)
        REFERENCES estadio(id_estadio), -- restrictivo: no se borra un estadio con partidos
    CONSTRAINT fk_partido_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo(id_grupo) -- restrictivo: no se borra un grupo con partidos
);

--Participacion partido
CREATE TABLE participacion_partido (
    id_participacion number,
    id_partido number NOT NULL,
    id_seleccion number NOT NULL,
    condicion varchar2(10) NOT NULL,
    goles_marcados number(2) DEFAULT 0 NOT NULL,
    goles_penales number(2),
    resultado char(1),
    CONSTRAINT pk_participacion_partido PRIMARY KEY (id_participacion),
    CONSTRAINT uq_participacion_partido_seleccion UNIQUE (id_partido, id_seleccion),
    CONSTRAINT uq_participacion_partido_condicion UNIQUE (id_partido, condicion),
    CONSTRAINT chk_participacion_condicion CHECK (condicion IN ('LOCAL','VISITANTE')),
    CONSTRAINT chk_participacion_goles CHECK (goles_marcados >= 0),
    CONSTRAINT chk_participacion_penales CHECK (goles_penales >= 0),
    CONSTRAINT chk_participacion_resultado CHECK (resultado IN ('G','E','P')),
    CONSTRAINT fk_participacion_partido FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido) ON DELETE CASCADE, -- cascade: no existe sin su partido
    CONSTRAINT fk_participacion_seleccion FOREIGN KEY (id_seleccion)
        REFERENCES seleccion(id_seleccion) -- restrictivo: no se borra una seleccion que ya jugo
);

--Jugador
CREATE TABLE jugador (
    id_jugador number,
    nombres varchar2(100) NOT NULL,
    apellidos varchar2(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    posicion varchar2(15) NOT NULL,
    CONSTRAINT pk_jugador PRIMARY KEY (id_jugador),
    CONSTRAINT chk_jugador_posicion CHECK (posicion IN ('PORTERO','DEFENSA','MEDIOCAMPISTA','DELANTERO'))
);

--Convocatoria jugador
CREATE TABLE convocatoria_jugador (
    id_convocatoria number,
    id_seleccion number NOT NULL,
    id_jugador number NOT NULL,
    dorsal number(2) NOT NULL,
    es_capitan char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_convocatoria_jugador PRIMARY KEY (id_convocatoria),
    CONSTRAINT uq_convocatoria_seleccion_jugador UNIQUE (id_seleccion, id_jugador),
    CONSTRAINT uq_convocatoria_seleccion_dorsal UNIQUE (id_seleccion, dorsal),
    CONSTRAINT chk_convocatoria_dorsal CHECK (dorsal BETWEEN 1 AND 26),
    CONSTRAINT chk_convocatoria_capitan CHECK (es_capitan IN ('S','N')),
    CONSTRAINT fk_convocatoria_seleccion FOREIGN KEY (id_seleccion)
        REFERENCES seleccion(id_seleccion) ON DELETE CASCADE, 
    CONSTRAINT fk_convocatoria_jugador FOREIGN KEY (id_jugador)
        REFERENCES jugador(id_jugador) -- restrictivo: no se borra un jugador convocado
);


--Cuerpo tecnico
CREATE TABLE cuerpo_tecnico (
    id_miembro number,
    id_seleccion number NOT NULL,
    nombres varchar2(100) NOT NULL,
    apellidos varchar2(100) NOT NULL,
    nacionalidad varchar2(100) NOT NULL,
    rol varchar2(30) NOT NULL,
    CONSTRAINT pk_cuerpo_tecnico PRIMARY KEY (id_miembro),
    CONSTRAINT chk_cuerpotecnico_rol CHECK (rol IN ('ENTRENADOR_PRINCIPAL','ASISTENTE_TECNICO',
        'PREPARADOR_FISICO','ENTRENADOR_PORTEROS','MEDICO')),
    CONSTRAINT fk_cuerpotecnico_seleccion FOREIGN KEY (id_seleccion)
        REFERENCES seleccion(id_seleccion) ON DELETE CASCADE -- cascade: el cuerpo tecnico pertenece a la seleccion
);

--Arbitro
CREATE TABLE arbitro (
    id_arbitro number,
    id_confederacion number NOT NULL,
    nombres varchar2(100) NOT NULL,
    apellidos varchar2(100) NOT NULL,
    nacionalidad varchar2(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    CONSTRAINT pk_arbitro PRIMARY KEY (id_arbitro),
    CONSTRAINT fk_arbitro_confederacion FOREIGN KEY (id_confederacion)
        REFERENCES confederacion(id_confederacion) -- restrictivo: catalogo maestro
);

--Asignacion arbitral
CREATE TABLE asignacion_arbitral (
    id_asignacion number,
    id_partido number NOT NULL,
    id_arbitro number NOT NULL,
    rol varchar2(20) NOT NULL,
    CONSTRAINT pk_asignacion_arbitral PRIMARY KEY (id_asignacion),
    CONSTRAINT uq_asignacion_partido_arbitro UNIQUE (id_partido, id_arbitro),
    CONSTRAINT uq_asignacion_partido_rol UNIQUE (id_partido, rol),
    CONSTRAINT chk_asignacion_rol CHECK (rol IN ('PRINCIPAL','ASISTENTE_1','ASISTENTE_2',
        'CUARTO_ARBITRO','VAR','AVAR')),
    CONSTRAINT fk_asignacion_partido FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido) ON DELETE CASCADE, -- cascade: la designacion pertenece al partido
    CONSTRAINT fk_asignacion_arbitro FOREIGN KEY (id_arbitro)
        REFERENCES arbitro(id_arbitro) -- restrictivo: no se borra un arbitro que ya dirigio
);

--Estadistica jugador partido
CREATE TABLE estadistica_jugador_partido (
    id_estadistica number,
    id_partido number NOT NULL,
    id_convocatoria number NOT NULL,
    minuto_entrada number(3) NOT NULL,
    minuto_salida number(3),
    goles number(2) DEFAULT 0 NOT NULL,
    asistencias number(2) DEFAULT 0 NOT NULL,
    tarjetas_amarillas number(1) DEFAULT 0 NOT NULL,
    tarjeta_roja char(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT pk_estadistica_jugador_partido PRIMARY KEY (id_estadistica),
    CONSTRAINT uq_estadistica_partido_convocatoria UNIQUE (id_partido, id_convocatoria),
    CONSTRAINT chk_estadistica_minuto_entrada CHECK (minuto_entrada >= 0),
    CONSTRAINT chk_estadistica_minuto_salida CHECK (minuto_salida IS NULL OR minuto_salida >= minuto_entrada),
    CONSTRAINT chk_estadistica_goles CHECK (goles >= 0),
    CONSTRAINT chk_estadistica_asistencias CHECK (asistencias >= 0),
    CONSTRAINT chk_estadistica_amarillas CHECK (tarjetas_amarillas BETWEEN 0 AND 2),
    CONSTRAINT chk_estadistica_roja CHECK (tarjeta_roja IN ('S','N')),
    CONSTRAINT fk_estadistica_partido FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido) ON DELETE CASCADE, -- cascade: las estadisticas pertenecen al partido
    CONSTRAINT fk_estadistica_convocatoria FOREIGN KEY (id_convocatoria)
        REFERENCES convocatoria_jugador(id_convocatoria) -- restrictivo: no se borra un convocado con estadisticas
);

--Entrada
CREATE TABLE entrada (
    id_entrada number,
    id_partido number NOT NULL,
    categoria varchar2(20) NOT NULL,
    precio number(10,2) NOT NULL,
    cantidad_vendida number NOT NULL,
    CONSTRAINT pk_entrada PRIMARY KEY (id_entrada),
    CONSTRAINT uq_entrada_partido_categoria UNIQUE (id_partido, categoria),
    CONSTRAINT chk_entrada_categoria CHECK (categoria IN ('CATEGORIA_1','CATEGORIA_2','CATEGORIA_3','HOSPITALIDAD')),
    CONSTRAINT chk_entrada_precio CHECK (precio >= 0),
    CONSTRAINT chk_entrada_cantidad CHECK (cantidad_vendida >= 0),
    CONSTRAINT fk_entrada_partido FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido) ON DELETE CASCADE -- cascade: la boleteria pertenece al partido
);

--Acreditacion prensa
CREATE TABLE acreditacion_prensa (
    id_acreditacion number,
    id_edicion number NOT NULL,
    codigo_acreditacion varchar2(20) NOT NULL,
    nombre_periodista varchar2(150) NOT NULL,
    medio varchar2(100) NOT NULL,
    tipo_medio varchar2(20) NOT NULL,
    pais_medio varchar2(100) NOT NULL,
    CONSTRAINT pk_acreditacion_prensa PRIMARY KEY (id_acreditacion),
    CONSTRAINT uq_acreditacion_codigo UNIQUE (codigo_acreditacion),
    CONSTRAINT chk_acreditacion_tipo CHECK (tipo_medio IN ('PRENSA_ESCRITA','RADIO','TELEVISION','DIGITAL')),
    CONSTRAINT fk_acreditacion_edicion FOREIGN KEY (id_edicion)
        REFERENCES edicion_mundial(id_edicion) -- restrictivo: no se borra una edicion con prensa acreditada
);

--Incidencia
CREATE TABLE incidencia (
    id_incidencia number,
    id_partido number NOT NULL,
    tipo varchar2(30) NOT NULL,
    minuto number(3) NOT NULL,
    gravedad varchar2(10) NOT NULL,
    descripcion varchar2(500) NOT NULL,
    CONSTRAINT pk_incidencia PRIMARY KEY (id_incidencia),
    CONSTRAINT chk_incidencia_tipo CHECK (tipo IN ('LESION','INTERRUPCION','SEGURIDAD',
        'FALLA_TECNICA','CLIMATICA','OTRA')),
    CONSTRAINT chk_incidencia_gravedad CHECK (gravedad IN ('BAJA','MEDIA','ALTA')),
    CONSTRAINT chk_incidencia_minuto CHECK (minuto >= 0),
    CONSTRAINT fk_incidencia_partido FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido) ON DELETE CASCADE -- cascade: la incidencia ocurrio en ese partido
);

--Auditoria evento (sin llaves foraneas a proposito: debe conservar el registro aunque se borre la fila original)
CREATE TABLE auditoria_evento (
    id_auditoria number,
    tabla_afectada varchar2(50) NOT NULL,
    operacion varchar2(10) NOT NULL,
    id_registro number NOT NULL,
    usuario varchar2(50) DEFAULT USER NOT NULL,
    fecha_hora date DEFAULT SYSDATE NOT NULL,
    valor_anterior varchar2(4000),
    valor_nuevo varchar2(4000),
    CONSTRAINT pk_auditoria_evento PRIMARY KEY (id_auditoria),
    CONSTRAINT chk_auditoria_operacion CHECK (operacion IN ('INSERT','UPDATE','DELETE'))
);

--Indices

CREATE INDEX idx_partido_fase ON partido(id_fase); -- partidos por fase y cierre de fase
CREATE INDEX idx_partido_grupo ON partido(id_grupo); -- tabla de posiciones por grupo
CREATE INDEX idx_partido_fecha ON partido(fecha_hora); -- calendario de partidos por fecha
CREATE INDEX idx_participacion_seleccion ON participacion_partido(id_seleccion); -- rendimiento de una seleccion
CREATE INDEX idx_seleccion_federacion ON seleccion(id_federacion); -- historial de un pais en los mundiales
CREATE INDEX idx_seleccion_grupo ON seleccion(id_grupo); -- selecciones de cada grupo
CREATE INDEX idx_convocatoria_jugador ON convocatoria_jugador(id_jugador); -- historial de un jugador
CREATE INDEX idx_estadistica_convocatoria ON estadistica_jugador_partido(id_convocatoria); -- ranking de goleadores
CREATE INDEX idx_asignacion_arbitro ON asignacion_arbitral(id_arbitro); -- partidos dirigidos por cada arbitro
CREATE INDEX idx_incidencia_partido ON incidencia(id_partido); -- reporte de incidencias por partido
CREATE INDEX idx_auditoria_tabla_fecha ON auditoria_evento(tabla_afectada, fecha_hora); -- consultas del rol auditor

--Comprobacion
SELECT table_name FROM user_tables ORDER BY table_name;


  
