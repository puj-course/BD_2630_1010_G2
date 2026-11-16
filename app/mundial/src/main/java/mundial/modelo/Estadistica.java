package mundial.modelo;

// Representa una fila de la tabla ESTADISTICA_JUGADOR_PARTIDO
// jugador es solo para mostrar el nombre en la tabla
public class Estadistica {

    private int idEstadistica;
    private int idPartido;
    private int idConvocatoria;
    private String jugador;
    private int minutoEntrada;
    private Integer minutoSalida;
    private int goles;
    private int asistencias;
    private int amarillas;
    private String roja;

    public Estadistica(int idEstadistica, int idPartido, int idConvocatoria, String jugador, int minutoEntrada,
                       Integer minutoSalida, int goles, int asistencias, int amarillas, String roja) {
        this.idEstadistica = idEstadistica;
        this.idPartido = idPartido;
        this.idConvocatoria = idConvocatoria;
        this.jugador = jugador;
        this.minutoEntrada = minutoEntrada;
        this.minutoSalida = minutoSalida;
        this.goles = goles;
        this.asistencias = asistencias;
        this.amarillas = amarillas;
        this.roja = roja;
    }

    public int getIdEstadistica() {
        return idEstadistica;
    }

    public int getIdPartido() {
        return idPartido;
    }

    public int getIdConvocatoria() {
        return idConvocatoria;
    }

    public String getJugador() {
        return jugador;
    }

    public int getMinutoEntrada() {
        return minutoEntrada;
    }

    public Integer getMinutoSalida() {
        return minutoSalida;
    }

    public int getGoles() {
        return goles;
    }

    public int getAsistencias() {
        return asistencias;
    }

    public int getAmarillas() {
        return amarillas;
    }

    public String getRoja() {
        return roja;
    }

    @Override
    public String toString() {
        return jugador + ": " + goles + " goles, " + asistencias + " asistencias";
    }
}