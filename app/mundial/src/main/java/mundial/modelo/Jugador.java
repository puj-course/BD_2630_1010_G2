package mundial.modelo;

import java.sql.Date;

// Representa una fila de la tabla JUGADOR
public class Jugador {

    private int idJugador;
    private String nombres;
    private String apellidos;
    private Date fechaNacimiento;
    private String posicion;

    public Jugador(int idJugador, String nombres, String apellidos, Date fechaNacimiento, String posicion) {
        this.idJugador = idJugador;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.fechaNacimiento = fechaNacimiento;
        this.posicion = posicion;
    }

    public int getIdJugador() {
        return idJugador;
    }

    public void setIdJugador(int idJugador) {
        this.idJugador = idJugador;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getPosicion() {
        return posicion;
    }

    public void setPosicion(String posicion) {
        this.posicion = posicion;
    }

    @Override
    public String toString() {
        return "Jugador " + idJugador + ": " + nombres + " " + apellidos + " (" + posicion + ", nacio " + fechaNacimiento + ")";
    }
}