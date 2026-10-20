# CHANGELOG

## Equipo del Proyecto

| Nombre         | GitHub / Perfil           |
| -------------- | ------------------------- |
| Pablo Marcos   | github.com/PabloMarcosC   |
| Manuel Garces  | github.com/manuelgarces10 |
| Julian Caicedo | github.com/Juliancaicedou |

---

# Registro proyecto

## Semana 1 (16–22 marzo)

### Objetivos de la semana

* Analizar el enunciado y los requerimientos correspondientes a la Entrega 1.
* Definir el modelo entidad-relación inicial.
* Identificar las entidades, atributos y relaciones necesarias para el funcionamiento de la base de datos.
* Distribuir las tareas entre los integrantes del equipo.

### Tareas realizadas

| Tarea                               | Responsable(s) | Rama utilizada    | Descripción                                                                     |
| ----------------------------------- | -------------- | ----------------- | ------------------------------------------------------------------------------- |
| Análisis del enunciado              | Pablo Marcos   | analisis-entrega1 | Revisión de los requerimientos y alcance de la Entrega 1.                       |
| Diseño del modelo ER inicial        | Julian Caicedo | modelo-er         | Identificación de entidades, atributos, claves y relaciones del modelo inicial. |
| Revisión del modelo y documentación | Manuel Garcés  | docs-entrega1     | Revisión del modelo inicial y organización de la documentación técnica.         |

### Cambios principales

* Se definió el modelo inicial de la base de datos.
* Se establecieron las cinco entidades principales:

  * `EDICION_MUNDIAL`
  * `ESTADIO`
  * `SELECCION`
  * `PARTIDO`
  * `PARTICIPACION_PARTIDO`
* Se identificaron las claves primarias y relaciones entre las entidades.
* Se estableció `PARTICIPACION_PARTIDO` como entidad asociativa entre partidos y selecciones.

### Problemas encontrados

* Fue necesario interpretar correctamente las relaciones entre las entidades.
* Se presentaron dudas sobre la forma de representar la participación de las selecciones en cada partido.
* Se revisaron los requerimientos para mantener el alcance únicamente en el modelo correspondiente a la Entrega 1.

---

## Semana 2 (23–29 marzo)

### Objetivos de la semana

* Implementar el modelo relacional inicial mediante SQL.
* Crear las tablas y restricciones correspondientes.
* Preparar los datos necesarios para realizar las consultas de la Entrega 1.
* Desarrollar las primeras consultas SQL utilizando JOIN y operaciones de agrupación.

### Tareas realizadas

| Tarea                   | Responsable(s) | Rama utilizada     | Descripción                                                                      |
| ----------------------- | -------------- | ------------------ | -------------------------------------------------------------------------------- |
| Implementación del DDL  | Pablo Marcos   | ddl-modelo-inicial | Creación de las tablas, claves primarias y claves foráneas del modelo inicial.   |
| Implementación del DML  | Manuel Garces  | dml-ciclo-vida     | Creación e inserción de datos para probar el funcionamiento del modelo.          |
| Consultas SQL iniciales | Julian Caicedo | consultas-sql      | Desarrollo de consultas utilizando JOIN, agrupaciones y funciones de agregación. |

### Cambios principales

* Se implementó el esquema relacional correspondiente al modelo inicial.
* Se crearon las tablas y relaciones mediante DDL.
* Se incorporaron datos de prueba mediante DML.
* Se desarrollaron consultas relacionadas con:

  * Goles por selección.
  * Ocupación estimada de estadios.
  * Diferencia de goles.
  * Partidos agrupados por fase.
  * Estadios con mayor cantidad de partidos.

### Problemas encontrados

* Se presentaron dificultades iniciales con algunas relaciones entre tablas.
* Fue necesario verificar las claves foráneas y la correspondencia entre los registros.
* Se revisaron las consultas para evitar resultados duplicados producto de los JOIN.

---

## Semana 3 (6–12 abril)

