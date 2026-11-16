package mundial.modelo;

import java.sql.Date;

// Representa una fila de la tabla EDICION_MUNDIAL
public class Edicion {

    private int idEdicion;
    private int anio;
    private String nombreOficial;
    private String lema;
    private Date fechaInicio;
    private Date fechaFin;
    private int cupoConvocatoria;
    private int numSelecciones;

    public Edicion(int idEdicion, int anio, String nombreOficial, String lema, Date fechaInicio,
                   Date fechaFin, int cupoConvocatoria, int numSelecciones) {
        this.idEdicion = idEdicion;
        this.anio = anio;
        this.nombreOficial = nombreOficial;
        this.lema = lema;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.cupoConvocatoria = cupoConvocatoria;
        this.numSelecciones = numSelecciones;
    }

    public int getIdEdicion() {
        return idEdicion;
    }

    public void setIdEdicion(int idEdicion) {
        this.idEdicion = idEdicion;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public String getNombreOficial() {
        return nombreOficial;
    }

    public void setNombreOficial(String nombreOficial) {
        this.nombreOficial = nombreOficial;
    }

    public String getLema() {
        return lema;
    }

    public void setLema(String lema) {
        this.lema = lema;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public int getCupoConvocatoria() {
        return cupoConvocatoria;
    }

    public void setCupoConvocatoria(int cupoConvocatoria) {
        this.cupoConvocatoria = cupoConvocatoria;
    }

    public int getNumSelecciones() {
        return numSelecciones;
    }

    public void setNumSelecciones(int numSelecciones) {
        this.numSelecciones = numSelecciones;
    }

    @Override
    public String toString() {
        return "Edicion " + anio + ": " + nombreOficial;
    }
}