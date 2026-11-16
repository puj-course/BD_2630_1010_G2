package mundial.vista;

import mundial.modelo.Partido;
import mundial.repository.RepositoryPartido;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

// Partidos: muestra todos los partidos, deja programar uno nuevo y registrar su resultado
public class VentanaPartidos extends JFrame {

    private RepositoryPartido repo = new RepositoryPartido();
    private SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private JTextField txtIdFase = new JTextField();
    private JTextField txtIdEstadio = new JTextField();
    private JTextField txtIdGrupo = new JTextField();
    private JTextField txtFecha = new JTextField();
    private JTextField txtIdLocal = new JTextField();
    private JTextField txtIdVisitante = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Fecha", "Fase", "Grupo", "Estadio", "Local", "Marcador", "Visitante", "Estado"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaPartidos() {
        setTitle("Partidos");
        setSize(950, 550);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        // formulario para programar un partido
        JPanel panelDatos = new JPanel(new GridLayout(6, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createTitledBorder("Programar partido"));
        panelDatos.add(new JLabel("Id fase:"));
        panelDatos.add(txtIdFase);
        panelDatos.add(new JLabel("Id estadio:"));
        panelDatos.add(txtIdEstadio);
        panelDatos.add(new JLabel("Id grupo (vacio si es eliminatoria):"));
        panelDatos.add(txtIdGrupo);
        panelDatos.add(new JLabel("Fecha y hora (AAAA-MM-DD HH:MM):"));
        panelDatos.add(txtFecha);
        panelDatos.add(new JLabel("Id seleccion local:"));
        panelDatos.add(txtIdLocal);
        panelDatos.add(new JLabel("Id seleccion visitante:"));
        panelDatos.add(txtIdVisitante);

        // botones de abajo
        JButton btnProgramar = new JButton("Programar");
        JButton btnEstadisticas = new JButton("Estadisticas");
        JButton btnResultado = new JButton("Registrar resultado");
        JButton btnEliminar = new JButton("Eliminar");
        JButton btnLimpiar = new JButton("Limpiar");

        JPanel panelBotones = new JPanel();
        panelBotones.add(btnProgramar);
        panelBotones.add(btnEstadisticas);
        panelBotones.add(btnResultado);
        panelBotones.add(btnEliminar);
        panelBotones.add(btnLimpiar);

        add(panelDatos, BorderLayout.NORTH);
        add(new JScrollPane(tabla), BorderLayout.CENTER);
        add(panelBotones, BorderLayout.SOUTH);

        btnProgramar.addActionListener(e -> programar());
        btnEstadisticas.addActionListener(e -> abrirEstadisticas());
        btnResultado.addActionListener(e -> registrarResultado());
        btnEliminar.addActionListener(e -> eliminar());
        btnLimpiar.addActionListener(e -> limpiar());

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Partido> partidos = repo.consultarPartidos();
        for (Partido p : partidos) {
            String grupo = "";
            if (p.getIdGrupo() != null) {
                grupo = p.getIdGrupo().toString();
            }
            String marcador = p.getGolesLocal() + " - " + p.getGolesVisitante();
            modelo.addRow(new Object[]{p.getIdPartido(), formato.format(p.getFechaHora()), p.getIdFase(), grupo,
                    p.getIdEstadio(), p.getLocal(), marcador, p.getVisitante(), p.getEstado()});
        }
    }

    private void programar() {
        if (txtIdFase.getText().isEmpty() || txtIdEstadio.getText().isEmpty() || txtFecha.getText().isEmpty()
                || txtIdLocal.getText().isEmpty() || txtIdVisitante.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos (el grupo es opcional)");
            return;
        }
        int idFase;
        int idEstadio;
        int idLocal;
        int idVisitante;
        Integer idGrupo = null;
        try {
            idFase = Integer.parseInt(txtIdFase.getText());
            idEstadio = Integer.parseInt(txtIdEstadio.getText());
            idLocal = Integer.parseInt(txtIdLocal.getText());
            idVisitante = Integer.parseInt(txtIdVisitante.getText());
            if (!txtIdGrupo.getText().isEmpty()) {
                idGrupo = Integer.parseInt(txtIdGrupo.getText());
            }
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Los ids deben ser numeros");
            return;
        }
        // Timestamp.valueOf necesita los segundos, por eso se le agrega :00
        Timestamp fecha;
        try {
            fecha = Timestamp.valueOf(txtFecha.getText().trim() + ":00");
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, "La fecha debe estar como AAAA-MM-DD HH:MM, por ejemplo 2026-07-04 18:00");
            return;
        }

        if (repo.programarPartido(idFase, idEstadio, idGrupo, fecha, idLocal, idVisitante)) {
            JOptionPane.showMessageDialog(this, "Partido programado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo programar el partido:\n" + repo.getError());
        }
    }

    // abre las estadisticas del partido que este seleccionado en la tabla
    private void abrirEstadisticas() {
        int fila = tabla.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Seleccione un partido de la tabla");
            return;
        }
        int idPartido = Integer.parseInt(modelo.getValueAt(fila, 0).toString());
        String titulo = modelo.getValueAt(fila, 5) + " vs " + modelo.getValueAt(fila, 7);
        new VentanaEstadisticas(idPartido, titulo).setVisible(true);
    }

    // pide los goles del partido seleccionado y llama al procedimiento
    private void registrarResultado() {
        int fila = tabla.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Seleccione un partido de la tabla");
            return;
        }
        if (modelo.getValueAt(fila, 8).toString().equals("FINALIZADO")) {
            JOptionPane.showMessageDialog(this, "Ese partido ya esta finalizado");
            return;
        }
        int idPartido = Integer.parseInt(modelo.getValueAt(fila, 0).toString());
        String local = modelo.getValueAt(fila, 5).toString();
        String visitante = modelo.getValueAt(fila, 7).toString();

        String textoLocal = JOptionPane.showInputDialog(this, "Goles de " + local + ":");
        if (textoLocal == null) {
            return;
        }
        String textoVisitante = JOptionPane.showInputDialog(this, "Goles de " + visitante + ":");
        if (textoVisitante == null) {
            return;
        }
        int golesLocal;
        int golesVisitante;
        try {
            golesLocal = Integer.parseInt(textoLocal.trim());
            golesVisitante = Integer.parseInt(textoVisitante.trim());
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Los goles deben ser numeros");
            return;
        }
        if (golesLocal < 0 || golesVisitante < 0) {
            JOptionPane.showMessageDialog(this, "Los goles no pueden ser negativos");
            return;
        }

        if (repo.registrarResultado(idPartido, golesLocal, golesVisitante)) {
            JOptionPane.showMessageDialog(this, "Resultado registrado: " + local + " " + golesLocal + " - "
                    + golesVisitante + " " + visitante);
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo registrar el resultado:\n" + repo.getError());
        }
    }

    private void eliminar() {
        int fila = tabla.getSelectedRow();
        if (fila == -1) {
            JOptionPane.showMessageDialog(this, "Seleccione un partido de la tabla");
            return;
        }
        int idPartido = Integer.parseInt(modelo.getValueAt(fila, 0).toString());
        int respuesta = JOptionPane.showConfirmDialog(this,
                "Seguro que quiere eliminar el partido " + idPartido + "? Tambien se borran sus estadisticas");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarPartido(idPartido) > 0) {
            JOptionPane.showMessageDialog(this, "Partido eliminado");
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtIdFase.setText("");
        txtIdEstadio.setText("");
        txtIdGrupo.setText("");
        txtFecha.setText("");
        txtIdLocal.setText("");
        txtIdVisitante.setText("");
        tabla.clearSelection();
    }
}