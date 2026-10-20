# Normalización del Modelo Ampliado 

## 1. Introducción
Este documento tiene la finalidad de justificar que las 20 tablas del modelo ampliado definidas en 'modelo_logico.md', cumplan con la Primer, Segunda y Tercera forma normal (1FN, 2FN y 3FN). Primero se aclara que aclara que exige cada forma normal, luego cómo se aplicó y luego se revisa si se cumple tabla por tabla.

## 2. Formas normales

### 2.1 Primer Forma Normal
Una tabla se encuentra en la Primer Forma Normal si:
- No cuenta con **grupos repetitivos**
- Todos sus atrisbutos se consideran **atómicos**: es decir, que cada celda guarde solo un único valor, no valores compuestos.
- Cuenta con una **llave primaria** que identifica cada fila de manera única.

### 2.2 Segunda Forma Normal
Para saber si una tabla esta en 2FN, primero hay que revisar que efectivamente ya este en 1FN y todos los atributos de la tabla que no son llave dependan de la **llave completa** de la tabla, no solo de una parte de ella (en caso de ser llave compuesta).

### 2.3 Tercera Forma Normal
Para saber si una tabla está en 3FN cuando estpa se encuentra en 2FN y no tiene ninguna **dependencias transitivas**, es decir, que ningún atributo que no sea llave dependa de otro atributo que tampoco sea llave. 

## 3. Como se aplicó al modelo 

### 3.1 Primera Forma Normal - atributos atómicos
- **Jugadores de una selección:** en vez de guardar la lista de jugadores dentro de SELECCION, cada jugador convocado se convertirá en una fila en CONVOCATORIA_JUGADOR
- **Países sede de la edición:** en el modelo inicial, 'pais_sede' de EDICION_MUNDIAL guardaba un solo texto, pero como en el caso de la edición 2026 hay tres páises sede (México, Canadá y Estado Unidos). Esto provocaría que al guardarlos en un solo campo rompa directamente la 1FN. Como solución se eliminó 'pais_sede' y cada país quedará registrado a través de sus ciudades en CIUDAD_SEDE.
- **Boletería:** las entradas vendidas de cada categoría se registran como filas independientes en ENTRADA, y no como columnas separadas dentro de una misma fila, generando un grupo repetitivo.
- **Árbitros de un partido:** cada árbitro asignado a un partido se registra como una fila independiente en ASIGNACION_ARBITRAL, y no como columnas separadas dentro de PARTIDO, generando el mismo caso que en Boletería.

### 3.2 Segunda Forma Normal - llaves simples
- Absolutamente todas las tablas de este modelo utilizan llaves simples, por lo que no existen dependencias parciales a la llave primaria.
- Sin embargo, hay varias tablas que también cuentan con llaves candidatas compuestas, que están protegidas por las restricción UNIQUE. En ellas se verificó que cada atributo dependa de las combinación completa y no solo de ella parcialmente.

