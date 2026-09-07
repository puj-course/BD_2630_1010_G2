# Pruebas de DML — Entrega 1

Aqui se realiazan las respectivas pruebas de dml, odas las pruebas se ejecutan en orden, después del ciclo de vida "feliz" (creación del partido, registro de sus dos participaciones y actualización del marcador final), conectado con la cuenta dueña de las tablas.

> Peguen aquí la salida real obtenida al correr cada sentencia en el servidor Oracle del curso.

---

## Caso 1 — Gol negativo

**Operación ejecutada:**
```sql
UPDATE participacion_partido
SET goles_marcados = -5 
WHERE id_partido = 1 AND id_seleccion = 1;
```
**Restricción que debe activarse:** `chk_participacion_goles CHECK (goles_marcados >= 0)`.
**Resultado esperado:** falla con `ORA-02290: check constraint (...CHK_PARTICIPACION_GOLES) violated`.
**Resultado obtenido:** _(ORA-02290: restricción de control (IS101004.CHK_PARTICIPACION_GOLES) violada)_

---

## Caso 2 — Misma selección participando dos veces en el mismo partido

**Operación ejecutada:**
```sql
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (3, 1, 1, 'local', 5);
```
**Contexto:** la selección `id_seleccion = 1` (España) ya tiene registrada una participación como `'local'` en el partido 1.
**Restricción que debe activarse:** `uq_participacion_partido_seleccion UNIQUE (id_partido, id_seleccion)` (y también `uq_participacion_partido_condicion`, ya que `'local'` también está repetido).
**Resultado esperado:** falla con `ORA-00001: unique constraint (...UQ_PARTICIPACION_PARTIDO_SELECCION) violated`.
**Resultado obtenido:** _(ORA-00001: restricción única (IS101004.UQ_PARTICIPACION_PARTIDO_SELECCION) violada
)_

---

## Caso 3 — Tercer participante en un mismo partido

**Operación ejecutada:**
```sql
INSERT INTO participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (4, 1, 3, 'visitante', 0);
```
**Contexto:** la selección `id_seleccion = 3` (Alemania) nunca había participado en el partido 1; se intenta agregarla como una tercera participación, pero el partido ya tiene su `'local'` (España) y su `'visitante'` (Colombia) registrados.
**Restricción que debe activarse:** `uq_participacion_partido_condicion UNIQUE (id_partido, condicion)` — combinada con el `CHECK (condicion IN ('local','visitante'))`, garantiza que un partido nunca tenga más de dos participaciones.
**Resultado esperado:** falla con `ORA-00001: unique constraint (...UQ_PARTICIPACION_PARTIDO_CONDICION) violated`.
**Resultado obtenido:** _(RA-00001: restricción única (IS101004.UQ_PARTICIPACION_PARTIDO_CONDICION) violada
)_

---

## Caso 4 — Comportamiento `ON DELETE CASCADE` (`participacion_partido` → `partido`)

**Operación ejecutada:**
```sql
SELECT COUNT(*) AS participaciones_antes
FROM participacion_partido WHERE id_partido = 1;

DELETE FROM partido WHERE id_partido = 1;
COMMIT;

SELECT COUNT(*) AS participaciones_despues
FROM participacion_partido WHERE id_partido = 1;
```
**Restricción definida en el DDL:** `fk_participaciones_partido FOREIGN KEY (id_partido) REFERENCES partido (id_partido) ON DELETE CASCADE`.
**Resultado esperado:** el `DELETE` sobre `partido` se ejecuta con éxito, y `participaciones_despues` da `0` (las participaciones del partido eliminado se borran automáticamente en cascada).
**Resultado obtenido (participaciones_antes):** _(pegar aquí)_
**Resultado obtenido (participaciones_despues):** _(pegar aquí)_

---

## Caso 5 — Comportamiento `ON DELETE RESTRICT` (`estadio`/`seleccion` → `edicion_mundial`)

**Operación ejecutada:**
```sql
DELETE FROM edicion_mundial WHERE id_edicion = 1;
```
**Restricción definida en el DDL:** `fk_estadio_edicion` y `fk_seleccion_edicion`, ambas sin `ON DELETE` explícito (comportamiento por defecto `RESTRICT`).
**Contexto:** en este punto la edición 1 todavía tiene estadios y selecciones asociadas (el `DELETE` del Caso 4 solo eliminó el partido y sus participaciones, no los estadios ni las selecciones).
**Resultado esperado:** falla con `ORA-02292: integrity constraint (...) violated - child record found`.
**Resultado obtenido:** _(ORA-02292: restricción de integridad (IS101004.FK_ESTADIO_EDICION) violada - registro secundario encontrado)_

