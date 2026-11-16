Aplicacion del Mundial

Es la aplicacion en Java para el proyecto. Esta hecha con Swing y se conecta a la base de Oracle con JDBC.

Para correrla:

1. Abrir la carpeta app/mundial en IntelliJ (es un proyecto Maven, el driver de Oracle se descarga solo).
2. Copiar config.example.properties, ponerle de nombre config.properties y cambiar TU_CLAVE por la clave de la base.
3. Conectarse a la VPN de la universidad.
4. Correr la clase Main.

Si solo se quiere ver si conecta, corran PruebaConexion, que muestra cuantos partidos hay.

La clave no se sube al repo porque config.properties esta en el .gitignore, entonces cada uno tiene que crear el suyo.

Como esta organizado:

- conexion: la clase Constantes con los datos para conectarse
- modelo: las clases de cada tabla (por ahora Estadio)
- repository: los select, insert, update y delete de cada tabla
- vista: las ventanas

Mas detalle en docs/entrega3/arquitectura_aplicacion.md

Ya estan la ventana principal y los catalogos de estadios, selecciones, grupos, jugadores y cuerpo tecnico. Faltan ediciones y ciudades sede, los partidos, las consultas y los reportes.
