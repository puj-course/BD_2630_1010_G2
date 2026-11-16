package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.CuerpoTecnico;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla CUERPO_TECNICO
public class RepositoryCuerpoTecnico {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<CuerpoTecnico> consultarMiembros() {
        List<CuerpoTecnico> miembros = new ArrayList<>();
        String SQL = "select id_miembro, id_seleccion, nombres, apellidos, nacionalidad, rol from cuerpo_tecnico order by id_seleccion, id_miembro";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CuerpoTecnico c = new CuerpoTecnico(rs.getInt("ID_MIEMBRO"), rs.getInt("ID_SELECCION"),
                        rs.getString("NOMBRES"), rs.getString("APELLIDOS"),
                        rs.getString("NACIONALIDAD"), rs.getString("ROL"));
                miembros.add(c);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar cuerpo tecnico:" + ex.toString());
        }
        return miembros;
    }

    public int insertarMiembro(CuerpoTecnico miembro) {
        StringBuilder SQL = new StringBuilder("insert into cuerpo_tecnico (id_miembro, id_seleccion, nombres, apellidos, nacionalidad, rol) ");
        SQL.append("values ((select nvl(max(id_miembro), 0) + 1 from cuerpo_tecnico), ?, ?, ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, miembro.getIdSeleccion());
            ps.setString(2, miembro.getNombres());
            ps.setString(3, miembro.getApellidos());
            ps.setString(4, miembro.getNacionalidad());
            ps.setString(5, miembro.getRol());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar miembro:" + ex.toString());
            return 0;
        }
    }

    public int actualizarMiembro(CuerpoTecnico miembro) {
        String SQL = "update cuerpo_tecnico set id_seleccion = ?, nombres = ?, apellidos = ?, nacionalidad = ?, rol = ? where id_miembro = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, miembro.getIdSeleccion());
            ps.setString(2, miembro.getNombres());
            ps.setString(3, miembro.getApellidos());
            ps.setString(4, miembro.getNacionalidad());
            ps.setString(5, miembro.getRol());
            ps.setInt(6, miembro.getIdMiembro());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar miembro:" + ex.toString());
            return 0;
        }
    }

    public int eliminarMiembro(int idMiembro) {
        String SQL = "delete from cuerpo_tecnico where id_miembro = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idMiembro);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar miembro:" + ex.toString());
            return 0;
        }
    }
}