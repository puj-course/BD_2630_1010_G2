package mundial.modelo;

import java.sql.Timestamp;

// Un partido finalizado con su marcador
// los penales son Integer porque solo hay cuando el partido se definio por penales
public class Resultado {

    private int idPartido;
    private Timestamp fechaHora;
    private String fase;
    private String grupo;
    private String estadio;
    private String local;
    private int golesLocal;
    private String visitante;
    private int golesVisitante;
    private Integer penalesLocal;
    private Integer penalesVisitante;

    public Resultado(int idPartido, Timestamp fechaHora, String fase, String grupo, String estadio, String local,
                     int golesLocal, String visitante, int golesVisitante, Integer penalesLocal, Integer penalesVisitante) {
        this.idPartido = idPartido;
        this.fechaHora = fechaHora;
        this.fase = fase;
        this.grupo = grupo;
        this.estadio = estadio;
        this.local = local;
        this.golesLocal = golesLocal;
        this.visitante = visitante;
        this.golesVisitante = golesVisitante;
        this.penalesLocal = penalesLocal;
        this.penalesVisitante = penalesVisitante;
    }

    public int getIdPartido() {
        return idPartido;
    }

    public Timestamp getFechaHora() {
        return fechaHora;
    }

    public String getFase() {
        return fase;
    }

    public String getGrupo() {
        return grupo;
    }

    public String getEstadio() {
        return estadio;
    }

    public String getLocal() {
        return local;
    }

    public int getGolesLocal() {
        return golesLocal;
    }

    public String getVisitante() {
        return visitante;
    }

    public int getGolesVisitante() {
        return golesVisitante;
    }

    public Integer getPenalesLocal() {
        return penalesLocal;
    }

    public Integer getPenalesVisitante() {
        return penalesVisitante;
    }

    @Override
    public String toString() {
        return local + " " + golesLocal + " - " + golesVisitante + " " + visitante;
    }
}