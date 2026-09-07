Documento Técnico — Entrega 1

Este documento constituye un archivo vivo del proyecto que se actualiza semana a semana dentro del mismo archivo, sin generar documentos adicionales para las mismas secciones. La presente versión incorpora las cinco secciones correspondientes al cierre de la Entrega 1: descripción del problema y alcance (Sección 1), supuestos de modelado (Sección 2), modelo entidad-relación (Sección 3), transformación a modelo lógico relacional (Sección 4) y diccionario de datos (Sección 5).

1. Descripción del problema y alcance del sistema

Una Copa Mundial de la FIFA constituye, ante todo, un ecosistema de información: en torno a cada partido convergen procesos de organización (sedes, estadios, calendario), procesos deportivos (selecciones, resultados) y procesos analíticos (estadísticas, rendimiento). El presente proyecto tiene como objetivo diseñar e implementar una base de datos relacional que modele el funcionamiento operativo de una edición del Mundial, permitiendo consultar de manera confiable la información generada durante el torneo.

Para esta primera entrega, el alcance se restringe exclusivamente al Modelo Genérico Inicial de cinco entidades definido en el enunciado del proyecto:

EDICION_MUNDIAL: representa cada versión del torneo (año, país sede, lema, fechas de inicio y fin).
ESTADIO: los estadios utilizados durante una edición, asociados a dicha edición.
SELECCION: las selecciones nacionales participantes en una edición.
PARTIDO: los partidos disputados, cada uno asociado a una edición, un estadio, una fecha/hora y una fase.
PARTICIPACION_PARTIDO: entidad asociativa que resuelve la relación muchos-a-muchos entre PARTIDO y SELECCION, registrando la condición (local/visitante) y los goles marcados por cada selección en cada partido.

Sobre este modelo mínimo se desarrollan, en esta entrega, los temas correspondientes al primer corte: modelo relacional, álgebra relacional, SQL (JOIN, agrupamiento, subconsultas, vistas), modificadores de datos (DML), e integridad y privilegios básicos. El modelo ampliado (jugadores, árbitros, estadísticas detalladas, grupos, fases eliminatorias, boletería, medios, incidencias, auditoría, entre otros) queda fuera del alcance de esta entrega y se desarrollará a partir de la Entrega 2, conforme a lo indicado en la Sección 7 del enunciado.

Siguiendo la metodología de trabajo descrita en README_GUIA_SERVIDOR.md, esta entrega combina dos fuentes de datos sobre Oracle Database 19c:

Las consultas SQL, vistas y verificaciones de integridad (Secciones 9.1.9 y 9.1.4 del enunciado) se ejecutan sobre el esquema de referencia compartido MORENOLUIS.FIFA_*, de solo lectura, dispuesto por el curso para la totalidad de los estudiantes.
El DDL, las restricciones, los roles y privilegios, y el DML (ciclo de vida de un partido, intentos de operación inválida) se implementan sobre un esquema propio del equipo, con datos de prueba propios y distintos de los de MORENOLUIS, conforme a lo exigido en la Sección 7 de README_GUIA_SERVIDOR.md.

2. Supuestos de modelado adoptados por el equipo

1. Nombres y tipos de dato: se conservan de manera exacta los nombres de entidades y atributos definidos en el Modelo Genérico Inicial del enunciado (Sección 6), empleando los tipos de dato de Oracle equivalentes (NUMBER, VARCHAR2, DATE).

2. Tabla propia ASISTENCIA_PARTIDO (ajuste menor justificado): el modelo inicial no incorpora ningún atributo de asistencia o aforo registrado por partido; sin embargo, la Consulta 2 del enunciado (Sección 9.1.9) exige calcular el porcentaje de ocupación estimado por estadio (ocupacion = asistencia_registrada / capacidad por 100). Dado que las consultas y vistas de esta entrega se ejecutan sobre MORENOLUIS.FIFA_* (esquema de solo lectura, que no contempla dicho dato y no puede ser modificado), el equipo incorpora una tabla propia ASISTENCIA_PARTIDO, con las columnas id_partido y asistencia_real, en su esquema, poblada con datos ficticios propios, la cual se relaciona por id_partido con MORENOLUIS.FIFA_PARTIDO y MORENOLUIS.FIFA_ESTADIO. Constituye el único elemento agregado sobre el modelo inicial en esta entrega, y se documenta también al inicio de sql/vistas/vistas.sql.

