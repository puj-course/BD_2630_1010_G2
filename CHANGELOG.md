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

