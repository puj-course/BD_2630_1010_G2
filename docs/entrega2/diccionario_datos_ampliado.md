//Diccionario de datos entrega 

El presente diccionario de datos, nos describe de manera completa la estructura de las 20 tablas del modelo ampliado de la entrega 2, teniendo en cuenta el modelo logico, el modelo_fisico y los ddl del modelo ampliado.
Los valores permitidos por las restricciones CHECK se escriben siempre en MAYÚSCULAS.

- CONFEDERACION
id_confederacion — NUMBER, no nulo, llave primaria (pk_confederacion). Es el Identificador de la confederación.
sigla — VARCHAR2(10), no nulo. Restricción uq_confederacion_sigla (única). Restricción chk_confederacion_sigla: valores permitidos AFC, CAF, CONCACAF, CONMEBOL, OFC, UEFA. Sigla oficial de la confederación.
nombre — VARCHAR2(150), no nulo. Nombre completo de la confederación.

- FEDERACION
id_federacion — NUMBER, no nulo, llave primaria (pk_federacion). Identificador de la federación.
id_confederacion — NUMBER, no nulo, llave foránea hacia CONFEDERACION.id_confederacion (fk_federacion_confederacion, comportamiento RESTRICT). Confederación a la que pertenece.
pais — VARCHAR2(100), no nulo. Restricción uq_federacion_pais (único). País de la federación.
codigo_fifa — CHAR(3), no nulo. Restricción uq_federacion_codigo (único). Restricción chk_federacion_codigo: debe estar en mayúsculas. Código FIFA del país (COL, ARG, FRA).

- EDICION_MUNDIAL
id_edicion — NUMBER, no nulo, llave primaria (pk_edicion_mundial). Identificador de la edición.
anio — NUMBER(4), no nulo. Restricción uq_edicion_anio (único). Año en que se disputa la edición.
nombre_oficial — VARCHAR2(150), no nulo. Nombre oficial del torneo.
lema — VARCHAR2(200), no nulo. Lema oficial de la edición.
fecha_inicio — DATE, no nulo. Restricción chk_edicion_fechas (fecha_fin mayor que fecha_inicio). Fecha de inicio del torneo.
fecha_fin — DATE, no nulo. Restricción chk_edicion_fechas. Fecha de cierre del torneo.
cupo_convocatoria — NUMBER(2), no nulo. Restricción chk_edicion_cupo (mayor que 0). Número máximo de jugadores por convocatoria.
num_selecciones — NUMBER(3), no nulo. Restricción chk_edicion_num_selecciones (mayor que 0). Cantidad de selecciones participantes.

- CIUDAD_SEDE
id_ciudad — NUMBER, no nulo, llave primaria (pk_ciudad_sede). Identificador de la ciudad.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (fk_ciudad_sede_edicion, comportamiento RESTRICT). Restricción uq_ciudad_sede_edicion_nombre_pais: única en conjunto con nombre y pais. Edición en la que es sede.
nombre — VARCHAR2(100), no nulo. Nombre de la ciudad sede.
pais — VARCHAR2(100), no nulo. País anfitrión al que pertenece la ciudad.

- ESTADIO
id_estadio — NUMBER, no nulo, llave primaria (pk_estadio). Identificador del estadio.
id_ciudad — NUMBER, no nulo, llave foránea hacia CIUDAD_SEDE.id_ciudad (fk_estadio_ciudad, comportamiento RESTRICT). Restricción uq_estadio_ciudad_nombre: única en conjunto con nombre. Ciudad en la que se ubica.
nombre — VARCHAR2(150), no nulo. Nombre del estadio.    
capacidad — NUMBER, no nulo. Restricción chk_estadio_capacidad (mayor que 0 y menor o igual a 150000). Aforo máximo del estadio.

- FASE
id_fase — NUMBER, no nulo, llave primaria (pk_fase). Identificador de la fase.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (fk_fase_edicion, comportamiento RESTRICT). Edición a la que pertenece.
nombre — VARCHAR2(50), no nulo. Restricción uq_fase_edicion_nombre: único en conjunto con id_edicion. Restricción chk_fase_nombre: valores permitidos GRUPOS, DIECISEISAVOS, OCTAVOS, CUARTOS, SEMIFINAL, TERCER_PUESTO, FINAL. Nombre de la fase.
orden — NUMBER(2), no nulo. Restricción uq_fase_edicion_orden: único en conjunto con id_edicion. Restricción chk_fase_orden (entre 1 y 7). Posición de la fase dentro del torneo.
num_clasificados — NUMBER(3), admite nulo. Restricción chk_fase_clasificados (mayor o igual a 0). Selecciones que avanzan a la siguiente fase.