### Objetivos de la semana

* Completar las consultas avanzadas requeridas para la Entrega 1.
* Implementar subconsultas y consultas con `EXISTS` y `NOT EXISTS`.
* Crear las vistas solicitadas.
* Traducir algunas consultas SQL a álgebra relacional.

### Tareas realizadas

| Tarea                              | Responsable(s) | Rama utilizada     | Descripción                                                                                                                                          |
| ---------------------------------- | -------------- | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Subconsultas y consultas avanzadas | Pablo Marcos   | subconsultas       | Implementación de consultas utilizando subconsultas, `NOT EXISTS` y comparaciones con promedios.                                                     |
| Desarrollo de vistas               | Manuel Garces  | vistas             | Creación y prueba de las vistas requeridas para facilitar consultas sobre la información del modelo.                                                 |
| Álgebra relacional                 | Julian Caicedo | algebra-relacional | Traducción de consultas SQL seleccionadas a expresiones de álgebra relacional utilizando selección, proyección, JOIN y otros operadores pertinentes. |


### Cambios principales

* Se completaron las consultas mediante subconsultas.
* Se implementaron consultas de verificación utilizando `NOT EXISTS`.
* Se desarrollaron las vistas correspondientes a la Entrega 1.
* Se documentaron expresiones de álgebra relacional para consultas seleccionadas.
* Se revisó la correspondencia entre las consultas SQL y las operaciones del álgebra relacional.

### Problemas encontrados

* Algunas consultas requirieron varias subconsultas para obtener los resultados esperados.
* Se presentaron dificultades al traducir consultas con agregaciones a álgebra relacional.
* Fue necesario verificar que las vistas utilizaran correctamente las relaciones del modelo inicial.
* Se realizaron pruebas adicionales para comprobar que las consultas devolvieran resultados coherentes.

---

## Semana 4 (13–22 abril)

### Objetivos de la semana

* Finalizar los componentes de la Entrega 1.
* Implementar los roles y privilegios de acceso.
* Verificar la integridad de los datos.
* Realizar pruebas finales de DML, consultas y privilegios.
* Organizar la documentación y estructura final de entrega.

### Tareas realizadas

| Tarea                              | Responsable(s) | Rama utilizada     | Descripción                                                                                                  |
| ---------------------------------- | -------------- | ------------------ | ------------------------------------------------------------------------------------------------------------ |
| Roles y privilegios                | Pablo Marcos   | roles-privilegios  | Creación de los roles de consulta y operación, junto con sus respectivos permisos.                           |
| Pruebas de integridad y DML        | Manuel Garces  | pruebas-integridad | Verificación de restricciones, operaciones DML y comportamiento de los datos.                                |
| Organización y documentación final | Julian Caicedo | docs-entrega1      | Organización de la documentación, revisión de archivos y preparación de la estructura final de la Entrega 1. |

### Cambios principales

* Se implementaron los roles correspondientes a la Entrega 1:

  * Rol de consulta, con permisos de lectura.
  * Rol operativo, con permisos para realizar operaciones sobre las tablas transaccionales.
* Se realizaron pruebas de `GRANT` y `REVOKE`.
* Se verificó la integridad de las relaciones mediante claves primarias y foráneas.
* Se realizaron pruebas sobre las operaciones DML.
* Se revisaron las consultas, vistas y expresiones de álgebra relacional.
* Se organizó la estructura final del proyecto para la entrega.

### Problemas encontrados

* Fue necesario revisar los permisos asignados a cada rol para evitar otorgar privilegios innecesarios.
* Se realizaron pruebas adicionales para comprobar que el rol de consulta no pudiera modificar información.
* Se verificó que las operaciones del rol operativo estuvieran limitadas a las acciones requeridas.
* Finalmente se revisó la documentación y organización de los archivos para asegurar la correspondencia entre el código SQL y los documentos de la Entrega 1.





--

# Entrega 2

