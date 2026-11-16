package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Grupo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla GRUPO
public class RepositoryGrupo {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Grupo> consultarGrupos() {
        List<Grupo> grupos = new ArrayList<>();
        String SQL = "select id_grupo, id_fase, nombre from grupo order by id_fase, nombre";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Grupo g = new Grupo(rs.getInt("ID_GRUPO"), rs.getInt("ID_FASE"), rs.getString("NOMBRE"));
                grupos.add(g);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar grupos:" + ex.toString());
        }
        return grupos;
    }

    public int insertarGrupo(Grupo grupo) {
        StringBuilder SQL = new StringBuilder("insert into grupo (id_grupo, id_fase, nombre) ");
        SQL.append("values ((select nvl(max(id_grupo), 0) + 1 from grupo), ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, grupo.getIdFase());
            ps.setString(2, grupo.getNombre());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar grupo:" + ex.toString());
            return 0;
        }
    }

    public int actualizarGrupo(Grupo grupo) {
        String SQL = "update grupo set id_fase = ?, nombre = ? where id_grupo = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, grupo.getIdFase());
            ps.setString(2, grupo.getNombre());
            ps.setInt(3, grupo.getIdGrupo());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar grupo:" + ex.toString());
            return 0;
        }
    }

    public int eliminarGrupo(int idGrupo) {
        String SQL = "delete from grupo where id_grupo = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idGrupo);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar grupo:" + ex.toString());
            return 0;
        }
    }
}