- GRUPO
id_grupo — NUMBER, no nulo, llave primaria (pk_grupo). Identificador del grupo.
id_fase — NUMBER, no nulo, llave foránea hacia FASE.id_fase (fk_grupo_fase, comportamiento RESTRICT). Fase de grupos a la que pertenece.
nombre — CHAR(1), no nulo. Restricción uq_grupo_fase_nombre: único en conjunto con id_fase. Restricción chk_grupo_nombre (letra entre A y L). Letra del grupo.

- SELECCION
id_seleccion — NUMBER, no nulo, llave primaria (pk_seleccion). Identificador de la selección.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (fk_seleccion_edicion, comportamiento RESTRICT). Restricción uq_seleccion_edicion_federacion: única en conjunto con id_federacion. Edición en la que participa.
id_federacion — NUMBER, no nulo, llave foránea hacia FEDERACION.id_federacion (fk_seleccion_federacion, comportamiento RESTRICT). Federación que representa.
id_grupo — NUMBER, admite nulo, llave foránea hacia GRUPO.id_grupo (fk_seleccion_grupo, comportamiento RESTRICT). Grupo asignado a la selección.
ranking_fifa — NUMBER(3), admite nulo. Restricción chk_seleccion_ranking (mayor que 0). Ranking FIFA al inicio del torneo.

- PARTIDO
id_partido — NUMBER, no nulo, llave primaria (pk_partido). Identificador del partido.
id_fase — NUMBER, no nulo, llave foránea hacia FASE.id_fase (fk_partido_fase, comportamiento RESTRICT). Fase en la que se disputa.
id_estadio — NUMBER, no nulo, llave foránea hacia ESTADIO.id_estadio (fk_partido_estadio, comportamiento RESTRICT). Estadio en el que se disputa.
id_grupo — NUMBER, admite nulo, llave foránea hacia GRUPO.id_grupo (fk_partido_grupo, comportamiento RESTRICT). Grupo del partido; solo se llena en fase de grupos.
codigo_llave — VARCHAR2(10), admite nulo. Restricción chk_partido_grupo_llave: no puede tener valor si id_grupo tiene valor. Código del cruce; solo se llena en fase eliminatoria.
fecha_hora — DATE, no nulo. Restricción uq_partido_estadio_fechahora: única en conjunto con id_estadio. Fecha y hora del partido.
estado — VARCHAR2(20), no nulo, valor por defecto PROGRAMADO. Restricción chk_partido_estado: valores permitidos PROGRAMADO, EN_JUEGO, FINALIZADO, SUSPENDIDO. Estado actual del partido.
asistencia — NUMBER, admite nulo. Restricción chk_partido_asistencia (mayor o igual a 0). Público asistente al partido.
definido_por_penales — CHAR(1), no nulo, valor por defecto N. Restricción chk_partido_penales: valores permitidos S o N. Indica si el partido se definió por penales.
tiempo_extra — CHAR(1), no nulo, valor por defecto N. Restricción chk_partido_tiempo_extra: valores permitidos S o N. Indica si hubo tiempo extra.

- PARTICIPACION_PARTIDO
id_participacion — NUMBER, no nulo, llave primaria (pk_participacion_partido). Identificador de la participación.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (fk_participacion_partido, comportamiento CASCADE). Restricciones uq_participacion_partido_seleccion (única en conjunto con id_seleccion) y uq_participacion_partido_condicion (única en conjunto con condicion). Partido en el que participa la selección.
id_seleccion — NUMBER, no nulo, llave foránea hacia SELECCION.id_seleccion (fk_participacion_seleccion, comportamiento RESTRICT). Selección que participa.
condicion — VARCHAR2(10), no nulo. Restricción chk_participacion_condicion: valores permitidos LOCAL o VISITANTE. Condición de la selección en el partido.
goles_marcados — NUMBER(2), no nulo, valor por defecto 0. Restricción chk_participacion_goles (mayor o igual a 0). Goles marcados en el partido.
goles_penales — NUMBER(2), admite nulo. Restricción chk_participacion_penales (mayor o igual a 0). Goles marcados en la tanda de penales.
resultado — CHAR(1), admite nulo. Restricción chk_participacion_resultado: valores permitidos G, E o P. Resultado de la selección (ganó, empató o perdió).

