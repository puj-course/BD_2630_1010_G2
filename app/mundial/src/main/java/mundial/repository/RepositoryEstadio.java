package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Estadio;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla ESTADIO
public class RepositoryEstadio {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Estadio> consultarEstadios() {
        List<Estadio> estadios = new ArrayList<>();
        String SQL = "select id_estadio, id_ciudad, nombre, capacidad from estadio order by id_estadio";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Estadio e = new Estadio(rs.getInt("ID_ESTADIO"), rs.getInt("ID_CIUDAD"),
                        rs.getString("NOMBRE"), rs.getInt("CAPACIDAD"));
                estadios.add(e);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar estadios:" + ex.toString());
        }
        return estadios;
    }

    // el id se saca con el maximo + 1, igual que en los triggers de auditoria
    public int insertarEstadio(Estadio estadio) {
        StringBuilder SQL = new StringBuilder("insert into estadio (id_estadio, id_ciudad, nombre, capacidad) ");
        SQL.append("values ((select nvl(max(id_estadio), 0) + 1 from estadio), ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, estadio.getIdCiudad());
            ps.setString(2, estadio.getNombre());
            ps.setInt(3, estadio.getCapacidad());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar estadio:" + ex.toString());
            return 0;
        }
    }

    public int actualizarEstadio(Estadio estadio) {
        String SQL = "update estadio set id_ciudad = ?, nombre = ?, capacidad = ? where id_estadio = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, estadio.getIdCiudad());
            ps.setString(2, estadio.getNombre());
            ps.setInt(3, estadio.getCapacidad());
            ps.setInt(4, estadio.getIdEstadio());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar estadio:" + ex.toString());
            return 0;
        }
    }

    public int eliminarEstadio(int idEstadio) {
        String SQL = "delete from estadio where id_estadio = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idEstadio);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar estadio:" + ex.toString());
            return 0;
        }
    }
}