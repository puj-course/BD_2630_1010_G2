# Modelo Físico

## Introducción 
Este documento se encarga de describir detalladamente la implementación física del modelo lógico ampliado ('modelo_logico.md') utilizando el mismo motor que en la entrega 1. El módelo físico se encargará de definir como se crean los atributos y relaciones definidas en el modelo lógico realmente dentro del propio motor:

- Los tipos de datos propios del motor (Oracle) que se ussarán en cada columna.
- La convención de nombres para las restricciones s(FK, CHECK, PK, UNIQUE).
- Comportamiento de las foreign keys cuando se elimine un registro (ON DELETE).
- Los índices creados paara poder tener un mejor rendimiento de las consultas, con su apropiada justificación.

El detalle de cada atributo (tipo, restricciones y nulabilidad) se encuentra dentro de 'diccionario_datos_ampliado.md'.

## Tipos de datos a utilizar
En este proyecto se utilizan los datos propios de Oracle DataBase 19c, eligiendo el tipo de dato que mejor se ajustaba según tipo y tamaño.

- **NUMBER:** se utiliza tanto para llaves primarias como las foráneas, que son identificadores númericos sin significado dentro del negocio.
- **NUMBER (10,2):** utilizado para los valores decimales, como puede ser el 'precio' de las entradas.
- **NUMBER(n):** utilizado para cantidades cuyo límite es conocido, como puede ser 'anio' NUMBER(4) o dorsal NUMBER (2).
- **VARCHAR2(n):** utilizado para textos de una longitud variable y también para valores controlados por CHECK.
- **DATE:** utilizado para fechas con y sin hora, como puede ser 'fecha_hora' de los partidos.
- **CHAR(1):** utilizado para indicadores de un solo carácter, como lo es 'es_capitan' ('S'/'N').
- **char(3):** utilizado para ciertos textos con una longitud fija, como 'codigo_fifa' (COL, FRA...).

### 2.1 Decisiones tomadas
- **CHAR(1) para valores de si/no:** esto se debe a que Oracle 19c no permite valores tipo BOOLEAN en columnas de tabla, utilizando como otra opción CHAR(1) con su respectivo CHECK a 'S' o 'N'.
- **DATE para fecha y hora:** en Oracle, el tipo de dato DATE guarda tanto la fecha como la hora por lo que no es necesario recurri a otros tipos de datos como TIMESTAMP para la hora.
- **VARCHAR2 en lugar de VARCHAR:** Oracle recomienda usar VARCHAR2 en vez de VARCHAR ya que este se encuentra reservado.
- **NUMBER(n) con un tamaño definido:** esto se realizo con el fin de limitar la cantidad de dígitos, para evitar posible valores que esten fuera de rango, como un dorsal con mas de dos dígitos.

## 3. Convención de nombres de restricciones
Todas las restricciones e índices tratadas en este trabajo se declaran con un nombre propio, siguiendo una misma regla a lo largo del proyecto. Al no asignarles un nombre, Oracle les da uno automático, haciendo mucho más díficil saber que regla falló en caso de pposible errores.

El formato utilzado todo el rato es: **prefijo_tabla_columna(s)**

- **fk_ (llave foránea):** se nombra con la tabla que tiene la llave y también con la tabla a la que se referencia ('fk_partido_fase').
- **pk_ (llave primaria):** se nombra con la tabla a la que pertenece ('pk_partido').
- **chk_ (check):** se nombre junto a la tabla y la columna que se valida ('chk_estadio_capacidad').
- **uq_ (unique):** se nombra con la tabla y las columnas que tienen que ser únicas ('uq_fase_edicion_orden').
- **idx_ (índice):** se nombra con la tabla y también con la columna indexada ('idx_partido-grupo').

### 3.1 Ventajas
- **Facilita las pruebas:** así en casos de error durante los casos de prueba se puede indicar exactamente que restricción acabo generando el error.
- **Errores mas claros:** si se intenta registrar un dato erronéo que esta siendo validado por un check, sabiendo así de inmediato la regla que se rompió ('check constraint (CHK_ESTADIO_CAPACIDAD) violated').
- **Consistencia con la entrega 1:** se mantiene la misma convención de restricciones utilizada en la anterior entrega.

## 4. Llaves foráneas y comportamiento ON DELETE

Cada llave foránea define qué pasa con los registros "hijos" cuando se intenta eliminar el registro "padre". Oracle permite dos acciones explícitas:

- **ON DELETE CASCADE:** al borrar el padre, se borran automáticamente todos sus hijos.
- **ON DELETE SET NULL:** al borrar el padre, la llave foránea de los hijos queda en nulo.