- JUGADOR
id_jugador — NUMBER, no nulo, llave primaria (pk_jugador). Identificador del jugador.
nombres — VARCHAR2(100), no nulo. Nombres del jugador.
apellidos — VARCHAR2(100), no nulo. Apellidos del jugador.
fecha_nacimiento — DATE, no nulo. Fecha de nacimiento.
posicion — VARCHAR2(15), no nulo. Restricción chk_jugador_posicion: valores permitidos PORTERO, DEFENSA, MEDIOCAMPISTA, DELANTERO. Posición de juego.

- CONVOCATORIA_JUGADOR
id_convocatoria — NUMBER, no nulo, llave primaria (pk_convocatoria_jugador). Identificador de la convocatoria.
id_seleccion — NUMBER, no nulo, llave foránea hacia SELECCION.id_seleccion (fk_convocatoria_seleccion, comportamiento CASCADE). Restricción uq_convocatoria_seleccion_jugador: única en conjunto con id_jugador. Selección que convoca.
id_jugador — NUMBER, no nulo, llave foránea hacia JUGADOR.id_jugador (fk_convocatoria_jugador, comportamiento RESTRICT). Jugador convocado.
dorsal — NUMBER(2), no nulo. Restricción uq_convocatoria_seleccion_dorsal: único en conjunto con id_seleccion. Restricción chk_convocatoria_dorsal (entre 1 y 26). Número de camiseta.
es_capitan — CHAR(1), no nulo, valor por defecto N. Restricción chk_convocatoria_capitan: valores permitidos S o N. Indica si el jugador es el capitán.

- CUERPO_TECNICO
id_miembro — NUMBER, no nulo, llave primaria (pk_cuerpo_tecnico). Identificador del miembro.
id_seleccion — NUMBER, no nulo, llave foránea hacia SELECCION.id_seleccion (fk_cuerpotecnico_seleccion, comportamiento CASCADE). Selección a la que pertenece.
nombres — VARCHAR2(100), no nulo. Nombres del miembro.
apellidos — VARCHAR2(100), no nulo. Apellidos del miembro.
nacionalidad — VARCHAR2(100), no nulo. Nacionalidad del miembro.
rol — VARCHAR2(30), no nulo. Restricción chk_cuerpotecnico_rol: valores permitidos ENTRENADOR_PRINCIPAL, ASISTENTE_TECNICO, PREPARADOR_FISICO, ENTRENADOR_PORTEROS, MEDICO. Función dentro del cuerpo técnico.

- ARBITRO
id_arbitro — NUMBER, no nulo, llave primaria (pk_arbitro). Identificador del árbitro.
id_confederacion — NUMBER, no nulo, llave foránea hacia CONFEDERACION.id_confederacion (fk_arbitro_confederacion, comportamiento RESTRICT). Confederación a la que pertenece el árbitro.
nombres — VARCHAR2(100), no nulo. Nombres del árbitro.
apellidos — VARCHAR2(100), no nulo. Apellidos del árbitro.
nacionalidad — VARCHAR2(100), no nulo. Nacionalidad del árbitro.
fecha_nacimiento — DATE, no nulo. Fecha de nacimiento.

- ASIGNACION_ARBITRAL
id_asignacion — NUMBER, no nulo, llave primaria (pk_asignacion_arbitral). Identificador de la asignación.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (fk_asignacion_partido, comportamiento CASCADE). Restricciones uq_asignacion_partido_arbitro (única en conjunto con id_arbitro) y uq_asignacion_partido_rol (única en conjunto con rol). Partido asignado.
id_arbitro — NUMBER, no nulo, llave foránea hacia ARBITRO.id_arbitro (fk_asignacion_arbitro, comportamiento RESTRICT). Árbitro asignado.
rol — VARCHAR2(20), no nulo. Restricción chk_asignacion_rol: valores permitidos PRINCIPAL, ASISTENTE_1, ASISTENTE_2, CUARTO_ARBITRO, VAR, AVAR. Rol del árbitro en el partido.

