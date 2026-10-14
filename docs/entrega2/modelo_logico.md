# Modelo Lógico Ampliado - Entrega 2

## 1. Introducción 
Este documento nos presenta el modelo lógico ampliado del sistema de información para la gestión de la Copa del Mundo de la FIFA, correspondiendo con la entrega 2 del proyecto.

El modelo parte del Módelo Genérico Inicial de cinco tablas (ESTADIO, SELECCION, PARTIDO, PARTICIPACION_PARTIDO y EDICION_MUNDIAL) desarrollado durante la entrega 1, e incorpora todos los ajustes propuestos en la Evaluación Crítica del Modelo Inicial (`docs/entrega1/evaluacion_critica_modelo_inicial.md`), como por ejemplo la conversión de atributos de texto libre en entidades propias.

Este modelo ampliado da soporte a las reglas de negocio de la sección 7:

- Competencia deportiva 
- Arbitraje
- Estadísticas de juego 
- Logística, público, medios e incidencias
- Organización del MUNDIAL
- Selecciones, cuerpo técnico y jugadores.

En total este modelo contará con 20 tablas normalizadas hasta tercera forma normal (3FN), con llaves primarias y fóraneas definidas y se implementará sobre el mismo motor utilizado en la misma Entrega 1.

El diagrama del modelo queda ubicado en `modelo_logico.png` y el detalle de cada uno de los atributos en `diccionario_datos_ampliado.md`.

## 2. Lista de tablas

El modelo ampliado cuenta con 20 tablas, organizadas según los
frentes funcionales de la Sección 7 del enunciado. Las marcadas con
(*) provienen del modelo inicial de la Entrega 1 y fueron ajustadas.

### 2.1 Organización del torneo (Sección 7.1)

1. **EDICION_MUNDIAL** (*): cada versión del Mundial.
2. **CIUDAD**: ciudades sede de una edición, con su país anfitrión.
3. **ESTADIO** (*): estadios ubicados en cada ciudad sede.

### 2.2 Competencia deportiva (Sección 7.2)

4. **FASE**: etapas del torneo (grupos, octavos, cuartos, etc.)
   con su orden.
5. **GRUPO**: grupos de la fase de grupos (A, B, C...).
6. **PARTIDO** (*): cada encuentro, con su fase, estadio, fecha y
   asistencia.
7. **PARTICIPACION_PARTIDO** (*): las dos selecciones de cada
   partido, con su condición y marcador.

### 2.3 Selecciones, jugadores y cuerpo técnico (Sección 7.3)

8. **CONFEDERACION**: las seis confederaciones de la FIFA.
9. **FEDERACION**: federaciones nacionales, asociadas a una
   confederación.
10. **SELECCION** (*): participación de una federación en una
    edición, con su grupo.
11. **JUGADOR**: jugadores (datos ficticios).
12. **CONVOCATORIA_JUGADOR**: nómina oficial de cada selección por
    edición, con dorsal y capitán.
13. **CUERPO_TECNICO**: entrenador, asistentes y demás miembros de
    cada selección.

### 2.4 Arbitraje (Sección 7.4)

14. **ARBITRO**: árbitros designados (datos ficticios).
15. **ASIGNACION_ARBITRAL**: árbitros asignados a cada partido y su
    rol.

### 2.5 Estadísticas de juego (Sección 7.5)

16. **ESTADISTICA_JUGADOR_PARTIDO**: desempeño de cada jugador en
    cada partido (goles, asistencias, tarjetas, minutos de entrada y
    salida).

### 2.6 Logística, público, medios e incidencias (Sección 7.6)

17. **ENTRADA**: boletería vendida por partido.
18. **ACREDITACION_PRENSA**: periodistas acreditados en cada edición.
19. **INCIDENCIA**: eventos irregulares ocurridos en un partido.
20. **AUDITORIA_EVENTO**: registro de cambios sobre información
    crítica (quién, cuándo y qué).

## 3. Cambios frente al modelo inicial 

### 3.1 Cambios en las tablas del modelo inicial

**EDICION MUNDIAL**
- Se elimina completamente el atributo `pais_sede`. Una edición puede tener varios países sede como es el caso de la edición 2026 (Canadá, México y Estados Unidos), lo cual no cabe en un único campo de texto (rompiendo la 1FN). Los países sede ahora quedarán registrados en la tabla CIUDAD.
- Se añaden `num_selecciones`, `nombre_oficial` y `cupo_convocatoria`. El último nos permite saber el número máximo de jugadores por convocatoria, ya que esto va cambiando por edición del mundial.

