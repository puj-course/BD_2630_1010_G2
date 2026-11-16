package mundial.modelo;

// Representa una fila de la tabla GRUPO
public class Grupo {

    private int idGrupo;
    private int idFase;
    private String nombre;

    public Grupo(int idGrupo, int idFase, String nombre) {
        this.idGrupo = idGrupo;
        this.idFase = idFase;
        this.nombre = nombre;
    }

    public int getIdGrupo() {
        return idGrupo;
    }

    public void setIdGrupo(int idGrupo) {
        this.idGrupo = idGrupo;
    }

    public int getIdFase() {
        return idFase;
    }

    public void setIdFase(int idFase) {
        this.idFase = idFase;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String toString() {
        return "Grupo " + nombre + " (id " + idGrupo + ", fase " + idFase + ")";
    }
}