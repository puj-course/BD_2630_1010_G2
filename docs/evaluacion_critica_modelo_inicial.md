Evaluación Crítica del Modelo Inicial — Entrega 1

Sección de carácter puramente analítico (Sección 8.1.8 del enunciado): no se implementa en esta entrega. Su resultado será revisado y discutido durante la sustentación, con el propósito de que el equipo reciba retroalimentación antes de iniciar la Entrega 2.

1. Problemas identificados en el modelo genérico inicial

1. El atributo fase se modela como texto libre en PARTIDO: al tratarse de un campo VARCHAR2 sin restricción de valores ni entidad propia, no existe garantía de que todos los partidos empleen exactamente la misma denominación para cada fase (por ejemplo, Semifinal frente a Semi Final), ni resulta posible modelar el orden o la estructura de las fases eliminatorias (qué fase sucede a cuál, cuántas selecciones avanzan).

2. Ausencia de manejo de grupos y fases eliminatorias: el modelo no contempla mecanismo alguno para agrupar selecciones (Grupo A, Grupo B, entre otros) ni para registrar el cruce de eliminación directa (octavos, cuartos, etc.) junto con sus llaves de avance. Esto impide, por ejemplo, calcular de manera automática una tabla de posiciones por grupo, restringiendo el cálculo a la edición completa, como ocurre en la Vista 1 de esta entrega.

3. Inexistencia de registro de goleadores individuales: la tabla PARTICIPACION_PARTIDO únicamente almacena el total de goles de la selección en el partido, sin identificar al autor de cada uno. En consecuencia, no es posible responder preguntas a nivel de jugador (goleador del torneo, minutos jugados, tarjetas), dado que el modelo inicial no contempla la entidad JUGADOR.

4. Asistencia de estadios fuera del alcance del modelo original: como se documenta en la Sección 2 del documento técnico (supuesto 2), el modelo inicial no contempla atributo alguno de asistencia o aforo real por partido, lo cual requirió incorporar la tabla auxiliar ASISTENCIA_PARTIDO en esta entrega.

5. Ausencia de control de auditoría y trazabilidad de cambios: en caso de que el marcador de un partido sea corregido con posterioridad a su registro, el modelo actual no conserva evidencia de quién realizó el cambio ni en qué momento, aspecto relevante para un sistema que contará con múltiples usuarios operativos, conforme a sql/roles/roles_privilegios.sql.

6. El atributo confederacion se modela como texto libre en SELECCION: al no constituir una entidad propia, es posible que distintos registros representen la misma confederación de formas diferentes (UEFA, Uefa, Europa), lo cual dificulta la correcta agrupación por confederación en reportes futuros.

2. Ajustes propuestos por el equipo

Problema: fase como texto libre.
Ajuste propuesto: crear la entidad FASE (identificador, nombre, orden, cantidad de clasificados) y convertir el atributo fase de PARTIDO en una llave foránea hacia FASE.
Justificación: resuelve un problema de integridad, al evitar valores inconsistentes, y un problema de negocio, al permitir ordenar y automatizar el avance de fases.

Problema: ausencia de grupos.
Ajuste propuesto: crear la entidad GRUPO (identificador, nombre, edición) y una tabla asociativa SELECCION_GRUPO.
Justificación: resuelve un problema de negocio, al permitir calcular la tabla de posiciones por grupo y no únicamente por edición completa.

Problema: ausencia de goleadores individuales.
Ajuste propuesto: crear las entidades JUGADOR y GOL (o EVENTO_PARTIDO), relacionando cada gol con un jugador, un partido y un instante.
Justificación: resuelve un problema de normalización, al evitar mezclar el total agregado con el detalle, y habilita las consultas de goleadores individuales exigidas en la Entrega 2.

Problema: ausencia de control de auditoría.
Ajuste propuesto: crear la entidad AUDITORIA_EVENTO (usuario, tabla afectada, operación, fecha).
Justificación: resuelve un problema de trazabilidad, requerido explícitamente para los triggers de la Entrega Final (Sección 8.3.1).

Problema: confederacion como texto libre.
Ajuste propuesto: crear la entidad CONFEDERACION (identificador, nombre) y convertir el atributo en llave foránea.
Justificación: resuelve un problema de integridad, al evitar duplicados por escritura inconsistente, y facilita la agrupación y el filtrado por confederación.

3. Boceto conceptual del modelo ampliado

Véase boceto_modelo_ampliado.png.

A continuación se listan las nuevas entidades que el equipo anticipa incorporar en la Entrega 2, sin llegar todavía al detalle de atributos, tipos de dato ni restricciones, conforme a lo indicado en el enunciado:

FASE
GRUPO (entidad asociativa SELECCION_GRUPO entre SELECCION y GRUPO)
JUGADOR
GOL o EVENTO_PARTIDO
AUDITORIA_EVENTO
CONFEDERACION

Dichas entidades se especificarán de manera completa (atributos, tipos de dato, restricciones) en la Entrega 2, conforme a lo indicado en la Sección 8.2.2 del enunciado.