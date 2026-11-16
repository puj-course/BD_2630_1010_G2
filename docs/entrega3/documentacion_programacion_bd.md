Documentacion de la programacion en base de datos - Entrega 3

En este documento explicamos las funciones, procedimientos y triggers que hicimos en la Entrega 3, segun la seccion 8.3.1 del enunciado. Para cada uno ponemos para que sirve, que recibe y que hace.

Los archivos estan en funciones.sql, procedimientos.sql y triggers.sql.

Las pruebas de los triggers estan en pruebas_triggers.md.

1. Funciones

El enunciado pide funciones para calcular la diferencia de gol, el ranking de goleadores y validaciones logicas. Hicimos 5.

# fn_diferencia_gol

el primero sirve para calcular la diferencia de gol de una seleccion (goles a favor menos goles en contra).

Recibe p_id_seleccion (id de la seleccion).

Suma los goles que hizo la seleccion en participacion_partido. Despues busca al rival de cada partido (la otra fila del mismo partido) y suma sus goles. Devuelve la resta. Si la seleccion no ha jugado devuelve 0.

Por ejemplo, fn_diferencia_gol(2) devuelve 3 (Colombia hizo 7 goles y le hicieron 4).

# fn_puntos_seleccion

este sirve para calcular los puntos de una seleccion en la fase de grupos. Se usa junto con la diferencia de gol para ordenar la tabla de posiciones.

Recibe p_id_seleccion (id de la seleccion).

Toma los partidos de grupos que ya estan FINALIZADO y convierte cada resultado en puntos con un CASE (G = 3, E = 1, P = 0). Devuelve la suma. Los partidos de eliminacion directa no cuentan.

Por ejemplo, fn_puntos_seleccion(2) devuelve 5 (Colombia empato, gano y empato en grupos).

# fn_goles_jugador_edicion

En el tercero, la usamos para saber cuantos goles hizo un jugador en un Mundial. Es la base del ranking de goleadores.

Recibe p_id_jugador (id del jugador) y p_id_edicion (id de la edicion del Mundial).

Suma los goles de estadistica_jugador_partido haciendo el camino estadistica, convocatoria y seleccion, para poder filtrar por jugador y por edicion. Si no tiene goles devuelve 0.

Por ejemplo, fn_goles_jugador_edicion(6, 1) devuelve 6 (Juan Pablo Cardenas en 2026).

# fn_puesto_goleador

este sirve para saber en que puesto va un jugador en el ranking de goleadores de una edicion.

Recibe p_id_jugador (id del jugador) y p_id_edicion (id de la edicion del Mundial).

Saca los goles del jugador con fn_goles_jugador_edicion. Si tiene 0 goles devuelve NULL porque no entra al ranking. Si tiene goles, cuenta cuantos jugadores tienen mas goles que el y le suma 1. Si dos jugadores tienen los mismos goles quedan en el mismo puesto.

Por ejemplo, fn_puesto_goleador(6, 1) devuelve 1 y fn_puesto_goleador(3, 1) devuelve 6.

# fn_cupo_disponible

finalmente, la funcion de cupo disponible sirve para validar el cupo maximo de convocatoria (es el ejemplo de validacion logica del enunciado).

Recibe p_id_seleccion (id de la seleccion).

Busca el cupo_convocatoria de la edicion en la que juega la seleccion y le resta cuantos jugadores tiene convocados. Si la seleccion no existe, atrapa el error NO_DATA_FOUND y devuelve NULL.

Por ejemplo, fn_cupo_disponible(1) devuelve 23 (Mexico tiene 3 convocados de 26). fn_cupo_disponible(999) devuelve NULL.


2. Procedimientos

El enunciado pide procedimientos para la carga masiva controlada de resultados, la actualizacion de la tabla de posiciones por grupo y el cierre de fase.

# pr_registrar_resultado

Sirve para registrar el resultado de un partido de forma controlada.

Recibe p_id_partido (id del partido), p_goles_local (goles del equipo local) y p_goles_visitante (goles del equipo visitante).

Lo que hace es:

1. Revisa que los goles no sean negativos.
2. Revisa que el partido exista y que no este ya FINALIZADO.
3. Calcula el resultado de cada seleccion (G, E o P).
4. Actualiza los goles y el resultado del local y del visitante en participacion_partido.
5. Pone el partido en FINALIZADO y hace COMMIT.

Si algo falla hace ROLLBACK y muestra un mensaje con DBMS_OUTPUT (goles negativos, partido finalizado, partido sin local o visitante, partido que no existe u otro error).

Por ejemplo, EXEC pr_registrar_resultado(14, 2, 1) registra que el partido 14 termino 2 a 1.

# pr_carga_masiva_resultados

Sirve para cerrar de una vez todos los partidos de una fase que ya se jugaron pero no tienen resultado oficial.

Recibe p_id_fase (id de la fase).