3. Condición local/visitante: el atributo condicion de PARTICIPACION_PARTIDO se modela como una cadena restringida mediante CHECK a los valores local y visitante (minúsculas), según se define en sql/ddl/ddl_modelo_inicial.sql.

4. Un partido equivale exactamente a dos participaciones: cada partido cuenta siempre con dos y solo dos filas asociadas en PARTICIPACION_PARTIDO (una por selección), una con condición local y otra con visitante. Esta regla se valida mediante el script de DML y mediante restricciones de integridad; su cumplimiento estricto (garantizar un mínimo de dos participaciones y no solo un máximo) se refuerza mediante trigger en la Entrega 3, según se documenta en la Sección 4 del presente documento.

5. goles_marcados como número entero no negativo: se restringe mediante CHECK (goles_marcados mayor o igual a 0) en el DDL del modelo inicial.

6. Fase como texto controlado: para esta entrega, el atributo fase de PARTIDO se modela como VARCHAR2 (por ejemplo, Fase de Grupos, Octavos, Cuartos, Semifinal, Tercer Puesto, Final), sin definir una entidad FASE independiente, dado que el modelo inicial no la contempla. Esta limitación se documenta como hallazgo en la Evaluación Crítica del Modelo Inicial, donde se propone la creación de una entidad FASE para el modelo ampliado de la Entrega 2.

7. Datos de prueba propios: los datos empleados para poblar el esquema propio son ficticios y sintéticos, coherentes con información real del fútbol mundial únicamente en cuanto a nombres de selecciones, sedes y estadios (lo cual está permitido por la Sección 4 del enunciado), pero no representan resultados reales de ningún Mundial; constituyen un conjunto de datos de prueba propio, distinto del conjunto de referencia MORENOLUIS.FIFA_*.

3. Modelo Entidad-Relación (ERD)

El modelo entidad-relación de esta entrega se fundamenta directamente en el Modelo Genérico Inicial del enunciado (Sección 6, Figura 1), incorporando el único ajuste señalado en la Sección 2 del presente documento (tabla auxiliar ASISTENCIA_PARTIDO).

Diagrama: véase modelo_er_inicial.png.

Entidades y relaciones:

EDICION_MUNDIAL — atributos: id_edicion (llave primaria), anio, pais_sede, lema, fecha_inicio, fecha_fin. Relaciones: 1 a N con ESTADIO, SELECCION y PARTIDO.

ESTADIO — atributos: id_estadio (llave primaria), id_edicion (llave foránea), nombre, ciudad, capacidad. Relaciones: N a 1 con EDICION_MUNDIAL; 1 a N con PARTIDO.

SELECCION — atributos: id_seleccion (llave primaria), id_edicion (llave foránea), pais, confederacion. Relaciones: N a 1 con EDICION_MUNDIAL; 1 a N con PARTICIPACION_PARTIDO.

PARTIDO — atributos: id_partido (llave primaria), id_edicion (llave foránea), id_estadio (llave foránea), fecha_hora, fase. Relaciones: N a 1 con EDICION_MUNDIAL y ESTADIO; 1 a N con PARTICIPACION_PARTIDO.

PARTICIPACION_PARTIDO — atributos: id_participacion (llave primaria), id_partido (llave foránea), id_seleccion (llave foránea), condicion, goles_marcados. Relaciones: N a 1 con PARTIDO (exactamente dos por partido) y con SELECCION.

ASISTENCIA_PARTIDO (tabla agregada sobre el modelo inicial, véase supuesto 2, Sección 2) — atributos: id_partido (llave primaria, referencia lógica a MORENOLUIS.FIFA_PARTIDO), asistencia_real. Es una tabla auxiliar propia, sin llave foránea declarada, dado que no es posible referenciar una tabla de otro esquema. Almacena la asistencia estimada por partido, porque MORENOLUIS.FIFA_ESTADIO y MORENOLUIS.FIFA_PARTIDO no incluyen dicho dato y son de solo lectura.

Relaciones principales:

EDICION_MUNDIAL tiene ESTADIO (1 a N)
EDICION_MUNDIAL programa PARTIDO (1 a N)
EDICION_MUNDIAL convoca SELECCION (1 a N)
ESTADIO aloja PARTIDO (1 a N)
PARTIDO registra PARTICIPACION_PARTIDO (1 a 2, exactamente dos participaciones por partido)
SELECCION participa en PARTICIPACION_PARTIDO (1 a N)

