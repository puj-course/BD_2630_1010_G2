Pruebas de DML — Entrega 1

Aquí se realizan las pruebas de DML. Todas las pruebas se ejecutan en orden, después del ciclo de vida feliz (creación del partido, registro de sus dos participaciones y actualización del marcador final), conectado con la cuenta dueña de las tablas.

Caso 1 — Gol negativo

Operación ejecutada:
UPDATE participacion_partido
SET goles_marcados = -5
WHERE id_partido = 1 AND id_seleccion = 1;

Restricción que debe activarse: chk_participacion_goles, que exige que goles_marcados sea mayor o igual a cero.


Resultado obtenido: ORA-02290: restricción de control (IS101004.CHK_PARTICIPACION_GOLES) violada.

Caso 2 — Misma selección participando dos veces en el mismo partido

Operación ejecutada:
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (3, 1, 1, 'local', 5);

Contexto: la selección id_seleccion = 1, España, ya tiene registrada una participación como local en el partido 1.

Restricción que debe activarse: uq_participacion_partido_seleccion, única sobre id_partido e id_seleccion, y también entraría en juego uq_participacion_partido_condicion, ya que la condición local también está repetida.


Resultado obtenido: ORA-00001: restricción única (IS101004.UQ_PARTICIPACION_PARTIDO_SELECCION) violada.

Caso 3 — Tercer participante en un mismo partido

Operación ejecutada:
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (4, 1, 3, 'visitante', 0);

Contexto: la selección id_seleccion = 3, Alemania, nunca había participado en el partido 1. Se intenta agregarla como una tercera participación, pero el partido ya tiene su local, España, y su visitante, Colombia, registrados.

Restricción que debe activarse: uq_participacion_partido_condicion, única sobre id_partido y condicion, que combinada con el CHECK sobre condicion (solo admite local o visitante) garantiza que un partido nunca tenga más de dos participaciones.

Resultado obtenido: ORA-00001: restricción única (IS101004.UQ_PARTICIPACION_PARTIDO_CONDICION) violada.

Caso 4 — Comportamiento ON DELETE CASCADE, de participacion_partido hacia partido

Operación ejecutada:
SELECT COUNT(*) AS participaciones_antes
FROM participacion_partido WHERE id_partido = 1;

DELETE FROM partido WHERE id_partido = 1;
COMMIT;

SELECT COUNT(*) AS participaciones_despues
FROM participacion_partido WHERE id_partido = 1;

Restricción definida en el DDL: fk_participaciones_partido, clave foránea de participacion_partido hacia partido, con ON DELETE CASCADE.

Resultado esperado: el DELETE sobre partido se ejecuta con éxito, y participaciones_despues da cero, ya que las participaciones del partido eliminado se borran automáticamente en cascada.

Resultado obtenido, participaciones_antes: 2

Resultado obtenido, participaciones_despues: 0

Caso 5 — Comportamiento ON DELETE RESTRICT, de estadio y de seleccion hacia edicion_mundial

Operación ejecutada:
DELETE FROM edicion_mundial WHERE id_edicion = 1;

Restricción definida en el DDL: fk_estadio_edicion y fk_seleccion_edicion, ninguna de las dos con ON DELETE explícito, por lo que Oracle aplica el comportamiento por defecto, RESTRICT.

Contexto: en este punto la edición 1 todavía tiene estadios y selecciones asociadas, ya que el DELETE del Caso 4 solo eliminó el partido y sus participaciones, no los estadios ni las selecciones.

Resultado obtenido: ORA-02292: restricción de integridad (IS101004.FK_ESTADIO_EDICION) violada, registro secundario encontrado.

Resumen de resultados

Caso 1, gol negativo sobre participacion_partido, resultado esperado ORA-02290, coincide: sí.

Caso 2, misma selección participando dos veces en el mismo partido, resultado esperado ORA-00001 sobre UQ_PARTICIPACION_PARTIDO_SELECCION, coincide: sí.

Caso 3, tercer participante en el mismo partido, resultado esperado ORA-00001 sobre UQ_PARTICIPACION_PARTIDO_CONDICION, coincide: sí.

Caso 4, eliminación en cascada de las participaciones al borrar un partido, resultado esperado cero participaciones tras el borrado, coincide: (completar tras ejecutar en el servidor).

Caso 5, restricción por defecto al intentar borrar una edición con estadios y selecciones asociadas, resultado esperado ORA-02292, coincide: sí.