Recorre con un cursor los partidos de la fase que estan EN_JUEGO. Para cada uno suma los goles de las estadisticas de los jugadores de cada seleccion, con eso pone el marcador y el resultado (G, E o P) y deja el partido FINALIZADO. Los partidos sin estadisticas no se cargan. Cada partido tiene su SAVEPOINT, entonces si uno falla solo se deshace ese y los demas siguen. Al final hace COMMIT y muestra cuantos se cargaron.

Por ejemplo, EXEC pr_carga_masiva_resultados(2) cierra los partidos en juego de dieciseisavos.

# pr_tabla_posiciones

Sirve para ver la tabla de posiciones de un grupo.

Recibe p_id_grupo (id del grupo).

Recorre con un cursor las selecciones del grupo ordenadas por puntos y diferencia de gol, usando fn_puntos_seleccion y fn_diferencia_gol, y muestra el puesto, los puntos y la diferencia de gol de cada una. Como usa las funciones, siempre sale actualizada con los resultados que haya. Si el grupo no existe muestra un error.

Por ejemplo, EXEC pr_tabla_posiciones(1) muestra el grupo A: Colombia 5 pts, Japon 4, Mexico 4 y Marruecos 3.

# pr_cierre_fase

Sirve para cerrar la fase de grupos y hacer avanzar a los clasificados.

Recibe p_id_fase (id de la fase).

Revisa que sea la fase de grupos y que todos sus partidos esten FINALIZADO. Despues, por cada grupo, toma al primero y al segundo del grupo pareja (A con B, C con D...) y programa el partido de la siguiente fase (1A vs 2B, 1B vs 2A). Si ese cruce ya existe no lo duplica. Al final hace COMMIT y muestra cuantos partidos creo.

Por ejemplo, EXEC pr_cierre_fase(1) programa Argentina vs Japon en dieciseisavos (Colombia vs Espana ya estaba).


3. Triggers

El enunciado pide 4 triggers obligatorios: auditoria, validacion de rangos, anti-duplicidad y consistencia del marcador. Algunos se hicieron en dos triggers porque cubren dos tablas.

# Auditoria: trg_auditoria_partido y trg_auditoria_estadistica

el primero sirve para guardar en auditoria_evento cada cambio que se hace en los partidos y en las estadisticas de los jugadores.

Se dispara con AFTER INSERT, UPDATE o DELETE sobre partido y sobre estadistica_jugador_partido, una vez por cada fila (FOR EACH ROW).

Con INSERTING, UPDATING y DELETING sabe que operacion se hizo. Guarda la tabla, la operacion, el id de la fila, el usuario (USER), la fecha (SYSDATE) y el valor de antes (:OLD) y de despues (:NEW). En partido guarda el estado y en estadisticas los goles y asistencias. Es AFTER porque solo se registra el cambio cuando ya se hizo.

# Validacion de rangos: trg_validar_rangos y trg_validar_rangos_marcador

El segundo sirve para no dejar guardar goles ni asistencias negativas.

Se dispara con BEFORE INSERT o UPDATE sobre estadistica_jugador_partido y sobre participacion_partido.

Si :NEW.goles o :NEW.asistencias son menores que 0 lanza RAISE_APPLICATION_ERROR (-20001 y -20002) y el cambio no se guarda. En participacion_partido revisa goles_marcados y goles_penales (-20003). Aunque el DDL ya tiene CHECK para esto, el trigger se pide en el enunciado y muestra un mensaje mas claro.

# Anti-duplicidad: trg_participacion_duplicada

Este se usa para evitar participaciones duplicadas en un partido.

Se dispara con BEFORE INSERT sobre participacion_partido.

Antes de insertar revisa dos cosas. Si la seleccion ya esta en ese partido lanza el error -20004. Si el partido ya tiene dos selecciones lanza el error -20005.

# Consistencia del marcador: trg_consistencia_marcador

Finalmente, el cuarto sirve para que el marcador oficial de cada seleccion sea igual a la suma de goles de sus jugadores.

Se dispara con BEFORE UPDATE OF estado sobre partido, solo cuando el estado nuevo es FINALIZADO (WHEN).

Si el partido tiene estadisticas cargadas, recorre con un cursor las dos selecciones del partido. Para cada una suma los goles de sus jugadores y los compara con goles_marcados. Si no coinciden lanza el error -20006 y el partido no se puede finalizar. Si el partido no tiene estadisticas todavia, lo deja pasar.


4. Codigos de error de los triggers

-20001 en trg_validar_rangos: Los goles no pueden ser negativos
-20002 en trg_validar_rangos: Las asistencias no pueden ser negativas
-20003 en trg_validar_rangos_marcador: El marcador no puede tener goles negativos
-20004 en trg_participacion_duplicada: Esa seleccion ya esta registrada en este partido
-20005 en trg_participacion_duplicada: El partido ya tiene sus dos selecciones
-20006 en trg_consistencia_marcador: El marcador de la seleccion no coincide con los goles de sus jugadores
