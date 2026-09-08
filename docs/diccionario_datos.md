Diccionario de Datos — Entrega 1

El presente diccionario de datos describe de manera completa la estructura de las tablas del modelo inicial implementado en esta entrega, conforme a lo definido.

EDICION_MUNDIAL

id_edicion — NUMBER, no nulo, llave primaria. Identificador de la edición del Mundial.
anio — NUMBER(4), no nulo. Año en que se disputa la edición.
pais_sede — VARCHAR2(100), no nulo. País o países sede de la edición.
lema — VARCHAR2(200), no nulo. Lema o eslogan oficial de la edición.
fecha_inicio — DATE, no nulo. Restricción chk_edicion_fechas (fecha_fin mayor que fecha_inicio). Fecha de inicio del torneo.
fecha_fin — DATE, no nulo. Restricción chk_edicion_fechas. Fecha de cierre del torneo.

ESTADIO

id_estadio — NUMBER, no nulo, llave primaria. Identificador del estadio.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (restricción fk_estadio_edicion, comportamiento RESTRICT). Edición a la que pertenece el estadio.
nombre — VARCHAR2(150), no nulo. Nombre del estadio.
ciudad — VARCHAR2(100), no nulo. Ciudad en la que se ubica.
capacidad — NUMBER, no nulo. Restricción chk_estadio_capacidad (mayor que 0 y menor o igual a 150000). Aforo máximo del estadio.

SELECCION

id_seleccion — NUMBER, no nulo, llave primaria. Identificador de la selección.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (restricción fk_seleccion_edicion, comportamiento RESTRICT). Edición en la que participa la selección.
pais — VARCHAR2(100), no nulo. Restricción uq_seleccion_pais_edicion: única en conjunto con id_edicion. País que representa la selección.
confederacion — VARCHAR2(50), no nulo. Confederación a la que pertenece (UEFA, CONMEBOL, CONCACAF, entre otras).

PARTIDO

id_partido — NUMBER, no nulo, llave primaria. Identificador del partido.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (restricción fk_partido_edicion, comportamiento RESTRICT). Edición a la que pertenece el partido.
id_estadio — NUMBER, no nulo, llave foránea hacia ESTADIO.id_estadio (restricción fk_partido_estadio, comportamiento RESTRICT). Estadio en el que se disputa el partido.
fase — VARCHAR2(50), no nulo. Fase del torneo (Fase de Grupos, Octavos, Cuartos, Semifinal, Tercer Puesto, Final).
fecha_hora — DATE, no nulo. Restricción uq_partido_estadio_fechahora: única en conjunto con id_estadio. Fecha y hora en que se disputa el partido.

PARTICIPACION_PARTIDO

id_participacion — NUMBER, no nulo, llave primaria. Identificador de la participación.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (restricción fk_participaciones_partido, comportamiento CASCADE; también única en conjunto con id_seleccion y en conjunto con condicion). Partido en el que participa la selección.
id_seleccion — NUMBER, no nulo, llave foránea hacia SELECCION.id_seleccion (restricción fk_partidos_seleccion, comportamiento RESTRICT). Selección que participa en el partido.
condicion — VARCHAR2(20), no nulo. Restricción chk_participacion_condicion: valores permitidos local o visitante. Condición de la selección en dicho partido.
goles_marcados — NUMBER, no nulo. Restricción chk_participacion_goles: mayor o igual a 0. Goles marcados por la selección en dicho partido.

ASISTENCIA_PARTIDO

id_partido — NUMBER, no nulo, llave primaria, sin llave foránea declarada. Referencia lógica a MORENOLUIS.FIFA_PARTIDO.id_partido. Partido del esquema de referencia del curso al que corresponde la asistencia registrada.
asistencia_real — NUMBER, no nulo. Restricción chk_asistencia_no_negativa: mayor o igual a 0. Asistencia estimada (propia, ficticia) registrada para dicho partido, empleada para el cálculo del porcentaje de ocupación.

Nota: la tabla ASISTENCIA_PARTIDO no incorpora una restricción de llave foránea formal, dado que Oracle no permite declarar una llave foránea contra una tabla perteneciente a un esquema distinto (MORENOLUIS) que el equipo no administra. La relación es, en consecuencia, de carácter lógico, mediante la convención de que id_partido coincide con MORENOLUIS.FIFA_PARTIDO.id_partido.