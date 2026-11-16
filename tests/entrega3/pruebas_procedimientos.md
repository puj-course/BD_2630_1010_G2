Pruebas de los procedimientos - Entrega 3

Corrimos sql/entrega3/procedimientos/procedimientos.sql completo en SQL Developer (F5) con el usuario IS101004 y los datos de carga_datos_prueba.sql. Los 4 procedimientos compilaron sin errores y las pruebas del final dieron lo esperado. Al terminar, el script borra los partidos de prueba y la base queda como estaba.


1. Compilacion

Procedure PR_REGISTRAR_RESULTADO compilado
Procedure PR_CARGA_MASIVA_RESULTADOS compilado
Procedure PR_TABLA_POSICIONES compilado
Procedure PR_CIERRE_FASE compilado


2. pr_tabla_posiciones

EXEC pr_tabla_posiciones(1);

Tabla de posiciones - Grupo A
1. Colombia - 5 pts - DG 3
2. Japon - 4 pts - DG 1
3. Mexico - 4 pts - DG 0
4. Marruecos - 3 pts - DG -4

EXEC pr_tabla_posiciones(2);

Tabla de posiciones - Grupo B
1. Argentina - 7 pts - DG 3
2. Espana - 5 pts - DG 2
3. Francia - 2 pts - DG -1
4. Estados Unidos - 1 pts - DG -4

EXEC pr_tabla_posiciones(99);

Error: el grupo 99 no existe


3. pr_registrar_resultado

Se creo un partido de prueba (14, Argentina vs Francia en dieciseisavos) en estado PROGRAMADO.

EXEC pr_registrar_resultado(14, -1, 0);  ->  Error: los goles no pueden ser negativos.
EXEC pr_registrar_resultado(99, 1, 0);   ->  Error: el partido 99 no existe.
EXEC pr_registrar_resultado(14, 2, 1);   ->  Resultado registrado: partido 14 (2 - 1)
EXEC pr_registrar_resultado(14, 3, 0);   ->  Error: el partido 14 ya esta finalizado.

Despues las participaciones quedaron LOCAL 2 G y VISITANTE 1 P.


4. pr_carga_masiva_resultados

El partido 14 se dejo EN_JUEGO y se le cargaron estadisticas: 1 gol para Argentina y 2 para Francia.

EXEC pr_carga_masiva_resultados(2);

Partido 14: 1 - 2
Cargados: 1, sin estadisticas: 0, con error: 0

Las participaciones quedaron LOCAL 1 P y VISITANTE 2 G, o sea que el marcador salio de las estadisticas de los jugadores. Al correrlo otra vez sale "Cargados: 0" porque ya no hay partidos en juego.


5. pr_cierre_fase

EXEC pr_cierre_fase(99);  ->  Error: la fase 99 no existe
EXEC pr_cierre_fase(2);   ->  Error: solo se puede cerrar la fase de grupos

EXEC pr_cierre_fase(1);

Grupo A: el cruce ya estaba programado
Grupo B: se programo el partido 14
Fase cerrada. Partidos nuevos: 1

Al correrlo otra vez los dos grupos salen como "el cruce ya estaba programado" y "Partidos nuevos: 0", o sea que no duplica partidos.

En la fase 2 (dieciseisavos) quedaron el partido 13 Colombia vs Espana (ya existia) y el partido 14 Argentina vs Japon (lo creo el cierre: 1B vs 2A).