**ESTADIO**
- El atributo ciudad queda reemplazado por id `id_ciudad`, que es llave foránea hacia CIUDAD.
- Queda eliminado `id_edicion`: la edición del estadio se obtendrá a través de su ciudad. Guardarla en ambos lugares acabaría creando una dependencia transitiva (rompiendo la 3FN).

**PARTIDO**
- Queda eliminado `id_edicion`: la ediciónn se obtendrá a través de la fase para no romper la 3FN.
- El atributo `fase` (texto libre) quedará reemplazado por el atributo `id_fase`, que es una llave foránea hacia la tabla FASE.
- Se agregan distintos atributos como: `id_grupo` (exclusivamente para partidos de fase de grupos), `asistencia`, `estado`, `tiempo_extra`, `codigo_llave` (exclusivamente para partidos de eliminatoria) y `definido_por_penales`.

**SELECCION**
- Se añade `id_grupo`, que es una llave foránea hacia GRUPO, de esta manera se podrá calcular la tabla de posiciones por grupo.
- Queda eliminado `pais`: el país se obtiene a través de la federación 
- El atributo `confederacion` (texto libre) queda sustituido por `id_federacion`, que es una llave foránea hacia FEDERACION. La confederación se obtendrá a través de la federación para evitar futuros valores inconsistentes como podría ser "UEFA", "uefa" o "Europa"

**PARTICIPACION_PARTIDO**
- Se añaden `goles_penales` (en caso de que el partido se haya definido por penales) y `resultado` (G, E o P), siguiendo la regla 7.2 del enunciado

### 3.2 Tabla eliminada

**ASISTENCIA_PARTIDO**
- En la entrega 1 la existencia de esta tabla se debía porque el esquema del curso era solo lectura y no contaba con un campo de asistencia. Como ahora el esquema es propio, la asistencia pasará a ser un atributo de PARTIDO.

### 3.3 Ajustes frente a la Evaluación Crítica

- **GOL se reemplaza por ESTADISTICA_JUGADOR_PARTIDO.** En lugar de resgistrar solo los goles, esta tabla hace seguimiento de todo el desempeño del jugador en todo el partido (goles, minutos, tarjetas y asistencias), tal y como indica la regla 7.5.
- **SELECCION_GRUPO no se crea.** Cada file de SELECCION representa una seleeción de una edición del mundial en concreto, y en una edición cada selección pertenece a un único grupo. La relación es de 1 a N y se le da solución mediante la llave foránea `id_grupo` en SELECCION.
- **Se agregan nuevas entidades no previstas en la propia evaluación.** FEDERACION, CONVOCATORIA_JUGADOR, CUERPO_TECNICO,CIUDAD, ENTRADA, ARBITRO, ASIGNACION_ARBITRAL, INCIDENCIA Y ACREDITACION_PRENSA, para poder cumplir así con todas las reglas de negocio exigidas en la sección 7.

## 4. Esquema de cada tabla

Notación: la llave primaria se indica siempre en **negrita** y las llaves foráneas siempre con → seguidas de la tabla a la que es referenciada. Todas llave primaria son identificadores númericos, que nunca cambian con el tiempo. Las llaves naturales del negocio quedarán protegidos mediantes restricciones de tipo UNIQUE.

### 4.1 Tablas del Modelo Inicial   
**ESTADIO** (**id_estadio**, id_ciudad → CIUDAD, nombre, capacidad)
- Es único por (id_ciudad, nombre).
- Cada estadio pertenecerá a una ciudad sede.

**EDICION_MUNDIAL**(**id_edicion**, anio, nombre_oficial, lema, fecha_inicio, fecha_fin, cupo_convocatoria, num_selecciones)
- Es la raíz del modelo: casi todas las tablas del modelo dependen de una edición del torneo.
- `anio` siempre es único: debido a que no puede haber dos mundiales en un mismo año.

**PARTIDO** (**id_partido**, id_fase → FASE, id_estadio → ESTADIO, id_grupo → GRUPO, codigo_llave, fecha_hora, estado, asistencia, definido_por_penales, tiempo_extra)
- `id_grupo` solo se llena de manera exclusiva durante la fase de grupos y `codigo_llave` exclusivamente en fase eliiminatoria.
- es único por (id_estadio, fecha_hora): un estadio no puede albergar dos partidos en una misma hora.

**SELECCION** (**id_seleccion**,id_edicion → EDICION_MUNDIAL, id_federacion → FEDERACION, id_grupo → GRUPO, ranking_fifa)
- Representa a una federación que está participando en una edición concreta.
- Es única por (id_edicion, id_federacion): un país no se puede inscribir dos veces a una misma edición del mundial.

