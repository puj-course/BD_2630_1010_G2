# Roles y privilegios — Entrega 2

## Roles creados

Creamos 3 roles. Cada rol agrupa los permisos y después se le asigna a una persona del equipo.

| Rol | Para qué sirve | Asignado a |
|---|---|---|
| `ROL_ADMIN_TORNEO` | Administrador del Torneo: registra y corrige los datos del torneo | Julian (`is101002`) |
| `ROL_ANALISTA_DEPORTIVO` | Analista Deportivo: consulta datos para analizar el torneo | Pablo (`is101010`) |
| `ROL_AUDITOR` | Auditor / Consulta: revisa todo sin modificar nada | Julian (`is101002`) |

Manuel (`is101004`) es el dueño de las tablas, por eso ejecuta el script y no necesita rol.
Como el equipo tiene 3 usuarios y 3 roles, Julian tiene dos roles. Para probar el rol de auditor se usa `SET ROLE ROL_AUDITOR`, que deja activo solo ese rol.

## Qué puede hacer cada rol

`S` = consultar, `I` = insertar, `U` = modificar, `D` = borrar, `—` = sin acceso

| Tablas | Administrador | Analista | Auditor |
|---|---|---|---|
| EDICION_MUNDIAL, CIUDAD_SEDE, ESTADIO, FASE, GRUPO | S I U D | S | S |
| CONFEDERACION, FEDERACION, SELECCION, CUERPO_TECNICO | S I U D | S | S |
| JUGADOR, CONVOCATORIA_JUGADOR | S I U D | S | S |
| PARTIDO, PARTICIPACION_PARTIDO, ESTADISTICA_JUGADOR_PARTIDO, INCIDENCIA | S I U D | S | S |
| ARBITRO, ASIGNACION_ARBITRAL | S I U D | S | S |
| ENTRADA | S I U D | — | S |
| ACREDITACION_PRENSA | S I U D | — | S |
| AUDITORIA_EVENTO | S | — | S |
| Crear / borrar tablas (DDL) | — | — | — |

## Restricciones y por qué

- **Administrador:** puede modificar todo el torneo, pero en `AUDITORIA_EVENTO` solo consulta. Si pudiera borrarla, no serviría como evidencia. Tampoco puede crear ni borrar tablas.
- **Analista:** solo consulta. No ve `ENTRADA` (son ventas, información comercial) ni `ACREDITACION_PRENSA` (datos personales de periodistas) ni la bitácora, porque no los necesita para analizar partidos y jugadores.
- **Auditor:** puede consultar todo, incluidas esas tablas, pero no puede cambiar nada.

## Errores que da Oracle

- `ORA-01031: insufficient privileges` → el usuario sí ve la tabla, pero no tiene permiso para esa operación (por ejemplo, un auditor haciendo `UPDATE`).
- `ORA-00942: table or view does not exist` → el usuario no tiene ningún permiso sobre esa tabla, y Oracle responde como si no existiera.

Las pruebas con cada usuario están en `tests/entrega2/casos_prueba.md`.

