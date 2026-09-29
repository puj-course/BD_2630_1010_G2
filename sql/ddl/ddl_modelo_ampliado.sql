// modelo ampliado segunda entrega

--Confederacion
CREATE TABLE confederacion (
    id_confederacion numeric PRIMARY KEY,
    sigla varchar (50) NOT NULL ,
    nombre varchar (900) NOT NULL 
);

--Federacion
CREATE TABLE federacion (
    id_federacion numeric PRIMARY KEY,
    id_confederacion numeric NOT NULL,
    nombre varchar (100) NOT NULL ,
    pais varchar (100) NOT NULL ,
    codigo_fifa char(3) NOT NULL ,
    FOREIGN KEY (id_confederacion) REFERENCES confederacion(id_confederacion)
);

--Ciudad
CREATE TABLE ciudad (
    id_ciudad numeric PRIMARY KEY,
    id_edicion numeric NOT NULL,
    id_federacion numeric NOT NULL,
    nombre varchar (80) NOT NULL,
    UNIQUE (id_edicion, nombre),
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial(id_edicion),
    FOREIGN KEY (id_federacion) REFERENCES federacion(id_federacion)
);

--Fases eliminatorias
CREATE TABLE fase_eliminatorias (
    id_fase numeric PRIMARY KEY,
    id_edicion numeric NOT NULL,
    nombre varchar (50) NOT NULL,
    orden numeric NOT NULL,
    UNIQUE (id_edicion, nombre),
    UNIQUE (id_edicion, orden),
    CHECK (nombre IN ('GRUPOS','DIECISEISAVOS','OCTAVOS','CUARTOS',
    'SEMIFINAL','TERCER_PUESTO','FINAL')),
    CHECK (orden BETWEEN 1 AND 7),
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial(id_edicion)
);

--Grupos
CREATE TABLE grupos (
    id_grupo numeric PRIMARY KEY,
    id_edicion numeric NOT NULL,
    letra CHAR(1) NOT NULL,
    UNIQUE (id_edicion, letra),
    CHECK (letra BETWEEN 'A' AND 'L'),
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial(id_edicion)
);

--Jugadores
CREATE TABLE jugadores (
    id_jugador numeric PRIMARY KEY,
    id_federacion numeric NOT NULL,
    nombres varchar (50) NOT NULL,
    apellidos varchar (50) NOT NULL,
    fecha_nacimiento date NOT NULL,
    posicion varchar (4) NOT NULL,
    club_actual varchar (50),
    CHECK (posicion IN ('Por','Def','Med','Del')),
    FOREIGN KEY (id_federacion) REFERENCES federacion(id_federacion)
);

--Arbitros
CREATE TABLE arbitros (
    id_arbitro numeric PRIMARY KEY,
    id_federacion numeric NOT NULL,
    nombres varchar (50) NOT NULL,
    apellidos varchar (50) NOT NULL,
    especialidad varchar (10) NOT NULL,
    CHECK (especialidad IN ('CAMPO','ASISTENTE','VAR')),
    FOREIGN KEY (id_federacion) REFERENCES federacion(id_federacion)
);

--Cuerpo tecnico
CREATE TABLE cuerpo_tecnico (
    id_miembro numeric PRIMARY KEY,
    id_seleccion numeric NOT NULL,
    nombres varchar (50) NOT NULL,
    apellidos varchar (50) NOT NULL,
    rol varchar (50) NOT NULL,
    nacionalidad varchar (50),
    CHECK (rol IN ('Entrenador','Asistente','Preparador_fisico',
    'ENTRENADOR_ARQUEROS','MEDICO')),
    FOREIGN KEY (id_seleccion) REFERENCES seleccion(id_seleccion)
        ON DELETE CASCADE
);

--Convocatoria de jugador
CREATE TABLE convocatoria_jugador (
    id_convocatoria numeric PRIMARY KEY,
    id_seleccion numeric NOT NULL,
    id_edicion numeric NOT NULL,
    id_jugador numeric NOT NULL,
    dorsal numeric NOT NULL,
    es_capitan char(1) DEFAULT 'N' NOT NULL,--rrrr
    UNIQUE (id_seleccion, dorsal),     
    UNIQUE (id_edicion, id_jugador),  
    CHECK (dorsal BETWEEN 1 AND 26),
    CHECK (es_capitan IN ('S','N')),
    FOREIGN KEY (id_seleccion) REFERENCES seleccion(id_seleccion)
        ON DELETE CASCADE,
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial(id_edicion),
    FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador)
);

