package mundial.repository;

import mundial.conexion.Constantes;
import mundial.modelo.Incidencia;
import mundial.modelo.Posicion;
import mundial.modelo.Resultado;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Consultas de la aplicacion: tabla de posiciones, resultados e incidencias
public class RepositoryConsultas {

    private String error = "";

    public String getError() {
        return error;
    }

    // Tabla de posiciones de todos los grupos.
    // Solo cuentan los partidos de grupos que ya estan FINALIZADO.
    // r es la participacion del rival, de ahi salen los goles en contra.
    public List<Posicion> consultarPosiciones() {
        List<Posicion> posiciones = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select g.nombre as grupo, f.pais as seleccion, ");
        SQL.append("count(pa.id_participacion) as pj, ");
        SQL.append("sum(case when pa.resultado = 'G' then 1 else 0 end) as pg, ");
        SQL.append("sum(case when pa.resultado = 'E' then 1 else 0 end) as pe, ");
        SQL.append("sum(case when pa.resultado = 'P' then 1 else 0 end) as pp, ");
        SQL.append("nvl(sum(pa.goles_marcados), 0) as gf, ");
        SQL.append("nvl(sum(r.goles_marcados), 0) as gc, ");
        SQL.append("nvl(sum(pa.goles_marcados), 0) - nvl(sum(r.goles_marcados), 0) as dg, ");
        SQL.append("sum(case when pa.resultado = 'G' then 3 when pa.resultado = 'E' then 1 else 0 end) as pts ");
        SQL.append("from seleccion s ");
        SQL.append("join grupo g on g.id_grupo = s.id_grupo ");
        SQL.append("join federacion f on f.id_federacion = s.id_federacion ");
        SQL.append("left join (select x.* from participacion_partido x join partido p on p.id_partido = x.id_partido ");
        SQL.append("where p.id_grupo is not null and p.estado = 'FINALIZADO') pa on pa.id_seleccion = s.id_seleccion ");
        SQL.append("left join participacion_partido r on r.id_partido = pa.id_partido and r.id_seleccion <> pa.id_seleccion ");
        SQL.append("group by g.nombre, f.pais ");
        SQL.append("order by g.nombre, pts desc, dg desc, gf desc");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Posicion p = new Posicion(rs.getString("GRUPO"), rs.getString("SELECCION"), rs.getInt("PJ"),
                        rs.getInt("PG"), rs.getInt("PE"), rs.getInt("PP"), rs.getInt("GF"), rs.getInt("GC"),
                        rs.getInt("DG"), rs.getInt("PTS"));
                posiciones.add(p);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar posiciones:" + ex.toString());
        }
        return posiciones;
    }

    // Todos los partidos finalizados con su marcador, fase, grupo y estadio
    public List<Resultado> consultarResultados() {
        List<Resultado> resultados = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select p.id_partido, p.fecha_hora, fa.nombre as fase, g.nombre as grupo, e.nombre as estadio, ");
        SQL.append("fl.pais as local, l.goles_marcados as goles_local, fv.pais as visitante, v.goles_marcados as goles_visitante, ");
        SQL.append("l.goles_penales as penales_local, v.goles_penales as penales_visitante ");
        SQL.append("from partido p ");
        SQL.append("join fase fa on fa.id_fase = p.id_fase ");
        SQL.append("left join grupo g on g.id_grupo = p.id_grupo ");
        SQL.append("join estadio e on e.id_estadio = p.id_estadio ");
        SQL.append("join participacion_partido l on l.id_partido = p.id_partido and l.condicion = 'LOCAL' ");
        SQL.append("join seleccion sl on sl.id_seleccion = l.id_seleccion ");
        SQL.append("join federacion fl on fl.id_federacion = sl.id_federacion ");
        SQL.append("join participacion_partido v on v.id_partido = p.id_partido and v.condicion = 'VISITANTE' ");
        SQL.append("join seleccion sv on sv.id_seleccion = v.id_seleccion ");
        SQL.append("join federacion fv on fv.id_federacion = sv.id_federacion ");
        SQL.append("where p.estado = 'FINALIZADO' ");
        SQL.append("order by p.fecha_hora");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Integer penLocal = rs.getInt("PENALES_LOCAL");
                if (rs.wasNull()) {
                    penLocal = null;
                }
                Integer penVisitante = rs.getInt("PENALES_VISITANTE");
                if (rs.wasNull()) {
                    penVisitante = null;
                }
                Resultado r = new Resultado(rs.getInt("ID_PARTIDO"), rs.getTimestamp("FECHA_HORA"), rs.getString("FASE"),
                        rs.getString("GRUPO"), rs.getString("ESTADIO"), rs.getString("LOCAL"), rs.getInt("GOLES_LOCAL"),
                        rs.getString("VISITANTE"), rs.getInt("GOLES_VISITANTE"), penLocal, penVisitante);
                resultados.add(r);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar resultados:" + ex.toString());
        }
        return resultados;
    }

    // Incidencias de todos los partidos (lesiones, interrupciones, seguridad, etc.)
    public List<Incidencia> consultarIncidencias() {
        List<Incidencia> incidencias = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select i.id_incidencia, p.fecha_hora, fl.pais || ' vs ' || fv.pais as partido, ");
        SQL.append("i.minuto, i.tipo, i.gravedad, i.descripcion ");
        SQL.append("from incidencia i ");
        SQL.append("join partido p on p.id_partido = i.id_partido ");
        SQL.append("join participacion_partido l on l.id_partido = p.id_partido and l.condicion = 'LOCAL' ");
        SQL.append("join seleccion sl on sl.id_seleccion = l.id_seleccion ");
        SQL.append("join federacion fl on fl.id_federacion = sl.id_federacion ");
        SQL.append("join participacion_partido v on v.id_partido = p.id_partido and v.condicion = 'VISITANTE' ");
        SQL.append("join seleccion sv on sv.id_seleccion = v.id_seleccion ");
        SQL.append("join federacion fv on fv.id_federacion = sv.id_federacion ");
        SQL.append("order by p.fecha_hora, i.minuto");
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Incidencia i = new Incidencia(rs.getInt("ID_INCIDENCIA"), rs.getTimestamp("FECHA_HORA"),
                        rs.getString("PARTIDO"), rs.getInt("MINUTO"), rs.getString("TIPO"),
                        rs.getString("GRAVEDAD"), rs.getString("DESCRIPCION"));
                incidencias.add(i);
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar incidencias:" + ex.toString());
        }
        return incidencias;
    }
}