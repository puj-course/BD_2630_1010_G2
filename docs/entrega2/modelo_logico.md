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


