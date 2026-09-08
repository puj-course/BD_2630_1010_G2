Pruebas de Roles y Privilegios — Entrega 1

Aquí se evidencia que cada rol, ROL_CONSULTA_FIFA_G2 y ROL_OPERATIVO_FIFA_G2, solo puede realizar las operaciones para las que fue autorizado. Cada caso se ejecutó conectado con la cuenta Oracle del integrante al que se le otorgó el rol correspondiente, y no con la cuenta dueña de las tablas.

Caso 1 — Consulta autorizada (rol de solo lectura)

Usuario: is101010, Pablo (rol ROL_CONSULTA_FIFA_G2)

Operación ejecutada:
SELECT * FROM PARTIDO;

Resultado esperado: éxito, devuelve las filas de PARTIDO.

Resultado obtenido: (pegar aquí la salida real)

Caso 2 — Escritura NO autorizada con el rol de consulta

Usuario: is101010, Pablo (rol ROL_CONSULTA_FIFA_G2)

Operación ejecutada:
INSERT INTO PARTIDO (id_partido, id_edicion, id_estadio, fecha_hora, fase)
VALUES (9999, 1, 1, SYSTIMESTAMP, 'Fase de Grupos');

Resultado esperado: falla con ORA-01031, privilegios insuficientes, ya que el rol de consulta no tiene otorgado el privilegio INSERT.

Resultado obtenido: (pegar aquí la salida real)

Caso 3 — Escritura autorizada (rol operativo)

Usuario: is101002, Julian (rol ROL_OPERATIVO_FIFA_G2)

Operación ejecutada:
INSERT INTO PARTIDO (id_partido, id_edicion, id_estadio, fecha_hora, fase)
VALUES (9998, 1, 1, SYSTIMESTAMP, 'Fase de Grupos');

Resultado esperado: éxito, ya que el rol operativo tiene otorgado el privilegio INSERT sobre PARTIDO.

Resultado obtenido: (pegar aquí la salida real)

Caso 4 — Escritura NO autorizada sobre tabla catálogo (rol operativo)

Usuario: is101002, Julian (rol ROL_OPERATIVO_FIFA_G2)

Operación ejecutada:
INSERT INTO EDICION_MUNDIAL (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
VALUES (99, 2099, 'Pais Prueba', 'Lema Prueba', DATE '2099-01-01', DATE '2099-02-01');

Resultado esperado: falla con ORA-01031, ya que el rol operativo solo tiene otorgado el privilegio SELECT sobre EDICION_MUNDIAL, no INSERT, porque no administra ediciones.

Resultado obtenido: (pegar aquí la salida real)

Caso 5 — Privilegio revocado temporalmente (rol operativo)

Contexto: este caso se ejecuta justo después de correr REVOKE UPDATE ON PARTIDO FROM ROL_OPERATIVO_FIFA_G2 (ver sql/roles/roles_privilegios.sql), antes de volver a otorgar el privilegio.

Usuario: is101002, Julian (rol ROL_OPERATIVO_FIFA_G2)

Operación ejecutada:
UPDATE PARTIDO SET fase = 'Semifinal' WHERE id_partido = 9998;

Resultado esperado: falla con ORA-01031, ya que el privilegio UPDATE se revocó justo antes de esta prueba.

Resultado obtenido: (pegar aquí la salida real)

Verificación posterior: tras volver a ejecutar GRANT UPDATE ON PARTIDO TO ROL_OPERATIVO_FIFA_G2, se repite la misma sentencia UPDATE y se confirma que esta vez sí se ejecuta con éxito.

Resultado obtenido: (pegar aquí la salida real)

Caso 6 — Operación no otorgada a ningún rol (DELETE)

Usuario: is101002, Julian (rol ROL_OPERATIVO_FIFA_G2)

Operación ejecutada:
DELETE FROM PARTICIPACION_PARTIDO WHERE id_partido = 9998;

Resultado esperado: falla con ORA-01031, ya que ningún rol tiene otorgado el privilegio DELETE, con el fin de evitar el borrado accidental de resultados ya registrados.

Resultado obtenido: (pegar aquí la salida real)

Resumen de resultados

Caso 1, consulta SELECT sobre PARTIDO con el rol de consulta, resultado esperado éxito, coincide: (completar tras ejecutar en el servidor).

Caso 2, INSERT sobre PARTIDO con el rol de consulta, resultado esperado ORA-01031, coincide: (completar tras ejecutar en el servidor).

Caso 3, INSERT sobre PARTIDO con el rol operativo, resultado esperado éxito, coincide: (completar tras ejecutar en el servidor).

Caso 4, INSERT sobre EDICION_MUNDIAL con el rol operativo, resultado esperado ORA-01031, coincide: (completar tras ejecutar en el servidor).

Caso 5, UPDATE sobre PARTIDO con el rol operativo sin el privilegio vigente, resultado esperado ORA-01031 y luego éxito tras el GRANT, coincide: (completar tras ejecutar en el servidor).

Caso 6, DELETE sobre PARTICIPACION_PARTIDO con el rol operativo, resultado esperado ORA-01031, coincide: (completar tras ejecutar en el servidor).

Al finalizar las pruebas, se deben limpiar los datos de prueba correspondientes a id_partido 9998 y 9999, mediante DELETE o ROLLBACK ejecutado desde la cuenta dueña de las tablas.