package mundial.conexion;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

// Datos para conectarse a la base de datos Oracle
// La clave se lee de config.properties para no dejarla en el codigo
public class Constantes {

    public static final String THINCONN = "jdbc:oracle:thin:@//orion.javeriana.edu.co:1521/LAB";
    public static final String USERNAME = "IS101004";
    public static final String PASSWORD = leerClave();

    private static String leerClave() {
        Properties props = new Properties();
        try (FileInputStream archivo = new FileInputStream("config.properties")) {
            props.load(archivo);
            return props.getProperty("db.clave");
        } catch (IOException e) {
            System.out.println("No se encontro el archivo config.properties");
            return "";
        }
    }
}