- ESTADISTICA_JUGADOR_PARTIDO
id_estadistica — NUMBER, no nulo, llave primaria (pk_estadistica_jugador_partido). Identificador de la estadística.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (fk_estadistica_partido, comportamiento CASCADE). Restricción uq_estadistica_partido_convocatoria: única en conjunto con id_convocatoria. Partido.
id_convocatoria — NUMBER, no nulo, llave foránea hacia CONVOCATORIA_JUGADOR.id_convocatoria (fk_estadistica_convocatoria, comportamiento RESTRICT). Jugador convocado, con su selección y dorsal.
minuto_entrada — NUMBER(3), no nulo. Restricción chk_estadistica_minuto_entrada (mayor o igual a 0). Minuto en que entró al partido; 0 si fue titular.
minuto_salida — NUMBER(3), admite nulo. Restricción chk_estadistica_minuto_salida (mayor o igual a minuto_entrada). Minuto en que salió; nulo si jugó hasta el final.
goles — NUMBER(2), no nulo, valor por defecto 0. Restricción chk_estadistica_goles (mayor o igual a 0). Goles marcados.
asistencias — NUMBER(2), no nulo, valor por defecto 0. Restricción chk_estadistica_asistencias (mayor o igual a 0). Asistencias de gol.
tarjetas_amarillas — NUMBER(1), no nulo, valor por defecto 0. Restricción chk_estadistica_amarillas (entre 0 y 2). Tarjetas amarillas recibidas.
tarjeta_roja — CHAR(1), no nulo, valor por defecto N. Restricción chk_estadistica_roja: valores permitidos S o N. Indica si fue expulsado.

- ENTRADA
id_entrada — NUMBER, no nulo, llave primaria (pk_entrada). Identificador del registro de boletería.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (fk_entrada_partido, comportamiento CASCADE). Restricción uq_entrada_partido_categoria: única en conjunto con categoria. Partido.
categoria — VARCHAR2(20), no nulo. Restricción chk_entrada_categoria: valores permitidos CATEGORIA_1, CATEGORIA_2, CATEGORIA_3, HOSPITALIDAD. Categoría de la entrada.
precio — NUMBER(10,2), no nulo. Restricción chk_entrada_precio (mayor o igual a 0). Precio unitario de la entrada.
cantidad_vendida — NUMBER, no nulo. Restricción chk_entrada_cantidad (mayor o igual a 0). Entradas vendidas de esa categoría.

- ACREDITACION_PRENSA
id_acreditacion — NUMBER, no nulo, llave primaria (pk_acreditacion_prensa). Identificador de la acreditación.
id_edicion — NUMBER, no nulo, llave foránea hacia EDICION_MUNDIAL.id_edicion (fk_acreditacion_edicion, comportamiento RESTRICT). Edición para la que se acredita.
codigo_acreditacion — VARCHAR2(20), no nulo. Restricción uq_acreditacion_codigo (único). Número de la credencial.
nombre_periodista — VARCHAR2(150), no nulo. Nombre completo del periodista.
medio — VARCHAR2(100), no nulo. Medio para el que trabaja.
tipo_medio — VARCHAR2(20), no nulo. Restricción chk_acreditacion_tipo: valores permitidos PRENSA_ESCRITA, RADIO, TELEVISION, DIGITAL. Tipo de medio.
pais_medio — VARCHAR2(100), no nulo. País del medio.

- INCIDENCIA
id_incidencia — NUMBER, no nulo, llave primaria (pk_incidencia). Identificador de la incidencia.
id_partido — NUMBER, no nulo, llave foránea hacia PARTIDO.id_partido (fk_incidencia_partido, comportamiento CASCADE). Partido en el que ocurrió.
tipo — VARCHAR2(30), no nulo. Restricción chk_incidencia_tipo: valores permitidos LESION, INTERRUPCION, SEGURIDAD, FALLA_TECNICA, CLIMATICA, OTRA. Tipo de incidencia.
minuto — NUMBER(3), no nulo. Restricción chk_incidencia_minuto (mayor o igual a 0). Minuto en que ocurrió.
gravedad — VARCHAR2(10), no nulo. Restricción chk_incidencia_gravedad: valores permitidos BAJA, MEDIA, ALTA. Gravedad de la incidencia.
descripcion — VARCHAR2(500), no nulo. Detalle de lo ocurrido.

- AUDITORIA_EVENTO
id_auditoria — NUMBER, no nulo, llave primaria (pk_auditoria_evento). Identificador del registro de auditoría.
tabla_afectada — VARCHAR2(50), no nulo. Tabla sobre la que se hizo el cambio.
operacion — VARCHAR2(10), no nulo. Restricción chk_auditoria_operacion: valores permitidos INSERT, UPDATE, DELETE. Tipo de operación realizada.
id_registro — NUMBER, no nulo. Llave primaria de la fila modificada.
usuario — VARCHAR2(50), no nulo, valor por defecto USER. Usuario de base de datos que realizó el cambio.
fecha_hora — DATE, no nulo, valor por defecto SYSDATE. Momento en que se realizó el cambio.
valor_anterior — VARCHAR2(4000), admite nulo. Datos antes del cambio.
valor_nuevo — VARCHAR2(4000), admite nulo. Datos después del cambio.