## Semana 1 

### Objetivos de la semana

* Empezar el modelo ampliado a partir de la evaluación crítica de la Entrega 1.
* Crear los archivos de la Entrega 2.
* Definir las tablas nuevas del modelo.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|---|---|---|---|
| Creación de los documentos de la Entrega 2 | Pablo Marcos | feature/modelo-logico | Se crearon modelo_logico.md y diccionario_datos_ampliado.md en docs/entrega2. |
| Secciones 1 a 4 del modelo lógico | Pablo Marcos | feature/modelo-logico | Introducción, lista de tablas, cambios frente al modelo inicial y esquema de las tablas. |
| Primera versión del DDL ampliado | Manuel Garcés | feature/modelo-logico | Primeras tablas nuevas: jugadores, árbitros, estadísticas, boletería, incidencias, etc. |

### Cambios principales

* Se definieron las 20 tablas del modelo ampliado.
* Se agregaron las tablas propuestas en la evaluación crítica (FASE, GRUPO, CONFEDERACION, JUGADOR y AUDITORIA_EVENTO) y otras nuevas para cubrir las reglas de negocio (FEDERACION, CONVOCATORIA_JUGADOR, CUERPO_TECNICO, ARBITRO, ASIGNACION_ARBITRAL, ENTRADA, ACREDITACION_PRENSA e INCIDENCIA).

### Problemas encontrados

* El modelo lógico y el DDL se hicieron al mismo tiempo y quedaron con nombres de tablas y columnas diferentes. Esto se corrigió más adelante.

---

## Semana 2 

### Objetivos de la semana

* Terminar el modelo lógico.
* Empezar el modelo físico.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|---|---|---|---|
| Finalización del modelo lógico | Pablo Marcos, Manuel Garcés | feature/modelo-logico | Esquema de las 20 tablas, relaciones y cardinalidades, reglas de negocio y referencia al diagrama. |
| Inicio del modelo físico | Pablo Marcos | feature/modelo-logico | Introducción, tipos de datos, convención de nombres y llaves foráneas con ON DELETE. |

### Cambios principales

* Se documentaron todas las relaciones 1:N y N:M del modelo.
* Se dejaron identificadas las reglas que no se pueden controlar solo con la estructura y que se van a hacer con triggers en la Entrega 3.
* Se definió si cada llave foránea es restrictiva o CASCADE.

### Problemas encontrados

* Al revisar el DDL de la semana 1 vimos que no coincidía con el modelo lógico (nombres de tablas, columnas y tipos de datos). Quedó pendiente para la siguiente semana.
* En la semana del 5 al 11 de octubre no se registraron avances en el repositorio.

---

## Semana 3 

### Objetivos de la semana

* Corregir el DDL para que coincida con el modelo lógico y crear las tablas en Oracle.
* Terminar el diccionario de datos y el modelo físico.
* Cargar datos de prueba.
* Hacer la normalización, las consultas avanzadas, los roles y los casos de prueba.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|---|---|---|---|
| Corrección y ejecución del DDL | Manuel Garcés | feature/modelo-logico | DDL con las 20 tablas, restricciones con nombre, llaves foráneas e índices. Se ejecutó en Oracle. |
| Diccionario de datos ampliado | Manuel Garcés | feature/modelo-logico | Tipo, si admite nulos, restricciones y descripción de cada columna de las 20 tablas. |
| Modelo físico (índices y diagrama) | Manuel Garcés, Pablo Marcos | feature/modelo-logico | Justificación de los índices y explicación del diagrama físico. |
| Diagramas lógico y físico | Manuel Garcés | feature/modelo-logico | Se hicieron con SQL Developer Data Modeler (modelo_logico.png y modelo_fisico.png). |
| Carga de datos de prueba | Manuel Garcés | feature/modelo-logico | Datos para las 20 tablas en sql/entrega2/dml/carga_datos_prueba.sql. |
| Normalización | Manuel Garcés, Pablo Marcos | feature/modelo-logico | Justificación de 1FN, 2FN y 3FN de todas las tablas (normalizacion.md). |
| Consultas avanzadas parte 1 y parte 2 | Manuel Garcés | feature/modelo-logico | 8 consultas: tabla de posiciones, goleadores, ocupación de estadios, goles por fase, resultados, confederaciones, árbitros y resumen de la edición. |
| Roles y privilegios | Julian Caicedo | feature/modelo-logico | Roles de administrador, analista deportivo y auditor, con sus GRANT y su documentación. |
| Casos de prueba de roles | Julian Caicedo | feature/modelo-logico | Pruebas de lo que puede y no puede hacer cada rol. |
| Casos de prueba de integridad | Manuel Garcés | feature/modelo-logico | Pruebas de los CHECK, UNIQUE, llaves foráneas y ON DELETE CASCADE del DDL. |

