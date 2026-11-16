package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Seleccion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla SELECCION
public class RepositorySeleccion {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Seleccion> consultarSelecciones() {
        List<Seleccion> selecciones = new ArrayList<>();
        String SQL = "select id_seleccion, id_edicion, id_federacion, id_grupo, ranking_fifa from seleccion order by id_seleccion";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // getInt devuelve 0 si es null, por eso se revisa con wasNull
                Integer grupo = rs.getInt("ID_GRUPO");
                if (rs.wasNull()) {
                    grupo = null;
                }
                Integer ranking = rs.getInt("RANKING_FIFA");
                if (rs.wasNull()) {
                    ranking = null;
                }
                Seleccion s = new Seleccion(rs.getInt("ID_SELECCION"), rs.getInt("ID_EDICION"),
                        rs.getInt("ID_FEDERACION"), grupo, ranking);
                selecciones.add(s);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar selecciones:" + ex.toString());
        }
        return selecciones;
    }

    public int insertarSeleccion(Seleccion seleccion) {
        StringBuilder SQL = new StringBuilder("insert into seleccion (id_seleccion, id_edicion, id_federacion, id_grupo, ranking_fifa) ");
        SQL.append("values ((select nvl(max(id_seleccion), 0) + 1 from seleccion), ?, ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, seleccion.getIdEdicion());
            ps.setInt(2, seleccion.getIdFederacion());
            if (seleccion.getIdGrupo() == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, seleccion.getIdGrupo());
            }
            if (seleccion.getRankingFifa() == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, seleccion.getRankingFifa());
            }
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar seleccion:" + ex.toString());
            return 0;
        }
    }

    public int actualizarSeleccion(Seleccion seleccion) {
        String SQL = "update seleccion set id_edicion = ?, id_federacion = ?, id_grupo = ?, ranking_fifa = ? where id_seleccion = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, seleccion.getIdEdicion());
            ps.setInt(2, seleccion.getIdFederacion());
            if (seleccion.getIdGrupo() == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, seleccion.getIdGrupo());
            }
            if (seleccion.getRankingFifa() == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, seleccion.getRankingFifa());
            }
            ps.setInt(5, seleccion.getIdSeleccion());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar seleccion:" + ex.toString());
            return 0;
        }
    }

    public int eliminarSeleccion(int idSeleccion) {
        String SQL = "delete from seleccion where id_seleccion = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idSeleccion);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar seleccion:" + ex.toString());
            return 0;
        }
    }
}