package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Estadistica;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

// Estadisticas de los jugadores en un partido
public class RepositoryEstadistica {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Estadistica> consultarPorPartido(int idPartido) {
        List<Estadistica> estadisticas = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select e.id_estadistica, e.id_partido, e.id_convocatoria, ");
        SQL.append("j.nombres || ' ' || j.apellidos || ' (' || f.pais || ')' as jugador, ");
        SQL.append("e.minuto_entrada, e.minuto_salida, e.goles, e.asistencias, e.tarjetas_amarillas, e.tarjeta_roja ");
        SQL.append("from estadistica_jugador_partido e ");
        SQL.append("join convocatoria_jugador c on c.id_convocatoria = e.id_convocatoria ");
        SQL.append("join jugador j on j.id_jugador = c.id_jugador ");
        SQL.append("join seleccion s on s.id_seleccion = c.id_seleccion ");
        SQL.append("join federacion f on f.id_federacion = s.id_federacion ");
        SQL.append("where e.id_partido = ? order by f.pais, j.apellidos");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, idPartido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Integer salida = rs.getInt("MINUTO_SALIDA");
                    if (rs.wasNull()) {
                        salida = null;
                    }
                    Estadistica e = new Estadistica(rs.getInt("ID_ESTADISTICA"), rs.getInt("ID_PARTIDO"),
                            rs.getInt("ID_CONVOCATORIA"), rs.getString("JUGADOR"), rs.getInt("MINUTO_ENTRADA"),
                            salida, rs.getInt("GOLES"), rs.getInt("ASISTENCIAS"),
                            rs.getInt("TARJETAS_AMARILLAS"), rs.getString("TARJETA_ROJA"));
                    estadisticas.add(e);
                }
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar estadisticas:" + ex.toString());
        }
        return estadisticas;
    }

    // jugadores convocados de las dos selecciones que juegan el partido, para la lista desplegable
    // cada uno queda como "id_convocatoria - nombre (pais)"
    public List<String> consultarConvocados(int idPartido) {
        List<String> convocados = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select c.id_convocatoria || ' - ' || j.nombres || ' ' || j.apellidos || ' (' || f.pais || ')' as texto ");
        SQL.append("from participacion_partido pp ");
        SQL.append("join convocatoria_jugador c on c.id_seleccion = pp.id_seleccion ");
        SQL.append("join jugador j on j.id_jugador = c.id_jugador ");
        SQL.append("join seleccion s on s.id_seleccion = c.id_seleccion ");
        SQL.append("join federacion f on f.id_federacion = s.id_federacion ");
        SQL.append("where pp.id_partido = ? order by f.pais, c.dorsal");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, idPartido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    convocados.add(rs.getString("TEXTO"));
                }
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar convocados:" + ex.toString());
        }
        return convocados;
    }

    public int insertarEstadistica(Estadistica e) {
        StringBuilder SQL = new StringBuilder("insert into estadistica_jugador_partido (id_estadistica, id_partido, id_convocatoria, ");
        SQL.append("minuto_entrada, minuto_salida, goles, asistencias, tarjetas_amarillas, tarjeta_roja) ");
        SQL.append("values ((select nvl(max(id_estadistica), 0) + 1 from estadistica_jugador_partido), ?, ?, ?, ?, ?, ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, e.getIdPartido());
            ps.setInt(2, e.getIdConvocatoria());
            ps.setInt(3, e.getMinutoEntrada());
            if (e.getMinutoSalida() == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, e.getMinutoSalida());
            }
            ps.setInt(5, e.getGoles());
            ps.setInt(6, e.getAsistencias());
            ps.setInt(7, e.getAmarillas());
            ps.setString(8, e.getRoja());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar estadistica:" + ex.toString());
            return 0;
        }
    }

    public int actualizarEstadistica(Estadistica e) {
        StringBuilder SQL = new StringBuilder("update estadistica_jugador_partido set id_convocatoria = ?, minuto_entrada = ?, ");
        SQL.append("minuto_salida = ?, goles = ?, asistencias = ?, tarjetas_amarillas = ?, tarjeta_roja = ? where id_estadistica = ?");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setInt(1, e.getIdConvocatoria());
            ps.setInt(2, e.getMinutoEntrada());
            if (e.getMinutoSalida() == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, e.getMinutoSalida());
            }
            ps.setInt(4, e.getGoles());
            ps.setInt(5, e.getAsistencias());
            ps.setInt(6, e.getAmarillas());
            ps.setString(7, e.getRoja());
            ps.setInt(8, e.getIdEstadistica());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar estadistica:" + ex.toString());
            return 0;
        }
    }

    public int eliminarEstadistica(int idEstadistica) {
        String SQL = "delete from estadistica_jugador_partido where id_estadistica = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idEstadistica);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar estadistica:" + ex.toString());
            return 0;
        }
    }
}
