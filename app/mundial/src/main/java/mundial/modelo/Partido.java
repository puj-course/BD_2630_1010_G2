package mundial.modelo;

import java.sql.Timestamp;

// Representa un partido con las dos selecciones que lo juegan
// local, visitante y los goles salen de PARTICIPACION_PARTIDO
public class Partido {

    private int idPartido;
    private int idFase;
    private int idEstadio;
    private Integer idGrupo;
    private Timestamp fechaHora;
    private String estado;
    private String local;
    private String visitante;
    private int golesLocal;
    private int golesVisitante;

    public Partido(int idPartido, int idFase, int idEstadio, Integer idGrupo, Timestamp fechaHora, String estado,
                   String local, String visitante, int golesLocal, int golesVisitante) {
        this.idPartido = idPartido;
        this.idFase = idFase;
        this.idEstadio = idEstadio;
        this.idGrupo = idGrupo;
        this.fechaHora = fechaHora;
        this.estado = estado;
        this.local = local;
        this.visitante = visitante;
        this.golesLocal = golesLocal;
        this.golesVisitante = golesVisitante;
    }

    public int getIdPartido() {
        return idPartido;
    }

    public int getIdFase() {
        return idFase;
    }

    public int getIdEstadio() {
        return idEstadio;
    }

    public Integer getIdGrupo() {
        return idGrupo;
    }

    public Timestamp getFechaHora() {
        return fechaHora;
    }

    public String getEstado() {
        return estado;
    }

    public String getLocal() {
        return local;
    }

    public String getVisitante() {
        return visitante;
    }

    public int getGolesLocal() {
        return golesLocal;
    }

    public int getGolesVisitante() {
        return golesVisitante;
    }

    @Override
    public String toString() {
        return "Partido " + idPartido + ": " + local + " " + golesLocal + " - " + golesVisitante + " " + visitante;
    }
}