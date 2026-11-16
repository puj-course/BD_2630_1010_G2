package mundial.modelo;

// Representa una fila de la tabla SELECCION
// idGrupo y ranking son Integer porque en la base pueden quedar vacios (null)
public class Seleccion {

    private int idSeleccion;
    private int idEdicion;
    private int idFederacion;
    private Integer idGrupo;
    private Integer rankingFifa;

    public Seleccion(int idSeleccion, int idEdicion, int idFederacion, Integer idGrupo, Integer rankingFifa) {
        this.idSeleccion = idSeleccion;
        this.idEdicion = idEdicion;
        this.idFederacion = idFederacion;
        this.idGrupo = idGrupo;
        this.rankingFifa = rankingFifa;
    }

    public int getIdSeleccion() {
        return idSeleccion;
    }

    public void setIdSeleccion(int idSeleccion) {
        this.idSeleccion = idSeleccion;
    }

    public int getIdEdicion() {
        return idEdicion;
    }

    public void setIdEdicion(int idEdicion) {
        this.idEdicion = idEdicion;
    }

    public int getIdFederacion() {
        return idFederacion;
    }

    public void setIdFederacion(int idFederacion) {
        this.idFederacion = idFederacion;
    }

    public Integer getIdGrupo() {
        return idGrupo;
    }

    public void setIdGrupo(Integer idGrupo) {
        this.idGrupo = idGrupo;
    }

    public Integer getRankingFifa() {
        return rankingFifa;
    }

    public void setRankingFifa(Integer rankingFifa) {
        this.rankingFifa = rankingFifa;
    }

    @Override
    public String toString() {
        return "Seleccion " + idSeleccion + " (edicion " + idEdicion + ", federacion " + idFederacion
                + ", grupo " + idGrupo + ", ranking " + rankingFifa + ")";
    }
}