### 3.3 Tercera Forma Normal - Eliminación de dependencias transitivas 
- **Partido ya no guarda 'id_edicion':** la edición se pasa a obtener a través de la fase ('id_fase' --> FASE --> 'id_edicion').
- **ESTADIO ya no guarda 'id_edicion':** la edición se pasará a obtener a través de la ciudad ('id_ciudad' --> CIUDAD_SEDE --> 'id_edicion').
- **La confederación se vuelve una tabla propia:** antes era solo texto libre en la tabla SELECCION, generando el riesgo ya varias veces explicado de valores inconsistentes ("UEFA", "Uefa"). Ahora está la tabla CONFEDERACION, que es referenciada desde ARBITRO Y FEDERACION.
- **SELECCION ya no guarda ni 'confederacion' ni 'pais':** ambas dependen de federación ('id_federacion --> 'id_confederacion' y 'id_federacion' --> 'pais'), así que queda guardado una sola vez en FEDERACION. 
- **CONVOCATORIA_JUGADOR no guarda 'id_edicion':** la edición se obtiene a través de la selección ('id_seleccion' --> SELECCION --> 'id_seleccion').
- **ESTADISTICA_JUGADOR_PARTIDO apunta a CONVOCATORIA_JUGADOR y ya no a JUGADOR:** así el dorsal y la selección con la que jugó un jugador se obtienen directamente de la propia convocatoria, sin repetirlos constantemente en la fila de estadísticas.
- **la fase es una tabla propia:** antes era únicamente texto libre en la tabla PARTIDO. Ahora pasa a ser la tabla FASE, con su nombre, orden y número de clasificados guardados solo una única vez.

## 4. Revisión por cada tabla 

### 4.1 Organización del torneo
- **CONFEDERACION** (**id_confederacion**, sigla, nombre): 'nombre' y 'sigla' dependen únicamente de 'id_confederacion'. 'sigla es llave candidata (UNIQUE). Cumplen las tres fromas normales
- **EDICION_MUNDIAL** (**id_edicion**, anio, nombre_oficial, lema, fecha_inicio, fecha_fin, cupo_convocatoria, num_selecciones): todos los atributos describen a la edición y dependen solo de ella. 'anio' es una llave candidata. Cumplen las 3 formas normales.
- **FEDERACION** (**id_federacion**, id_confederacion, pais, codigo_fifa): todos los atributos dependen exclusivamente 'de id_federacion'. 'pais' y 'codigo_fifa' son llaves candidatas. La confederación queda referenciada por por la FK. Cumplen las tres formas normales.
- **ESTADIO** (**id_estadio**, id_ciudad, nombre, capacidad): 'capacidad' y 'nombre' dependen solo del 'id_estadio'. ('id_ciudad', 'nombre') es una llave candidata y capacidad depende de la combinación completa, no solo de la ciudad. Ya no guarda 'id_edicion'. cumple las tres formas normales.
- **CIUDAD_SEDE** (id_ciudad, id_edicion, nombre, pais): todos los atributos dependen de id_ciudad. (id_edicion, nombre, pais) es llave candidata. Cumple 1FN, 2FN y 3FN.

### 4.2 Competencia deportiva

- **FASE** (**id_fase**, id_edicion, nombre, orden, num_clasificados): todos los atributos describen la fase. (id_edicion, nombre) y (id_edicion, orden) son llaves candidatas. Cumple 1FN, 2FN y 3FN.
- **GRUPO** (**id_grupo**, id_fase, nombre): nombre depende del grupo; (id_fase, nombre) es llave candidata. Cumple 1FN, 2FN y 3FN.
- **PARTIDO** (**id_partido**, id_fase, id_estadio, id_grupo, codigo_llave, fecha_hora, estado, asistencia, definido_por_penales, tiempo_extra): todos los atributos describen el partido. (id_estadio, fecha_hora) es llave candidata. Cumple 1FN y 2FN; para 3FN ver el caso especial 5.1.
- **PARTICIPACION_PARTIDO** (**id_participacion**, id_partido, id_seleccion, condicion, goles_marcados, goles_penales, resultado): las llaves candidatas son (id_partido, id_seleccion) y (id_partido, condicion). goles_marcados, goles_penales y resultado dependen de la combinación completa "esta selección en este partido", no del partido solo ni de la selección sola. Cumple 1FN, 2FN y 3FN (ver también 5.2).

### 4.3 Selecciones, jugadores y cuerpo técnico

- **SELECCION** (**id_seleccion**, id_edicion, id_federacion, id_grupo, ranking_fifa): id_grupo y ranking_fifa dependen de la participación completa "esta federación en esta edición". (id_edicion, id_federacion) es llave candidata. Cumple 1FN, 2FN y 3FN (ver 5.1).
- **JUGADOR** (**id_jugador**, nombres, apellidos, fecha_nacimiento, posicion): solo guarda datos personales del jugador, que no cambian entre ediciones. No guarda la selección, que depende de cada edición. Cumple 1FN, 2FN y 3FN.
- **CONVOCATORIA_JUGADOR** (**id_convocatoria**, id_seleccion, id_jugador, dorsal, es_capitan): llaves candidatas (id_seleccion, id_jugador) y (id_seleccion, dorsal). dorsal y es_capitan dependen de la combinación "este jugador en esta selección", ya que un mismo jugador puede tener otro dorsal en otro Mundial. Cumple 1FN, 2FN y 3FN.
- **CUERPO_TECNICO** (id_miembro, id_seleccion, nombres, apellidos, nacionalidad, rol): todos los atributos describen al miembro. Se guarda nacionalidad porque no depende de la selección (un entrenador puede ser de otro país). Cumple 1FN, 2FN y 3FN.

### 4.4 Arbitraje

- **ARBITRO** (**id_arbitro**, id_confederacion, nombres, apellidos, nacionalidad, fecha_nacimiento): todos los atributos describen al árbitro. Cumple 1FN, 2FN y 3FN.
- **ASIGNACION_ARBITRAL** (**id_asignacion**, id_partido, id_arbitro, rol): llaves candidatas (id_partido, id_arbitro) y (id_partido, rol). rol depende de la combinación "este árbitro en este partido". Cumple 1FN, 2FN y 3FN.

### 4.5 Estadísticas de juego

- **ESTADISTICA_JUGADOR_PARTIDO** (**id_estadistica**, id_partido, id_convocatoria, minuto_entrada, minuto_salida, goles, asistencias, tarjetas_amarillas, tarjeta_roja): llave candidata (id_partido, id_convocatoria). Todas las estadísticas dependen de la combinación completa "este jugador en este partido". Cumple 1FN, 2FN y 3FN.

### 4.6 Logística, público, medios e incidencias

- **ENTRADA** (**id_entrada**, id_partido, categoria, precio, cantidad_vendida): llave candidata (id_partido, categoria). precio y cantidad_vendida dependen de la combinación completa, ya que una misma categoría puede tener precios distintos según el partido. Cumple 1FN, 2FN y 3FN.
- **ACREDITACION_PRENSA** (**id_acreditacion**, id_edicion, codigo_acreditacion, nombre_periodista, medio, tipo_medio, pais_medio): todos los atributos describen la credencial. codigo_acreditacion es llave candidata. Cumple 1FN, 2FN y 3FN.
- **INCIDENCIA** (**id_incidencia**, id_partido, tipo, minuto, gravedad, descripcion): todos los atributos describen la incidencia. Cumple 1FN, 2FN y 3FN.
- **AUDITORIA_EVENTO** (**id_auditoria**, tabla_afectada, operacion, id_registro, usuario, fecha_hora, valor_anterior, valor_nuevo): todos los atributos describen el evento registrado. Cumple 1FN, 2FN y 3FN.

## 5. Casos especiales y decisiones de diseño

### 5.1 Grupo y fase en PARTIDO y SELECCION

Un grupo pertenece siempre a la fase de grupos (id_grupo → id_fase). En PARTIDO se guardan tanto id_grupo como id_fase, por lo que, en los partidos de fase de grupos, existe la dependencia id_partido → id_grupo → id_fase.

Se decidió mantener id_fase en PARTIDO porque:
- Los partidos de fase eliminatoria no tienen grupo (id_grupo es nulo) y aun así necesitan su fase; sin id_fase no se podría saber en qué fase se jugaron.
- Es la columna por la que se filtran los partidos de cada fase y por la que se obtiene la edición del partido.

Para evitar inconsistencias (por ejemplo, un partido con un grupo de la fase de grupos pero registrado en octavos), esta regla se valida con un trigger de consistencia en la Entrega 3, y la restricción chk_partido_grupo_llave ya impide que un partido tenga al mismo tiempo grupo y código de llave.

En SELECCION, id_grupo también permite llegar a la edición, que ya se guarda en id_edicion. En este caso no se rompe la 3FN, porque id_edicion forma parte de la llave candidata (id_edicion, id_federacion). Que el grupo pertenezca a la misma edición de la selección también se valida con un trigger en la Entrega 3.

### 5.2 Datos que se pueden calcular a partir de otros

- **resultado en PARTICIPACION_PARTIDO** se puede calcular comparando así los goles entre las dos selecciones.
- **goles_marcados en PARTICIPACION_PARTIDO** se puede calcular sumando los goles de todos los jugadores que marcaron en ese partido en ESTADISTICA_JUGADOR_PARTIDO.

## 6. Conclusión
Se han creado las tablas FASE, GRUPO, CIUDAD_SEDE, CONFEDERACIÓN y FEDERACIÓN para eliminar las dependencias transitivas del modelo original. Todas las 20 tablas del modelo ampliado tienen la Tercera Forma Normal: no hay dependencias parciales (todas las llaves primarias son simples y en las que contienen llaves candidatas compuestas los atributos dependen de la combinación completa) y todos los atributos son atómicos. En la Entrega 3, se asegurarán la solidez de los casos especiales de la sección 5 mediante triggers. Estos son decisiones de diseño que están justificadas.