**PARTICIPACION_PARTIDO** (**id_participacion**, id_partido → PARTIDO, id_seleccion → SELECCION, condicion, goles_marcados, goles_penales, resultado)
- Tabla asociativa que se encarga de resolver la la relación N:M (muchos a muchos) entre SELECCION y PARTIDO.
- Es única por (id_partido, id_seleccion) y también por (id_partido, condicion): ya que solo puede haber como máximo un local y un visitante por partido. 

### 4.2 Organización del torneo 

**CIUDAD** (**id_ciudad**, id_edicion → EDICION_MUNDIAL, nombre, pais)
- Represemnta una ciudad sede dentro de una edición concreta del Mundial.
- `pais` se encarga de guardar el país anfitrión al que pertenece la ciudad; así una misma edición puede tener varios países sede (2026 con Canadá, Estados Unidos y México) sin romper la 1FN.
- Es única por (id_edicion, nombre, pais): una ciudad no puede registrarse dos veces como sede la misma edición.

### 4.3 Competencia deportiva

**FASE** (**id_fase**, id_edicion → EDICION_MUNDIAL, nombre, orden, num_clasificados)
- Representa cada etapa del Mundial en una misma edición: fase de grupos, dieciseisavos, octavos, cuartos, semifinal, tercer puesto y final.
- `orden` se encarga de indicar en que posición se juega la fase dentro del propio torneo y `num_clasificados` indica cuantas selecciones lograron pasar a la siguiente ronda.
- A traves de FASE se obtiene la edición de cada partido, por esto mismo, PARTIDO ya no se encarga de guardar `id_edicion`.
- Es única por (id_edicion, nombre) y también por (orden, id_edicion): no puede haber dos fases con el mismo nombre ni la misma posición en la que se juega.

**GRUPO** (**id_grupo**, id_fase → FASE, nombre)
- Representa los grupos (A, B, C...) de la fase de grupos de una edición.
- Es único por (id_fase, nombre): no puede haber dos "Grupo A" en la misma fase.
- `id_fase` debe apuntar siempre a la fase de grupos de su edición; esta regla se valida con un trigger de consistencia en la Entrega 3.

### 4.4 Selecciones, jugadores y cuerpo técnico

**CONFEDERACION** (**id_confederacion**, sigla, nombre)
- Cátalogo que contiene las seis confederaciones de la FIFA (AFC, CAF, CONMEBOL, UEFA, OFC Y CONCACAF).
- `sigla` es única: así se logra evitar valores inconsistentes como "UEFA", "Europa" o "Uefa"

**FEDERACION** (**id_federacion**, id_confederacion → CONFEDERACION, pais, codigo_fifa)
- Representa la federación de fútbol de un país, que existe independientemente a la edición del Mundial que se esta jugando.
- `pais` y `codigo_fifa` son únicos (por ejemplo ARG, ESP o COL).

**JUGADOR** (**id_jugador**, nombres, apellidos, fecha_nacimiento, posicion)
- Guarda los datos personales del jugador (en este modelo son ficticios), que no cambiarán con el paso de las ediciones.
- `posicion` queda restringido a portero, defensa, mediocampista o delantero.
- No se encarga de guardar la selección: un jugador puede jugar muchos Mundiales y su pertenencia a una selección queda registrada en CONVOCATORIA_JUGADOR.

**CONVOCATORIA_JUGADOR** (**id_convocatoria**, id_seleccion → SELECCION, id_jugador → JUGADOR, dorsal, es_capitan)
- Tabla asociativa que da solución la relación N:M entre JUGADOR y SELECCION: representa la nómina oficial de cada selección en una edición de un Mundial.
- `es_capitan` tomará los valores de S o N (Sí o no).
- Es única por (id_jugador, id_seleccion): un jugador no puede quedar convocado dos veces a la misma selección. También es única por el lado de (id_seleccion, dorsal) ya que dos jugadores de una misma selección no pueden llevar el mismo dorsal.
- Las reglas (no superar el `cupo_convocatoria` de la edición, un jugador que no este en dos selecciones en una misma edición, solo un capitán por equipo).

**CUERPO_TECNICO** (**id_miembro**, id_seleccion → SELECCION, nombres, apellidos, nacionalidad, rol)
- Se encarga de registrar el entrenador y demás miembros del cuerpo técnico de cada selección participante.
- `rol` queda restringido a los valores de: entrenador principal, preparador físico, asistente técnico, médico y por último entrenador de porteros.
- `nacionalidad` queda guardado porque hay varios casos en los que un entrenador no es de la misma nacionalidad de la selección a la que esta dirigiendo.

