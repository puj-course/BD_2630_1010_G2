# Casos de prueba - Entrega 2

## 1. Roles y privilegios

- Julian (is101002): tiene el rol de administrador. Cuando queríamos probar el auditor, primero ejecutábamos SET ROLE ROL_AUDITOR;
- Pablo (is101010): tiene el rol de analista deportivo.

Cuando una prueba modificaba datos, hacíamos ROLLBACK; al final para no dañar la información.

### Casos exitosos

| N.º | Usuario / rol | Operación | Resultado |
|---|---|---|---|
| 1 | Julian (administrador) | SELECT * FROM IS101004.PARTIDO; | Muestra los partidos |
| 2 | Julian (administrador) | UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1; y luego ROLLBACK; | 1 row updated |
| 3 | Pablo (analista) | SELECT * FROM IS101004.JUGADOR; | Muestra los jugadores |
| 4 | Pablo (analista) | SELECT COUNT(*) FROM IS101004.ESTADISTICA_JUGADOR_PARTIDO; | Devuelve un número |
| 5 | Julian como auditor | SELECT COUNT(*) FROM IS101004.ENTRADA; | Devuelve un número |

### Casos fallidos

| N.º | Usuario / rol | Operación | Resultado |
|---|---|---|---|
| 6 | Julian (administrador) | DELETE FROM IS101004.AUDITORIA_EVENTO; | ORA-01031: insufficient privileges |
| 7 | Julian (administrador) | CREATE TABLE IS101004.PRUEBA (ID NUMBER); | ORA-01031: insufficient privileges |
| 8 | Julian (administrador) | UPDATE IS101004.PARTIDO SET ID_ESTADIO = -1 WHERE ROWNUM = 1; | ORA-02291: integrity constraint violated - parent key not found |
| 9 | Pablo (analista) | UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1; | ORA-01031: insufficient privileges |
| 10 | Pablo (analista) | SELECT * FROM IS101004.ENTRADA; | ORA-00942: table or view does not exist |
| 11 | Pablo (analista) | SELECT * FROM IS101004.AUDITORIA_EVENTO; | ORA-00942: table or view does not exist |
| 12 | Pablo (analista) | SET ROLE ROL_ADMIN_TORNEO; | ORA-01924: role 'ROL_ADMIN_TORNEO' not granted or does not exist |
| 13 | Julian como auditor | UPDATE IS101004.PARTIDO SET ESTADO = ESTADO WHERE ROWNUM = 1; | ORA-01031: insufficient privileges |
| 14 | Julian como auditor | DELETE FROM IS101004.AUDITORIA_EVENTO; | ORA-01031: insufficient privileges |

### Conclusiones de esta parte

- Con los casos 1 al 5 vimos que cada rol puede hacer lo que le toca.
- En los casos 6, 7, 9, 13 y 14 ningún usuario pudo hacer algo que su rol no le permite.
- En los casos 10, 11 y 12 el analista no puede ver las ventas, ni la auditoría, ni darse permisos de administrador.
- El caso 8 muestra que aunque el administrador puede modificar datos, igual tiene que respetar las llaves foráneas.

## 2. Restricciones del DDL

Acá probamos que las restricciones que definimos en el DDL (CHECK, UNIQUE, llaves foráneas y ON DELETE CASCADE) sí funcionan. Las pruebas las hicimos con el usuario dueño de las tablas (Manuel, is101004) usando los datos de carga_datos_prueba.sql. Al final hicimos ROLLBACK; para que los datos quedaran como estaban.

### Casos fallidos

| N.º | Qué se probó | Operación | Resultado |
|---|---|---|---|
| 15 | Dorsal fuera de rango (chk_convocatoria_dorsal) | INSERT INTO convocatoria_jugador VALUES (25, 1, 4, 30, 'N'); | ORA-02290: restricción de control (IS101004.CHK_CONVOCATORIA_DORSAL) violada |
| 16 | País de federación repetido (uq_federacion_pais) | INSERT INTO federacion VALUES (9, 4, 'Colombia', 'CLM'); | ORA-00001: restricción única (IS101004.UQ_FEDERACION_PAIS) violada |
| 17 | Estadio en una ciudad que no existe (fk_estadio_ciudad) | INSERT INTO estadio VALUES (5, 99, 'Estadio Fantasma', 50000); | ORA-02291: restricción de integridad (IS101004.FK_ESTADIO_CIUDAD) violada - clave principal no encontrada |
| 18 | Borrar una confederación que tiene federaciones (fk_federacion_confederacion) | DELETE FROM confederacion WHERE id_confederacion = 4; | ORA-02292: restricción de integridad (IS101004.FK_FEDERACION_CONFEDERACION) violada - registro secundario encontrado |
| 19 | Condición en minúscula (chk_participacion_condicion) | UPDATE participacion_partido SET condicion = 'local' WHERE id_participacion = 1; | ORA-02290: restricción de control (IS101004.CHK_PARTICIPACION_CONDICION) violada |
| 20 | Capacidad de estadio muy alta (chk_estadio_capacidad) | INSERT INTO estadio VALUES (5, 1, 'Estadio Gigante', 200000); | ORA-02290: restricción de control (IS101004.CHK_ESTADIO_CAPACIDAD) violada |
| 21 | Partido de grupos con código de llave (chk_partido_grupo_llave) | UPDATE partido SET codigo_llave = 'X1' WHERE id_partido = 1; | ORA-02290: restricción de control (IS101004.CHK_PARTIDO_GRUPO_LLAVE) violada |
| 22 | Dos partidos en el mismo estadio a la misma hora (uq_partido_estadio_fechahora) | INSERT INTO partido VALUES (14, 1, 1, 1, NULL, TO_DATE('2026-06-11 18:00','YYYY-MM-DD HH24:MI'), 'PROGRAMADO', NULL, 'N', 'N'); | ORA-00001: restricción única (IS101004.UQ_PARTIDO_ESTADIO_FECHAHORA) violada |

### Casos exitosos

| N.º | Qué se probó | Operación | Resultado |
|---|---|---|---|
| 23 | Insertar un estadio válido | INSERT INTO estadio VALUES (5, 2, 'Estadio Jalisco', 55000); | 1 fila insertada |
| 24 | ON DELETE CASCADE al borrar un partido | DELETE FROM partido WHERE id_partido = 13; | 1 fila eliminada. Antes de borrarlo, el partido 13 tenía 2 participaciones, 6 estadísticas, 4 entradas, 4 árbitros asignados y 1 incidencia. Después de borrarlo todo quedó en 0 |

### Conclusiones de esta parte

- Los CHECK no dejaron guardar valores que no tienen sentido, como un dorsal 30 o un estadio de 200000 personas (casos 15, 19, 20 y 21).
- Los UNIQUE no dejaron repetir datos, por ejemplo el mismo país dos veces (casos 16 y 22).
- Las llaves foráneas no dejaron crear un estadio en una ciudad que no existe ni borrar una confederación con federaciones (casos 17 y 18).
- Cuando los datos están bien, se insertan normal (caso 23).
- Al borrar un partido se borró todo lo relacionado con él, que era lo que queríamos con el CASCADE (caso 24).