### Cambios principales

* Los archivos SQL se organizaron en sql/entrega2 (ddl, dml y consultas), como pide el cronograma.
* La tabla CIUDAD se cambió a CIUDAD_SEDE en el DDL y en todos los documentos.
* Todas las restricciones quedaron con nombre propio (pk_, fk_, uq_, chk_, idx_).
* Se revisó que el modelo lógico, el diccionario, el modelo físico y el DDL usen los mismos nombres de tablas y columnas.

### Problemas encontrados

* En el esquema de Oracle ya existía una tabla CIUDAD de otro taller, con otras tablas que dependían de ella, entonces no se podía borrar ni crear la nuestra. Lo solucionamos cambiando el nombre a CIUDAD_SEDE.
* Al cambiar la tabla ESTADIO se borró sin querer el paréntesis de cierre, y eso hizo que fallaran las tablas que dependían de ella. Se corrigió y se volvió a correr el script.
* Algunos commits quedaron solo en el computador y no se veían en GitHub hasta que se hizo el Push.
* El archivo de consultas se subió primero con otro nombre y con un comentario sin los "--", lo que daba error. Se corrigió y se renombró a consultas_avanzadas_parte1.sql.

# Semana 4 — Cierre de la Entrega 2

### Objetivos de la semana

* Revisar y corregir todos los documentos de la Entrega 2 antes de entregar.
* Dejar cada archivo en la ruta que pide el cronograma.
* Fusionar la rama feature/modelo-logico a main.
* Actualizar el CHANGELOG con la entrada final de la Entrega 2.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|---|---|---|---|
| Revisión del modelo físico | Manuel Garcés | feature/modelo-logico | Se corrigieron errores de escritura y nombres de índices para que coincidan con el DDL. |
| Revisión del modelo lógico | Pablo Marcos | feature/modelo-logico | Se corrigieron detalles de formato y redacción. |
| Ajuste de la normalización | Pablo Marcos | feature/modelo-logico | Se completó la explicación de los atributos calculados en la sección 5.2. |
| Organización de los casos de prueba | Julian Caicedo, Manuel Garcés | feature/modelo-logico | Se unieron los casos de roles y de integridad en tests/entrega2/casos_prueba.md y se borró el archivo viejo. |
| Pull Request y merge a main | Julian Caicedo | main | Se revisaron los cambios y se fusionó la rama feature/modelo-logico a main. |
| Actualización del CHANGELOG | Manuel Garcés | main | Se registraron las cuatro semanas de la Entrega 2. |

### Cambios principales

* Todos los archivos de la Entrega 2 quedaron en docs/entrega2, sql/entrega2 y tests/entrega2.
* La rama main quedó con la versión final de la Entrega 2.
* Se revisó que todos los documentos usen los mismos nombres de tablas, columnas, restricciones e índices.

### Problemas encontrados

* Los casos de prueba estaban en la carpeta tests y no en tests/entrega2, así que hubo que moverlos.
* Había nombres de índices escritos diferente en el modelo físico y en el DDL.
