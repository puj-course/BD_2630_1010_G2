package mundial.modelo;

// Representa una fila de la tabla CUERPO_TECNICO
public class CuerpoTecnico {

    private int idMiembro;
    private int idSeleccion;
    private String nombres;
    private String apellidos;
    private String nacionalidad;
    private String rol;

    public CuerpoTecnico(int idMiembro, int idSeleccion, String nombres, String apellidos, String nacionalidad, String rol) {
        this.idMiembro = idMiembro;
        this.idSeleccion = idSeleccion;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.nacionalidad = nacionalidad;
        this.rol = rol;
    }

    public int getIdMiembro() {
        return idMiembro;
    }

    public void setIdMiembro(int idMiembro) {
        this.idMiembro = idMiembro;
    }

    public int getIdSeleccion() {
        return idSeleccion;
    }

    public void setIdSeleccion(int idSeleccion) {
        this.idSeleccion = idSeleccion;
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

    public String getNacionalidad() {
        return nacionalidad;
    }

    public void setNacionalidad(String nacionalidad) {
        this.nacionalidad = nacionalidad;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    @Override
    public String toString() {
        return "Miembro " + idMiembro + ": " + nombres + " " + apellidos + " (" + rol + ", seleccion " + idSeleccion + ")";
    }
}
