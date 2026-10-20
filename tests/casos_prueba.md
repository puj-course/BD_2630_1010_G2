# Casos de prueba — Entrega 2 (roles y privilegios)

- **Julian** (`is101002`): administrador. Para probar el auditor se ejecuta antes `SET ROLE ROL_AUDITOR;`
- **Pablo** (`is101010`): analista deportivo.

Las operaciones que modifican datos se cierran con `ROLLBACK;` para no alterar la información.

## Casos de prueba exitosos

| N.º | Usuario / rol | Operación ejecutada | Resultado |
|---|---|---|---|
| 1 | Julian (administrador) | `SELECT * FROM IS101004.PARTIDO;` | Muestra los partidos |
| 2 | Julian (administrador) | `UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1;` y luego `ROLLBACK;` | `1 row updated` |
| 3 | Pablo (analista) | `SELECT * FROM IS101004.JUGADOR;` | Muestra los jugadores |
| 4 | Pablo (analista) | `SELECT COUNT(*) FROM IS101004.ESTADISTICA_JUGADOR_PARTIDO;` | Devuelve un número |
| 5 | Julian con `SET ROLE ROL_AUDITOR;` | `SELECT COUNT(*) FROM IS101004.ENTRADA;` | Devuelve un número |

## Casos de prueba fallidos

| N.º | Usuario / rol | Operación ejecutada | Resultado |
|---|---|---|---|
| 6 | Julian (administrador) | `DELETE FROM IS101004.AUDITORIA_EVENTO;` | `ORA-01031: insufficient privileges` |
| 7 | Julian (administrador) | `CREATE TABLE IS101004.PRUEBA (ID NUMBER);` | `ORA-01031: insufficient privileges` |
| 8 | Julian (administrador) | `UPDATE IS101004.PARTIDO SET ID_ESTADIO = -1 WHERE ROWNUM = 1;` | `ORA-02291: integrity constraint violated - parent key not found` |
| 9 | Pablo (analista) | `UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1;` | `ORA-01031: insufficient privileges` |
| 10 | Pablo (analista) | `SELECT * FROM IS101004.ENTRADA;` | `ORA-00942: table or view does not exist` |
| 11 | Pablo (analista) | `SELECT * FROM IS101004.AUDITORIA_EVENTO;` | `ORA-00942: table or view does not exist` |
| 12 | Pablo (analista) | `SET ROLE ROL_ADMIN_TORNEO;` | `ORA-01924: role 'ROL_ADMIN_TORNEO' not granted or does not exist` |
| 13 | Julian con `SET ROLE ROL_AUDITOR;` | `UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1;` | `ORA-01031: insufficient privileges` |
| 14 | Julian con `SET ROLE ROL_AUDITOR;` | `DELETE FROM IS101004.AUDITORIA_EVENTO;` | `ORA-01031: insufficient privileges` |

## Qué demuestran

- Casos 1 a 5: cada rol puede hacer lo que le corresponde.
- Casos 6, 7, 9, 13 y 14: nadie puede hacer más de lo que su rol permite.
- Casos 10, 11 y 12: el analista no ve datos que no necesita ni puede darse más permisos.
- Caso 8: aunque el administrador tenga permiso de modificar, las llaves foráneas siguen aplicando.