### 4.5 Arbitraje 

**ARBITRO** (**id_arbitro**, id_confederacion → CONFEDERACION, nombres, apellidos, nacionalidad, fecha_nacimiento)
- Guarda los datos (para este modelo serán ficticios) de los arbitros que hayan sido designados por la FIFA.
- `id_confederacion` indica la confederación a la que pertenece el árbitro, para asi poder verificar que el arbitro no pertenezca a la misma confederación de las selecciones que se enfrenten en el partido que arbitre.

**ASIGNACION_ARBITRAL** (**id_asignacion**, id_partido → PARTIDO, id_arbitro → ARBITRO, rol)
- Tabla asociativa encargada de dar solución a la relación N:M entre ARBITRO y PARTIDO.
- `rol` se restringe a: principal, asistente 1, asistente 2, cuarto árbitro, AVAR (Asistente del VAR) y VAR.
- Es única por (id_arbitro, id_partido) ya que un arbitro no puede cumplir dos roles diferentes en un mismo partido. También es única por la parte de (id_partido, rol) debido a que cada rol queda asignado a un solo árbitro por partido.

### 4.6 Estadísticas de juego

**ESTADISTICA_JUGADOR_PARTIDO** (**id_estadistica**, id_partido → PARTIDO, id_convocatoria → CONVOCATORIA_JUGADOR, minuto_entrada, minuto_salida, goles, asistencias, tarjetas_amarillas, tarjeta_roja)
- Registra el desempeño de un jugador en un partido en concreto.
- Referencia a CONVOCATORIA_JUGADOR y no dircectamente a JUGADOR: así se puede conocer con que dorsal y con que selección jugó, sin repetir datos.
- Es única por el lado de (id_partido, id_convocatoria): un jugador tiene una sola fila de estadísticas por partido jugado.
- Cuenta con restricciones CHECK: `goles`, `asistencias` y `tarjetas_amarillas` tiene que ser mayores o iguales a cero; `tarjetas_amarillas` como máximo dos por jugador en cada partido; `tarjeta_roja` toma valores de S o N (sí o no); `minuto_salida` mayor o igual a `minuto_entrada`.
- La suma de goles marcados por los jugadores en un partido coincida con `goles_marcados` de PARTICIPACION_PARTIDO, y que el jugador pertenezca a una de las selecciones de ese partido.

### 4.7 Logística, público, medios e incidencias

**ENTRADA** (**id_entrada**, id_partido → PARTIDO, categoria, precio, cantidad_vendida)
- Se encarga de registrar la boletería vendida por partido, agrupada por categorías (categoría 1, 2, 3 y hospitalidad).
- Es única por el lado de (id_partido, categoria): cada categoría solo aparece una vez por partido.
- `precio` y `cantidad_vendida` deben ser estrictamente mayores o iguales a 0. Que el total vendido no sobrepase la `capacidad` del estadio.

**ACREDITACION_PRENSA** (**id_acreditacion**, id_edicion → EDICION_MUNDIAL, codigo_acreditacion, nombre_periodista, medio, tipo_medio, pais_medio)
- Se encarga de registrar a los periodistas y medios acreditados para cubrir una edición.
- `codigo_acreditacion` es único: es el número de la credencial que se le es entregado a cada uno de los periodistas.
- `tipo_medio` se restringe a prensa escrita, radio, televisión y digital.

**INCIDENCIA** (**id_incidencia**, id_partido → PARTIDO, tipo, minuto, gravedad, descripcion)
- Registra los eventos irregulares ocurridos durante un partido: lesiones, interrupciones, problemas de seguridad, fallas técnicas, entre otros.
- `tipo` y `gravedad` (baja, media o alta) se restringen mediante CHECK; `minuto` debe ser mayor o igual a 0.

**AUDITORIA_EVENTO** (**id_auditoria**, tabla_afectada, operacion, id_registro, usuario, fecha_hora, valor_anterior, valor_nuevo)
- Guarda quién cambió qué información crítica y cuándo (por ejemplo, la corrección del marcador de un partido).
- `operacion` se restringe a INSERT, UPDATE y DELETE.
- No tiene llaves foráneas a propósito: debe registrar cambios de cualquier tabla y conservar el registro aunque la fila original se elimine.

## 5. Relaciones y cardinalidades

