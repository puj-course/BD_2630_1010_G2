package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Edicion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla EDICION_MUNDIAL
public class RepositoryEdicion {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Edicion> consultarEdiciones() {
        List<Edicion> ediciones = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select id_edicion, anio, nombre_oficial, lema, fecha_inicio, fecha_fin, ");
        SQL.append("cupo_convocatoria, num_selecciones from edicion_mundial order by anio");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Edicion e = new Edicion(rs.getInt("ID_EDICION"), rs.getInt("ANIO"), rs.getString("NOMBRE_OFICIAL"),
                        rs.getString("LEMA"), rs.getDate("FECHA_INICIO"), rs.getDate("FECHA_FIN"),
                        rs.getInt("CUPO_CONVOCATORIA"), rs.getInt("NUM_SELECCIONES"));
                ediciones.add(e);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar ediciones:" + ex.toString());
        }
        return ediciones;
    }

    public int insertarEdicion(Edicion edicion) {
        StringBuilder SQL = new StringBuilder("insert into edicion_mundial (id_edicion, anio, nombre_oficial, lema, ");
        SQL.append("fecha_inicio, fecha_fin, cupo_convocatoria, num_selecciones) ");
        SQL.append("values ((select nvl(max(id_edicion), 0) + 1 from edicion_mundial), ?, ?, ?, ?, ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, edicion.getAnio());
            ps.setString(2, edicion.getNombreOficial());
            ps.setString(3, edicion.getLema());
            ps.setDate(4, edicion.getFechaInicio());
            ps.setDate(5, edicion.getFechaFin());
            ps.setInt(6, edicion.getCupoConvocatoria());
            ps.setInt(7, edicion.getNumSelecciones());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar edicion:" + ex.toString());
            return 0;
        }
    }

    public int actualizarEdicion(Edicion edicion) {
        StringBuilder SQL = new StringBuilder("update edicion_mundial set anio = ?, nombre_oficial = ?, lema = ?, ");
        SQL.append("fecha_inicio = ?, fecha_fin = ?, cupo_convocatoria = ?, num_selecciones = ? where id_edicion = ?");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, edicion.getAnio());
            ps.setString(2, edicion.getNombreOficial());
            ps.setString(3, edicion.getLema());
            ps.setDate(4, edicion.getFechaInicio());
            ps.setDate(5, edicion.getFechaFin());
            ps.setInt(6, edicion.getCupoConvocatoria());
            ps.setInt(7, edicion.getNumSelecciones());
            ps.setInt(8, edicion.getIdEdicion());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar edicion:" + ex.toString());
            return 0;
        }
    }

    public int eliminarEdicion(int idEdicion) {
        String SQL = "delete from edicion_mundial where id_edicion = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idEdicion);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar edicion:" + ex.toString());
            return 0;
        }
    }
}