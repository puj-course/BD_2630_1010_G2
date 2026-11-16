package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Jugador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas, inserciones, cambios y borrados de la tabla JUGADOR
public class RepositoryJugador {

    private String error = "";

    public String getError() {
        return error;
    }

    public List<Jugador> consultarJugadores() {
        List<Jugador> jugadores = new ArrayList<>();
        String SQL = "select id_jugador, nombres, apellidos, fecha_nacimiento, posicion from jugador order by id_jugador";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Jugador j = new Jugador(rs.getInt("ID_JUGADOR"), rs.getString("NOMBRES"), rs.getString("APELLIDOS"),
                        rs.getDate("FECHA_NACIMIENTO"), rs.getString("POSICION"));
                jugadores.add(j);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar jugadores:" + ex.toString());
        }
        return jugadores;
    }

    public int insertarJugador(Jugador jugador) {
        StringBuilder SQL = new StringBuilder("insert into jugador (id_jugador, nombres, apellidos, fecha_nacimiento, posicion) ");
        SQL.append("values ((select nvl(max(id_jugador), 0) + 1 from jugador), ?, ?, ?, ?)");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString())) {
            ps.setString(1, jugador.getNombres());
            ps.setString(2, jugador.getApellidos());
            ps.setDate(3, jugador.getFechaNacimiento());
            ps.setString(4, jugador.getPosicion());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al insertar jugador:" + ex.toString());
            return 0;
        }
    }

    public int actualizarJugador(Jugador jugador) {
        String SQL = "update jugador set nombres = ?, apellidos = ?, fecha_nacimiento = ?, posicion = ? where id_jugador = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setString(1, jugador.getNombres());
            ps.setString(2, jugador.getApellidos());
            ps.setDate(3, jugador.getFechaNacimiento());
            ps.setString(4, jugador.getPosicion());
            ps.setInt(5, jugador.getIdJugador());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al actualizar jugador:" + ex.toString());
            return 0;
        }
    }

    public int eliminarJugador(int idJugador) {
        String SQL = "delete from jugador where id_jugador = ?";
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            ps.setInt(1, idJugador);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al eliminar jugador:" + ex.toString());
            return 0;
        }
    }
}