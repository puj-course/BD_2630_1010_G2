package mundial.modelo;

// Una fila de la tabla de posiciones de un grupo
public class Posicion {

    private String grupo;
    private String seleccion;
    private int jugados;
    private int ganados;
    private int empatados;
    private int perdidos;
    private int golesFavor;
    private int golesContra;
    private int diferencia;
    private int puntos;

    public Posicion(String grupo, String seleccion, int jugados, int ganados, int empatados, int perdidos,
                    int golesFavor, int golesContra, int diferencia, int puntos) {
        this.grupo = grupo;
        this.seleccion = seleccion;
        this.jugados = jugados;
        this.ganados = ganados;
        this.empatados = empatados;
        this.perdidos = perdidos;
        this.golesFavor = golesFavor;
        this.golesContra = golesContra;
        this.diferencia = diferencia;
        this.puntos = puntos;
    }

    public String getGrupo() {
        return grupo;
    }

    public String getSeleccion() {
        return seleccion;
    }

    public int getJugados() {
        return jugados;
    }

    public int getGanados() {
        return ganados;
    }

    public int getEmpatados() {
        return empatados;
    }

    public int getPerdidos() {
        return perdidos;
    }

    public int getGolesFavor() {
        return golesFavor;
    }

    public int getGolesContra() {
        return golesContra;
    }

    public int getDiferencia() {
        return diferencia;
    }

    public int getPuntos() {
        return puntos;
    }

    @Override
    public String toString() {
        return "Grupo " + grupo + ": " + seleccion + " " + puntos + " pts";
    }
}