La entidad asociativa PARTICIPACION_PARTIDO resuelve la relación muchos-a-muchos entre PARTIDO y SELECCION, siguiendo el diseño propuesto en el enunciado.

4. Transformación a modelo lógico relacional

A partir del modelo entidad-relación de la Sección 3, cada entidad fuerte se transformó directamente en una tabla del modelo lógico, y cada relación 1 a N se representó mediante una llave foránea en la tabla correspondiente al lado "muchos", que referencia la llave primaria de la tabla correspondiente al lado "uno". No fue necesario incorporar tablas adicionales por relaciones N a M, salvo la contemplada en el propio modelo genérico inicial entre PARTIDO y SELECCION, resuelta mediante la entidad asociativa PARTICIPACION_PARTIDO (cada partido con exactamente dos participaciones, una por selección).

EDICION_MUNDIAL — llave primaria: id_edicion. Sin llave foránea; es la raíz del modelo.

ESTADIO — llave primaria: id_estadio. Llave foránea id_edicion hacia EDICION_MUNDIAL. Cardinalidad N a 1 (una edición cuenta con N estadios). Comportamiento ON DELETE: RESTRICT (por defecto).

SELECCION — llave primaria: id_seleccion. Llave foránea id_edicion hacia EDICION_MUNDIAL. Cardinalidad N a 1 (una edición convoca N selecciones). Comportamiento ON DELETE: RESTRICT (por defecto).

PARTIDO — llave primaria: id_partido. Llaves foráneas id_edicion e id_estadio hacia EDICION_MUNDIAL y ESTADIO respectivamente. Cardinalidad N a 1 con ambas (una edición programa N partidos; un estadio aloja N partidos). Comportamiento ON DELETE: RESTRICT (por defecto) en ambas.

PARTICIPACION_PARTIDO — llave primaria: id_participacion. Llaves foráneas id_partido e id_seleccion hacia PARTIDO y SELECCION respectivamente. Cardinalidad N a 1 con ambas (un partido cuenta con exactamente dos participaciones; una selección participa en N partidos). Comportamiento ON DELETE: la llave foránea hacia id_partido usa CASCADE; la llave foránea hacia id_seleccion usa RESTRICT (por defecto).

ASISTENCIA_PARTIDO — llave primaria: id_partido, sin llave foránea declarada (referencia lógica a MORENOLUIS.FIFA_PARTIDO, tabla de otro esquema). Cardinalidad 1 a 1 con un partido del esquema de referencia.

Justificación de las llaves primarias: la totalidad de las llaves primarias corresponde a atributos numéricos generados como identificador propio de cada entidad, sin significado de negocio, de modo que una modificación en un atributo descriptivo (por ejemplo, el nombre de un estadio) no obligue a propagar cambios de llave. Se optó por esta estrategia en lugar de emplear llaves primarias compuestas (por ejemplo, id_edicion y pais en SELECCION), dado que simplifica las referencias desde otras tablas; dicha combinación se conserva, no obstante, como restricción de unicidad, con el fin de garantizar la regla de negocio según la cual una selección no puede repetirse dentro de una misma edición.

Justificación de las llaves foráneas y su cardinalidad: cada llave foránea corresponde a una relación 1 a N identificada en el modelo entidad-relación (una edición con múltiples estadios, selecciones y partidos; un estadio con múltiples partidos; un partido con exactamente dos participaciones; una selección con múltiples participaciones a lo largo del torneo). El detalle de la justificación de cada decisión de ON DELETE se documenta como comentario junto a la respectiva restricción en sql/ddl/ddl_modelo_inicial.sql.

Normalización: el modelo satisface la Tercera Forma Normal (3FN) para efectos de esta entrega. La totalidad de los atributos son atómicos (no existen grupos repetitivos), cada tabla depende en su totalidad de su llave primaria (no se identifican dependencias parciales, dado que ninguna llave primaria es compuesta, con la excepción de PARTICIPACION_PARTIDO, en la cual condicion y goles_marcados dependen del hecho completo "esta selección en este partido" y no de id_partido o id_seleccion de manera individual), y no se identifican dependencias transitivas entre atributos no clave. La normalización correspondiente al modelo ampliado se abordará formalmente en la Entrega 2, conforme a la Sección 8.2.2 del enunciado.

5. Diccionario de datos

El diccionario de datos completo, con el tipo de dato, la nulabilidad, las llaves y las restricciones de cada columna de las seis tablas del modelo, se encuentra en un archivo independiente: diccionario_datos.md.