Si no se declara ninguna acción, el comportamiento es **restrictivo**: Oracle impide borrar el padre mientras tenga hijos asociados.

Oracle no soporta ON UPDATE. Sin embargo, no es necesario, ya que todas las llaves primarias son identificadores numéricos que nunca cambian.

### 4.1 Criterio utilizado

- **Restrictivo** para catálogos y datos maestros: no se debe poder borrar una edición, un estadio, una selección o un jugador que ya tiene información asociada, porque se perdería el historial del torneo.
- **CASCADE** solo para registros que no tienen sentido sin su padre: si se elimina un partido, todo lo que ocurrió en ese partido también debe desaparecer.
- **SET NULL** no se utiliza, ya que ninguna relación del modelo permite dejar un registro "huérfano" de forma válida.

### 4.2 Llaves foráneas con comportamiento restrictivo
**Organización del torneo**
- 'fk_ciudad_edicion' (CIUDAD_SEDE → EDICION_MUNDIAL): no se borra una edición que tiene ciudades sede.
- 'fk_estadio_ciudad' (ESTADIO → CIUDAD_SEDE): no se borra una ciudad que tiene estadios.

**Competencia deportiva**
- 'fk_fase_edicion' (FASE → EDICION_MUNDIAL): las fases forman parte de la estructura del torneo.
- 'fk_grupo_fase' (GRUPO → FASE): no se borra una fase que tiene grupos.
- 'fk_partido_fase' (PARTIDO → FASE): no se borra una fase con partidos jugados.
- 'fk_partido_estadio' (PARTIDO → ESTADIO): no se borra un estadio donde se jugaron partidos.
- 'fk_partido_grupo' (PARTIDO → GRUPO): no se borra un grupo que tiene partidos.
- 'fk_participacion_seleccion' (PARTICIPACION_PARTIDO → SELECCION): no se borra una selección que ya jugó.

**Selecciones, jugadores y cuerpo técnico**
- 'fk_federacion_confederacion' (FEDERACION → CONFEDERACION): catálogo maestro.
- 'fk_seleccion_edicion' (SELECCION → EDICION_MUNDIAL): no se borra una edición con selecciones inscritas.
- 'fk_seleccion_federacion' (SELECCION → FEDERACION): se conserva el historial de participaciones del país.
- 'fk_seleccion_grupo' (SELECCION → GRUPO): no se borra un grupo que tiene selecciones.
- 'fk_convocatoria_jugador' (CONVOCATORIA_JUGADOR → JUGADOR): se conserva el historial del jugador.

**Arbitraje**
- 'fk_arbitro_confederacion' (ARBITRO → CONFEDERACION): catálogo maestro.
- 'fk_asignacion_arbitro' (ASIGNACION_ARBITRAL → ARBITRO): no se borra un árbitro que ya dirigió partidos.

**Estadísticas y medios**
- 'fk_estadistica_convocatoria' (ESTADISTICA_JUGADOR_PARTIDO → CONVOCATORIA_JUGADOR): no se borra un convocado que tiene estadísticas.
- 'fk_acreditacion_edicion' (ACREDITACION_PRENSA → EDICION_MUNDIAL): no se borra una edición con prensa acreditada.

### 4.3 Llaves foráneas con ON DELETE CASCADE

**Dependen de PARTIDO** (si se elimina el partido, se elimina todo lo que ocurrió en él):
- 'fk_participacion_partido' (PARTICIPACION_PARTIDO → PARTIDO): una participación no existe sin su partido.
- 'fk_asignacion_partido' (ASIGNACION_ARBITRAL → PARTIDO): la designación arbitral pertenece al partido.
- 'fk_estadistica_partido' (ESTADISTICA_JUGADOR_PARTIDO → PARTIDO): las estadísticas pertenecen al partido.
- 'fk_entrada_partido' (ENTRADA → PARTIDO): la boletería pertenece al partido.
- 'fk_incidencia_partido' (INCIDENCIA → PARTIDO): la incidencia ocurrió en ese partido.

**Dependen de SELECCION** (si se retira una selección, se elimina su plantel):
- 'fk_convocatoria_seleccion' (CONVOCATORIA_JUGADOR → SELECCION): la nómina pertenece a la selección.
- 'fk_cuerpotecnico_seleccion' (CUERPO_TECNICO → SELECCION): el cuerpo técnico pertenece a la selección.

### 4.4 Tabla sin llaves foráneas

**AUDITORIA_EVENTO** no tiene llaves foráneas a propósito: debe poder registrar cambios de cualquier tabla y conservar el registro aunque la fila original haya sido eliminada.