--Asignacion arbitral
CREATE TABLE asignacion_arbitral (
    id_asignacion numeric PRIMARY KEY,
    id_partido numeric NOT NULL,
    id_arbitro numeric NOT NULL,
    rol varchar (30) NOT NULL,
    UNIQUE (id_partido, rol),
    UNIQUE (id_partido, id_arbitro),
    CHECK (rol IN ('CENTRAL','ASISTENTE_1','ASISTENTE_2',
                   'CUARTO','VAR','AVAR')),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
        ON DELETE CASCADE,
    FOREIGN KEY (id_arbitro) REFERENCES arbitros(id_arbitro)
);

--Estadisticas
CREATE TABLE estadisticas (
    id_estadistica numeric PRIMARY KEY,
    id_partido numeric NOT NULL,
    id_convocatoria numeric NOT NULL,
    minuto_entrada numeric NOT NULL,
    minuto_salida numeric,
    --aqui le ponenos DEFAULT 0 al numeric, porque si importa que este limpio el nuemro
    goles numeric DEFAULT 0 NOT NULL,
    autogoles numeric DEFAULT 0 NOT NULL,
    asistencias numeric DEFAULT 0 NOT NULL,
    tiros numeric DEFAULT 0 NOT NULL,
    tarjetas_amarillas numeric DEFAULT 0 NOT NULL,
    tarjeta_roja numeric DEFAULT 0 NOT NULL,
    UNIQUE (id_partido, id_convocatoria),
    CHECK (goles >= 0 AND autogoles >= 0 AND asistencias >= 0),
    CHECK (goles <= tiros),
    CHECK (tarjetas_amarillas BETWEEN 0 AND 2),
    CHECK (tarjeta_roja BETWEEN 0 AND 1),
    CHECK (minuto_entrada BETWEEN 0 AND 130),
    CHECK (minuto_salida IS NULL OR minuto_salida > minuto_entrada),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
        ON DELETE CASCADE,
    FOREIGN KEY (id_convocatoria) REFERENCES convocatoria_jugador(id_convocatoria)
);

--Boleteria
CREATE TABLE boleteria (
    id_entrada numeric PRIMARY KEY,
    id_partido numeric NOT NULL,
    categoria varchar (50) NOT NULL,
    zona varchar (50) NOT NULL,
    fila varchar (50) NOT NULL,
    asiento varchar (50) NOT NULL,
    precio numeric(8,2) NOT NULL,   -- necesita decimales
    fecha_venta DATE NOT NULL,
    UNIQUE (id_partido, zona, fila, asiento),  
    CHECK (precio > 0),
    CHECK (categoria IN CHECK ('General','Preferencial','Platea','VIP')),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
);

--Medios
CREATE TABLE medios (
    id_acreditacion numeric PRIMARY KEY,
    id_edicion numeric NOT NULL,
    nombres_periodista varchar (50) NOT NULL,
    apellidos_periodista varchar (50) NOT NULL,
    medio varchar (50) NOT NULL,
    pais_medio varchar (50) NOT NULL,
    tipo_medio varchar (50) NOT NULL,
    fecha_transmicion DATE NOT NULL,
    estado varchar (50) DEFAULT 'VIGENTE' NOT NULL,
    CHECK (tipo_medio IN ('TV','Radio','Escrito','Digital','Fotografia')),
    CHECK (estado IN ('VIGENTE','REVOCADA')),
    FOREIGN KEY (id_edicion) REFERENCES edicion_mundial(id_edicion)
);

--Incidencias
CREATE TABLE incidencias (
    id_incidencia numeric PRIMARY KEY,
    id_partido numeric NOT NULL,
    tipo varchar (50) NOT NULL,
    minuto numeric NOT NULL,
    gravedad varchar (50) NOT NULL,
    descripcion varchar (500) NOT NULL,
    CHECK (tipo IN ('CLIMATICA','DISCIPLINARIA','TECNICA','SEGURIDAD','VAR')),
    CHECK (gravedad IN ('BAJA','MEDIA','ALTA')),
    CHECK (minuto >= 0),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido)
        ON DELETE CASCADE
);

CREATE TABLE auditoria_evento (
    id_auditoria numeric PRIMARY KEY,
    tabla_afectada varchar (50) NOT NULL,
    operacion varchar (40) NOT NULL,
    id_registro numeric NOT NULL,
    usuario_bd varchar (50) DEFAULT USER NOT NULL,
    fecha_evento DATE DEFAULT DATE NOT NULL,--preguntar
    detalle_antes_del_cambio varchar (4000),
    detalle_despues_del_cambio varchar (4000),
    CHECK (operacion IN ('insertar','actualizar','eliminar'))
);





  