### 5.1 Organización torneo
- EDICION_MUNDIAL --> CIUDAD: Tipo 1:N, ya que un mundial tiene muchas ciudades que son sede.
- CIUDAD --> ESTADIO: Tipo 1:N, una ciudad puede tener varios estadios.
- ESTADIO --> PARTIDO: Tipo 1:N, en un estadio se juegan una gran cantidad de partidos.

### 5.2 Competencia deportiva 
- EDICION_MUNDIAL --> FASE: Tipo 1:N, cada edición del mundial tiene varias fases.
- FASE --> GRUPO: Tipo 1:N, en la fase de grupos hay distintos grupos con sus respectivas selecciones.
- GRUPO --> PARTIDO: Tipo 1:N, cada grupo cuenta con varios partidos diferentes.
- PARTIDO <--> SELECCION: Tipo N:M, en cada partido juegan 2 selecciones y además cada selección juega varios partidos. Tabla intermedia: PARTICIPACION_PARTIDO.
- FASE --> PARTIDO: Tipo 1:N, en cada fase del Mundial se juegan varios partidos.

### 5.3 Selecciones, jugadores y cuerpo técnico 
- CONFEDERACION --> FEDERACION: Tipo 1:N, una confederación contiene varias federaciones.
- EDICION_MUNDIAL --> SELECCION: Tipo 1:N, en un mundial hay muchas selecciones.
- FEDERACION --> SELECCION: Tipo 1:N, una federación tiene una selección por cada mundial en el que haya participado en su historia.
- SELECCION <--> JUGADOR: Tipo N:m, una selección cuenta con muchos jugadores convocados y un jugador puede ser convocado a una selección en varios mundiales. Tabla intermedia: CONVOCATORIA_JUGADOR.
- GRUPO --> SELECCION: Tipo 1:N, un grupo tiene muchas selecciones.
- SELECCION --> CUERPO_TECNICO: Tipo 1:N, cada selección tiene varios miembros del equipo técnico.

### 5.4 Arbitraje
- PARTIDO <--> ARBITRO: Tipo N:M, un partido cuenta con varios árbitros y un mismo árbitro puede pitar varios partidos. Tabla intermedia: ASIGNACION_ARBITRAL.
- CONFEDERACION --> ARBITRO: Tipo 1:N, una confederación cuenta con varios árbitros designados.

### 5.5 Estadísticas de juego
- PARTIDO <--> CONVOCATORIA_JUGADOR: Tipo N:M, en cada partido juegan muchos jugadores y un jugador también juega varios partidos. Tabla intermedia: ESTADISTICA_JUGADOR_PARTIDO.

### 5.6 Logística, público, medios e incidencias
- PARTIDO --> INCIDENCIA: Tipo 1:N, en un partido pueden ocurrir muchas incidencias.
- EDICION_MUNDIAL --> ACREDITACION_PRENSA: Tipo 1:N, en un mundial muchos periodistas son acreditados.
- PARTIDO --> ENTRADA: Tipo 1:N, un partido vende entradas de distintos tipos.

## 6. Reglas que no solo se resuelven con la estructura

1. Cada partido debe contar exactamente con dos participaciones: una como local y otra como visitante.
2. Un partido no puede terminar en empate (`resultado` = E), si el Mundial ya se encuentra en las fases eliminatorias.
3. `id_grupo` solo puede contar con valor si el partido es de fase de grupos y lo mismo para `codigo_llave` si nos encontramos en fases eliminatorias. El grupo del partido debe ser igual para ambas selecciones que se encuentren jugando ese partido.
4. Un jugador no puede ser convocado por dos selecciones en una misma edición del Mundial.
5. La convocatoria de jugadores de una selección no puede superar el `cupo_convocatoria` establecido en esa edición, y solo debe tener un capitán.
6. La suma de los goles proveniente de ESTADISTICA_JUGADOR_PARTIDO debe conicidir con la de `goles_marcados` de PARTICIPACION_PARTIDO.
7. Todo cambio sobre el marcador de un partido o el estado de este mismo quedará registrado en AUDITORIA_EVENTO.
8. La suma proveniente de `cantidad_vendida` en ENTRADA y la `asistencia` del partido no pueden sobrepasar la `capacidad` del estadio en el que se esta jugando.

## 7. Diagrama 

El diagrama del modelo lógico ampliado, con las 20 tablas y sus relaciones, se encuentra en `modelo_logico.png`. El detalle de cada atributo (tipo de dato, nulabilidad y restricciones) se encuentra en `diccionario_datos_ampliado.md`.