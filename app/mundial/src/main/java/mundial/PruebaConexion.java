package mundial;

import mundial.conexion.Constantes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Prueba para ver si la app se conecta a la base
public class PruebaConexion {

    public static void main(String[] args) {
        String SQL = "select count(*) as total from partido";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery();) {
            if (rs.next()) {
                System.out.println("Conexion exitosa. Partidos en la base: " + rs.getInt("TOTAL"));
            }
        } catch (SQLException ex) {
            System.out.println("Error de conexion:" + ex.toString());
        }
    }
}