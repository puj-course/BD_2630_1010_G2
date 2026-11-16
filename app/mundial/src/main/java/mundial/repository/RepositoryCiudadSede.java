package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.CiudadSede;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla CIUDAD_SEDE
public class RepositoryCiudadSede {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<CiudadSede> consultarCiudades() {
        List<CiudadSede> ciudades = new ArrayList<>();
        String SQL = "select id_ciudad, id_edicion, nombre, pais from ciudad_sede order by id_ciudad";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CiudadSede c = new CiudadSede(rs.getInt("ID_CIUDAD"), rs.getInt("ID_EDICION"),
                        rs.getString("NOMBRE"), rs.getString("PAIS"));
                ciudades.add(c);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar ciudades:" + ex.toString());
        }
        return ciudades;
    }

    public int insertarCiudad(CiudadSede ciudad) {
        StringBuilder SQL = new StringBuilder("insert into ciudad_sede (id_ciudad, id_edicion, nombre, pais) ");
        SQL.append("values ((select nvl(max(id_ciudad), 0) + 1 from ciudad_sede), ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, ciudad.getIdEdicion());
            ps.setString(2, ciudad.getNombre());
            ps.setString(3, ciudad.getPais());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar ciudad:" + ex.toString());
            return 0;
        }
    }

    public int actualizarCiudad(CiudadSede ciudad) {
        String SQL = "update ciudad_sede set id_edicion = ?, nombre = ?, pais = ? where id_ciudad = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, ciudad.getIdEdicion());
            ps.setString(2, ciudad.getNombre());
            ps.setString(3, ciudad.getPais());
            ps.setInt(4, ciudad.getIdCiudad());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar ciudad:" + ex.toString());
            return 0;
        }
    }

    public int eliminarCiudad(int idCiudad) {
        String SQL = "delete from ciudad_sede where id_ciudad = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idCiudad);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar ciudad:" + ex.toString());
            return 0;
        }
    }
}