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
