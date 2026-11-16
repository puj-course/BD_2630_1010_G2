package mundial.repository;

import mundial.conexion.Constantes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Reportes con filtros por fase, grupo y seleccion.
// Cada filtro puede venir en null, y en ese caso no se usa.
// El where se arma con StringBuilder agregando solo los filtros que llegan (como en la clase de JDBC).
public class RepositoryReportes {

    private String error = "";

    public String getError() {
        return error;
    }

    public void limpiarError() {
        error = "";
    }

    // ---------- opciones para las listas desplegables ----------

    public List<String> consultarFases() {
        return consultarOpciones("select id_fase || ' - ' || nombre as texto from fase order by orden");
    }

    public List<String> consultarGrupos() {
        return consultarOpciones("select id_grupo || ' - Grupo ' || nombre as texto from grupo order by nombre");
    }

    public List<String> consultarSelecciones() {
        return consultarOpciones("select s.id_seleccion || ' - ' || f.pais as texto from seleccion s join federacion f on f.id_federacion = s.id_federacion order by f.pais");
    }

    private List<String> consultarOpciones(String SQL) {
        List<String> opciones = new ArrayList<>();
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                opciones.add(rs.getString("TEXTO"));
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error al consultar opciones:" + ex.toString());
        }
        return opciones;
    }

    // ---------- reportes ----------

    // Goleadores: goles y asistencias de cada jugador en los partidos que cumplen los filtros.
    // La ultima columna usa la funcion fn_puesto_goleador para mostrar el puesto en todo el Mundial.
    public List<Object[]> goleadores(Integer fase, Integer grupo, Integer seleccion) {
        List<Integer> parametros = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select j.nombres || ' ' || j.apellidos as jugador, f.pais as seleccion, ");
        SQL.append("count(e.id_estadistica) as partidos, sum(e.goles) as goles, sum(e.asistencias) as asistencias, ");
        SQL.append("fn_puesto_goleador(j.id_jugador, s.id_edicion) as puesto_mundial ");
        SQL.append("from estadistica_jugador_partido e ");
        SQL.append("join partido p on p.id_partido = e.id_partido ");
        SQL.append("join convocatoria_jugador c on c.id_convocatoria = e.id_convocatoria ");
        SQL.append("join jugador j on j.id_jugador = c.id_jugador ");
        SQL.append("join seleccion s on s.id_seleccion = c.id_seleccion ");
        SQL.append("join federacion f on f.id_federacion = s.id_federacion ");
        SQL.append("where p.estado = 'FINALIZADO' ");
        agregarFiltrosPartido(SQL, parametros, fase, grupo);
        if (seleccion != null) {
            SQL.append("and c.id_seleccion = ? ");
            parametros.add(seleccion);
        }
        SQL.append("group by j.id_jugador, j.nombres, j.apellidos, f.pais, s.id_edicion ");
        SQL.append("having sum(e.goles) > 0 ");
        SQL.append("order by goles desc, asistencias desc");
        return ejecutar(SQL.toString(), parametros, 6);
    }

    // Posiciones: puntos, partidos y goles de cada seleccion en los partidos que cumplen los filtros
    public List<Object[]> posiciones(Integer fase, Integer grupo, Integer seleccion) {
        List<Integer> parametros = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select f.pais as seleccion, count(pa.id_participacion) as pj, ");
        SQL.append("sum(case when pa.resultado = 'G' then 1 else 0 end) as pg, ");
        SQL.append("sum(case when pa.resultado = 'E' then 1 else 0 end) as pe, ");
        SQL.append("sum(case when pa.resultado = 'P' then 1 else 0 end) as pp, ");
        SQL.append("sum(pa.goles_marcados) as gf, sum(r.goles_marcados) as gc, ");
        SQL.append("sum(pa.goles_marcados) - sum(r.goles_marcados) as dg, ");
        SQL.append("sum(case when pa.resultado = 'G' then 3 when pa.resultado = 'E' then 1 else 0 end) as pts ");
        SQL.append("from participacion_partido pa ");
        SQL.append("join partido p on p.id_partido = pa.id_partido ");
        SQL.append("join participacion_partido r on r.id_partido = pa.id_partido and r.id_seleccion <> pa.id_seleccion ");
        SQL.append("join seleccion s on s.id_seleccion = pa.id_seleccion ");
        SQL.append("join federacion f on f.id_federacion = s.id_federacion ");
        SQL.append("where p.estado = 'FINALIZADO' ");
        agregarFiltrosPartido(SQL, parametros, fase, grupo);
        if (seleccion != null) {
            SQL.append("and pa.id_seleccion = ? ");
            parametros.add(seleccion);
        }
        SQL.append("group by f.pais ");
        SQL.append("order by pts desc, dg desc, gf desc");
        return ejecutar(SQL.toString(), parametros, 9);
    }

    // Incidencias de los partidos que cumplen los filtros
    public List<Object[]> incidencias(Integer fase, Integer grupo, Integer seleccion) {
        List<Integer> parametros = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select to_char(p.fecha_hora, 'YYYY-MM-DD HH24:MI') as fecha, ");
        SQL.append("fl.pais || ' vs ' || fv.pais as partido, i.minuto, i.tipo, i.gravedad, i.descripcion ");
        SQL.append("from incidencia i ");
        SQL.append("join partido p on p.id_partido = i.id_partido ");
        SQL.append("join participacion_partido l on l.id_partido = p.id_partido and l.condicion = 'LOCAL' ");
        SQL.append("join seleccion sl on sl.id_seleccion = l.id_seleccion ");
        SQL.append("join federacion fl on fl.id_federacion = sl.id_federacion ");
        SQL.append("join participacion_partido v on v.id_partido = p.id_partido and v.condicion = 'VISITANTE' ");
        SQL.append("join seleccion sv on sv.id_seleccion = v.id_seleccion ");
        SQL.append("join federacion fv on fv.id_federacion = sv.id_federacion ");
        SQL.append("where 1 = 1 ");
        agregarFiltrosPartido(SQL, parametros, fase, grupo);
        if (seleccion != null) {
            SQL.append("and (l.id_seleccion = ? or v.id_seleccion = ?) ");
            parametros.add(seleccion);
            parametros.add(seleccion);
        }
        SQL.append("order by p.fecha_hora, i.minuto");
        return ejecutar(SQL.toString(), parametros, 6);
    }

    // Indicadores generales: partidos jugados, goles, promedio de gol y tarjetas.
    // Si hay seleccion, los goles y tarjetas son solo de esa seleccion.
    public String indicadores(Integer fase, Integer grupo, Integer seleccion) {
        List<Integer> parametros = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("select count(distinct p.id_partido) as partidos, nvl(sum(pa.goles_marcados), 0) as goles ");
        SQL.append("from partido p join participacion_partido pa on pa.id_partido = p.id_partido ");
        SQL.append("where p.estado = 'FINALIZADO' ");
        agregarFiltrosPartido(SQL, parametros, fase, grupo);
        if (seleccion != null) {
            SQL.append("and pa.id_seleccion = ? ");
            parametros.add(seleccion);
        }
        List<Object[]> fila1 = ejecutar(SQL.toString(), parametros, 2);

        parametros = new ArrayList<>();
        SQL = new StringBuilder("select nvl(sum(e.tarjetas_amarillas), 0) as amarillas, ");
        SQL.append("nvl(sum(case when e.tarjeta_roja = 'S' then 1 else 0 end), 0) as rojas ");
        SQL.append("from estadistica_jugador_partido e ");
        SQL.append("join partido p on p.id_partido = e.id_partido ");
        SQL.append("join convocatoria_jugador c on c.id_convocatoria = e.id_convocatoria ");
        SQL.append("where p.estado = 'FINALIZADO' ");
        agregarFiltrosPartido(SQL, parametros, fase, grupo);
        if (seleccion != null) {
            SQL.append("and c.id_seleccion = ? ");
            parametros.add(seleccion);
        }
        List<Object[]> fila2 = ejecutar(SQL.toString(), parametros, 2);

        if (fila1.isEmpty() || fila2.isEmpty()) {
            return "No se pudieron calcular los indicadores";
        }
        int partidos = Integer.parseInt(fila1.get(0)[0].toString());
        int goles = Integer.parseInt(fila1.get(0)[1].toString());
        String promedio = "0";
        if (partidos > 0) {
            promedio = String.format("%.2f", (double) goles / partidos);
        }
        return "Partidos: " + partidos + "   |   Goles: " + goles + "   |   Promedio de gol: " + promedio
                + "   |   Amarillas: " + fila2.get(0)[0] + "   |   Rojas: " + fila2.get(0)[1];
    }

    // ---------- metodos de ayuda ----------

    // agrega al where los filtros de fase y grupo, solo si no vienen en null
    private void agregarFiltrosPartido(StringBuilder SQL, List<Integer> parametros, Integer fase, Integer grupo) {
        if (fase != null) {
            SQL.append("and p.id_fase = ? ");
            parametros.add(fase);
        }
        if (grupo != null) {
            SQL.append("and p.id_grupo = ? ");
            parametros.add(grupo);
        }
    }

    // ejecuta el select con los parametros en orden y devuelve cada fila como un arreglo
    private List<Object[]> ejecutar(String SQL, List<Integer> parametros, int columnas) {
        List<Object[]> filas = new ArrayList<>();
        try (
                Connection conex = DriverManager.getConnection(Constantes.THINCONN, Constantes.USERNAME, Constantes.PASSWORD);
                PreparedStatement ps = conex.prepareStatement(SQL)) {
            for (int i = 0; i < parametros.size(); i++) {
                ps.setInt(i + 1, parametros.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Object[] fila = new Object[columnas];
                    for (int c = 0; c < columnas; c++) {
                        fila[c] = rs.getObject(c + 1);
                    }
                    filas.add(fila);
                }
            }
        } catch (SQLException ex) {
            error = ex.getMessage();
            System.out.println("Error en el reporte:" + ex.toString());
        }
        return filas;
    }
}