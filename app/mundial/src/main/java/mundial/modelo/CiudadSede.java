package mundial.modelo;

// Representa una fila de la tabla CIUDAD_SEDE
public class CiudadSede {

    private int idCiudad;
    private int idEdicion;
    private String nombre;
    private String pais;

    public CiudadSede(int idCiudad, int idEdicion, String nombre, String pais) {
        this.idCiudad = idCiudad;
        this.idEdicion = idEdicion;
        this.nombre = nombre;
        this.pais = pais;
    }

    public int getIdCiudad() {
        return idCiudad;
    }

    public void setIdCiudad(int idCiudad) {
        this.idCiudad = idCiudad;
    }

    public int getIdEdicion() {
        return idEdicion;
    }

    public void setIdEdicion(int idEdicion) {
        this.idEdicion = idEdicion;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    @Override
    public String toString() {
        return "Ciudad " + idCiudad + ": " + nombre + ", " + pais + " (edicion " + idEdicion + ")";
    }
}