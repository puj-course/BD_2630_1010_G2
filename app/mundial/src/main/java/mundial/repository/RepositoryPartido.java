package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Partido;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

// Consultas de partidos y programacion de partidos nuevos
public class RepositoryPartido {

    private String error = "";

    public String getError() {
        return error;
    }

    // trae cada partido con el pais local y visitante y el marcador
    public List<Partido> consultarPartidos() {
        List<Partido> partidos = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select p.id_partido, p.id_fase, p.id_estadio, p.id_grupo, p.fecha_hora, p.estado, ");
        SQL.append("fl.pais as local, l.goles_marcados as goles_local, fv.pais as visitante, v.goles_marcados as goles_visitante ");
        SQL.append("from partido p ");
        SQL.append("left join participacion_partido l on l.id_partido = p.id_partido and l.condicion = 'LOCAL' ");
        SQL.append("left join seleccion sl on sl.id_seleccion = l.id_seleccion ");
        SQL.append("left join federacion fl on fl.id_federacion = sl.id_federacion ");
        SQL.append("left join participacion_partido v on v.id_partido = p.id_partido and v.condicion = 'VISITANTE' ");
        SQL.append("left join seleccion sv on sv.id_seleccion = v.id_seleccion ");
        SQL.append("left join federacion fv on fv.id_federacion = sv.id_federacion ");
        SQL.append("order by p.fecha_hora");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Integer grupo = rs.getInt("ID_GRUPO");
                if (rs.wasNull()) {
                    grupo = null;
                }
                Partido p = new Partido(rs.getInt("ID_PARTIDO"), rs.getInt("ID_FASE"), rs.getInt("ID_ESTADIO"), grupo,
                        rs.getTimestamp("FECHA_HORA"), rs.getString("ESTADO"), rs.getString("LOCAL"),
                        rs.getString("VISITANTE"), rs.getInt("GOLES_LOCAL"), rs.getInt("GOLES_VISITANTE"));
                partidos.add(p);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar partidos:" + ex.toString());
        }
        return partidos;
    }

    // Programa un partido nuevo: inserta el partido y las dos participaciones.
    // Se hace como una sola transaccion, si algo falla no queda nada guardado.
    public boolean programarPartido(int idFase, int idEstadio, Integer idGrupo, Timestamp fechaHora,
                                    int idLocal, int idVisitante) {
        Connection conex = null;
        try {
            conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
            conex.setAutoCommit(false);

            // id del partido nuevo
            int idPartido = 0;
            try (PreparedStatement ps = conex.prepareStatement("select nvl(max(id_partido), 0) + 1 from partido");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    idPartido = rs.getInt(1);
                }
            }

            String sqlPartido = "insert into partido (id_partido, id_fase, id_estadio, id_grupo, fecha_hora, estado) values (?, ?, ?, ?, ?, 'PROGRAMADO')";
            try (PreparedStatement ps = conex.prepareStatement(sqlPartido)) {
                ps.setInt(1, idPartido);
                ps.setInt(2, idFase);
                ps.setInt(3, idEstadio);
                if (idGrupo == null) {
                    ps.setNull(4, Types.INTEGER);
                } else {
                    ps.setInt(4, idGrupo);
                }
                ps.setTimestamp(5, fechaHora);
                ps.executeUpdate();
            }

            StringBuilder sqlParticipacion = new StringBuilder("insert into participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados) ");
            sqlParticipacion.append("values ((select nvl(max(id_participacion), 0) + 1 from participacion_partido), ?, ?, ?, 0)");
            try (PreparedStatement ps = conex.prepareStatement(sqlParticipacion.toString())) {
                ps.setInt(1, idPartido);
                ps.setInt(2, idLocal);
                ps.setString(3, "LOCAL");
                ps.executeUpdate();

                ps.setInt(1, idPartido);
                ps.setInt(2, idVisitante);
                ps.setString(3, "VISITANTE");
                ps.executeUpdate();
            }

            conex.commit();
            return true;
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al programar partido:" + ex.toString());
            if (conex != null) {
                try {
                    conex.rollback();
                } catch (SQLException e) {
                    System.out.println("Error en el rollback:" + e.toString());
                }
            }
            return false;
        } finally {
            if (conex != null) {
                try {
                    conex.close();
                } catch (SQLException e) {
                    System.out.println("Error al cerrar la conexion:" + e.toString());
                }
            }
        }
    }

    // Registra el resultado llamando al procedimiento pr_registrar_resultado (CallableStatement).
    // El procedimiento si hay un error hace ROLLBACK y lo muestra con DBMS_OUTPUT, entonces desde Java
    // no llega la excepcion. Por eso despues de llamarlo se revisa si el partido quedo FINALIZADO.
    public boolean registrarResultado(int idPartido, int golesLocal, int golesVisitante) {
        try (Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD)) {
            try (CallableStatement cs = conex.prepareCall("{call pr_registrar_resultado(?, ?, ?)}")) {
                cs.setInt(1, idPartido);
                cs.setInt(2, golesLocal);
                cs.setInt(3, golesVisitante);
                cs.execute();
            }

            String estado = "";
            try (PreparedStatement ps = conex.prepareStatement("select estado from partido where id_partido = ?")) {
                ps.setInt(1, idPartido);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        estado = rs.getString("ESTADO");
                    }
                }
            }
            if (estado.equals("FINALIZADO")) {
                return true;
            }
            error = "El procedimiento no finalizo el partido. Revise que los goles de las estadisticas de los jugadores coincidan con el marcador.";
            return false;
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al registrar resultado:" + ex.toString());
            return false;
        }
    }

    // las participaciones y estadisticas se borran solas por el ON DELETE CASCADE
    public int eliminarPartido(int idPartido) {
        String SQL = "delete from partido where id_partido = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idPartido);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar partido:" + ex.toString());
            return 0;
        }
    }
}