package mundial.modelo;

import java.sql.Timestamp;

// Una fila de la tabla INCIDENCIA con el nombre del partido
public class Incidencia {

    private int idIncidencia;
    private Timestamp fechaHora;
    private String partido;
    private int minuto;
    private String tipo;
    private String gravedad;
    private String descripcion;

    public Incidencia(int idIncidencia, Timestamp fechaHora, String partido, int minuto, String tipo,
                      String gravedad, String descripcion) {
        this.idIncidencia = idIncidencia;
        this.fechaHora = fechaHora;
        this.partido = partido;
        this.minuto = minuto;
        this.tipo = tipo;
        this.gravedad = gravedad;
        this.descripcion = descripcion;
    }

    public int getIdIncidencia() {
        return idIncidencia;
    }

    public Timestamp getFechaHora() {
        return fechaHora;
    }

    public String getPartido() {
        return partido;
    }

    public int getMinuto() {
        return minuto;
    }

    public String getTipo() {
        return tipo;
    }

    public String getGravedad() {
        return gravedad;
    }

    public String getDescripcion() {
        return descripcion;
    }

    @Override
    public String toString() {
        return partido + " min " + minuto + ": " + tipo + " (" + gravedad + ")";
    }
}