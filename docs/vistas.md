Vistas — Entrega 1 (Modelo Inicial)

El presente documento justifica el propósito de cada una de las vistas implementadas, construidas sobre el Modelo Genérico Inicial de cinco entidades y sobre el esquema de referencia compartido del curso..

Apuntes sobre la ocupación de estadios: las tablas MORENOLUIS.FIFA_ESTADIO y MORENOLUIS.FIFA_PARTIDO no incorporan ningún atributo de asistencia o aforo, y al ser de solo lectura no es posible agregarles una columna. Para la Vista 3 (VW_OCUPACION_ESTADIO), se incorpora, en su propio esquema, una tabla auxiliar:

CREATE TABLE ASISTENCIA_PARTIDO (
    id_partido       NUMBER PRIMARY KEY,
    asistencia_real  NUMBER
);


1. VW_TABLA_POSICIONES_PARCIAL

Columnas: id_edicion, pais, partidos_jugados, partidos_ganados, partidos_empatados, partidos_perdidos, goles_favor, goles_contra, diferencia_gol, puntos.

su proposito es calcular, para cada selección dentro de cada edición, la tabla de posiciones parcial completa, sin omitir ninguna de las columnas propias de una tabla de posiciones convencional, con los puntos calculados conforme al criterio 3-1-0 (victoria: 3 puntos; empate: 1 punto; derrota: 0 puntos).

Este cálculo requiere cruzar cada participación con la de su rival en el mismo partido, mediante un autojoin sobre MORENOLUIS.FIFA_PARTICIPACION_PARTIDO, y clasificar el resultado (victoria, empate o derrota) mediante una expresión CASE. Se trata de una consulta que se reutiliza en distintos análisis del proyecto (Consulta 15, reportes de seguimiento del torneo), por lo cual resulta conveniente encapsularla en una vista en lugar de repetir la lógica en cada ocasión. Se emplean nombres de columna completos, sin abreviar, con el fin de que cualquier consulta o reporte que reutilice esta vista resulte legible y consistente en todo el equipo.

2. VW_GOLEADORES_ACUMULADOS

su proposito, es exponer el total de goles marcados por cada selección en cada edición.

Justificación: simplifica la lógica requerida por cualquier consulta o reporte que necesite el total de goles por selección (por ejemplo, un ranking de goleadores por edición), evitando repetir la junta entre MORENOLUIS.FIFA_SELECCION y MORENOLUIS.FIFA_PARTICIPACION_PARTIDO junto con su respectiva agregación.

3. VW_OCUPACION_ESTADIO

Su proposito, es calcular el porcentaje de ocupación estimado de cada estadio (asistencia_real / capacidad × 100, promediado sobre los partidos disputados en él), a partir de la tabla propia ASISTENCIA_PARTIDO descrita anteriormente.

Justificación: restringe el conjunto de columnas visibles a lo estrictamente necesario para un usuario de negocio (nombre del estadio, ciudad, capacidad, partidos jugados y porcentaje de ocupación), sin exponer directamente las tablas base ni obligar a recalcular la fórmula de ocupación en cada consulta que la requiera.

4. VW_PARTIDOS_MARCADOR_SEDE

Su proposito, es presentar cada partido junto con su marcador (selección local, selección visitante y goles de cada una) y su sede (estadio y ciudad), en una única fila por partido.

Justificación: simplifica de manera considerable la lógica requerida por cualquier usuario o aplicación que únicamente necesite consultar resultados de partidos, evitando que este deba conocer y unir manualmente las tablas MORENOLUIS.FIFA_PARTIDO, FIFA_ESTADIO, FIFA_EDICION_MUNDIAL, FIFA_PARTICIPACION_PARTIDO y FIFA_SELECCION.

5. VW_DIFERENCIA_GOL_SELECCION

Su proposito, es calcular, para cada selección de cada edición, los goles a favor, los goles en contra y la diferencia de gol acumulada a lo largo de sus partidos.

Justificación: esta lógica (autojoin de MORENOLUIS.FIFA_PARTICIPACION_PARTIDO contra el rival correspondiente en el mismo partido) se reutiliza en la Consulta 3 y en la Consulta 11; encapsularla en una vista evita duplicar el cálculo y facilita su mantenimiento consistente ante eventuales cambios en la definición de "diferencia de gol".

La totalidad de las vistas se crea en el esquema propio de cada estudiante (mediante CREATE VIEW, para lo cual basta con el privilegio SELECT sobre MORENOLUIS.FIFA_*, ya otorgado por el curso), consultando los datos del esquema de referencia compartido, con excepción de la tabla auxiliar ASISTENCIA_PARTIDO, que sí reside en el esquema propio.