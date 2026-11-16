Aplicacion del Mundial

Es la aplicacion en Java para el proyecto. Esta hecha con Swing y se conecta a la base de Oracle con JDBC.

Para correrla:

1. Abrir la carpeta app/mundial en IntelliJ (es un proyecto Maven, el driver de Oracle se descarga solo).
2. Copiar config.example.properties, ponerle de nombre config.properties y cambiar TU_CLAVE por la clave de la base.
3. Conectarse a la VPN de la universidad.
4. Correr la clase Main.

Si solo se quiere ver si conecta, corran PruebaConexion, que muestra cuantos partidos hay.

La clave no se sube al repo porque config.properties esta en el .gitignore, entonces cada uno tiene que crear el suyo.

Para que funcione el boton de Registrar resultado tiene que estar creado en la base el procedimiento pr_registrar_resultado (sql/entrega3/procedimientos/procedimientos.sql).

Como esta organizado:

- conexion: la clase Constantes con los datos para conectarse
- modelo: las clases de cada tabla y de cada consulta
- repository: los select, insert, update y delete de cada tabla, las consultas y los reportes
- vista: las ventanas

Mas detalle en docs/entrega3/arquitectura_aplicacion.md

Que tiene la aplicacion (menu de la ventana principal):

- Catalogos: ediciones, ciudades sede, estadios, selecciones, grupos, jugadores y cuerpo tecnico
- Partidos: programar partidos, registrar el resultado y las estadisticas de los jugadores
- Consultas: tabla de posiciones, resultados consolidados e incidencias
- Reportes: goleadores, posiciones e incidencias con filtros por fase, grupo y seleccion
