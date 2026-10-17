# Modelo Físico

## Introducción 
Este documento se encarga de describir detalladamente la implementación física del modelo lógico ampliado ('modelo_logico.md') utilizando el mismo motor que en la entrega 1. El módelo físico se encargará de definir como se crean los atributos y relaciones definidas en el modelo lógico realmente dentro del propio motor:

- Los tipos de datos propios del motor (Oracle) que se ussarán en cada columna.
- La convención de nombres para las restricciones s(FK, CHECK, PK, UNIQUE).
- Comportamiento de las foreign keys cuando se elimine un registro (ON DELETE).
- Los índices creados paara poder tener un mejor rendimiento de las consultas, con su apropiada justificación.

El detalle de cada atributo (tipo, restricciones y nulabilidad) se encuentra dentro de 'diccionario_datos_ampliado.md'.

