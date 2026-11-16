package mundial.vista;

import mundial.modelo.Estadistica;
import mundial.repository.RepositoryEstadistica;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Estadisticas de los jugadores en un partido (goles, asistencias, tarjetas y minutos)
public class VentanaEstadisticas extends JFrame {

    private RepositoryEstadistica repo = new RepositoryEstadistica();
    private int idPartido;

    private JTextField txtId = new JTextField();
    private JComboBox<String> cbJugador = new JComboBox<>();
    private JTextField txtEntrada = new JTextField("0");
    private JTextField txtSalida = new JTextField();
    private JTextField txtGoles = new JTextField("0");
    private JTextField txtAsistencias = new JTextField("0");
    private JTextField txtAmarillas = new JTextField("0");
    private JComboBox<String> cbRoja = new JComboBox<>(new String[]{"N", "S"});

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Convocatoria", "Jugador", "Entrada", "Salida", "Goles", "Asistencias", "Amarillas", "Roja"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaEstadisticas(int idPartido, String titulo) {
        this.idPartido = idPartido;
        setTitle("Estadisticas - " + titulo);
        setSize(1000, 550);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // solo salen los convocados de las dos selecciones del partido
        List<String> convocados = repo.consultarConvocados(idPartido);
        for (String c : convocados) {
            cbJugador.addItem(c);
        }

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(8, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id estadistica:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Jugador:"));
        panelDatos.add(cbJugador);
        panelDatos.add(new JLabel("Minuto de entrada:"));
        panelDatos.add(txtEntrada);
        panelDatos.add(new JLabel("Minuto de salida (vacio si termino el partido):"));
        panelDatos.add(txtSalida);
        panelDatos.add(new JLabel("Goles:"));
        panelDatos.add(txtGoles);
        panelDatos.add(new JLabel("Asistencias:"));
        panelDatos.add(txtAsistencias);
        panelDatos.add(new JLabel("Tarjetas amarillas (0 a 2):"));
        panelDatos.add(txtAmarillas);
        panelDatos.add(new JLabel("Tarjeta roja:"));
        panelDatos.add(cbRoja);

        // botones de abajo
        JButton btnAgregar = new JButton("Agregar");
        JButton btnModificar = new JButton("Modificar");
        JButton btnEliminar = new JButton("Eliminar");
        JButton btnLimpiar = new JButton("Limpiar");

        JPanel panelBotones = new JPanel();
        panelBotones.add(btnAgregar);
        panelBotones.add(btnModificar);
        panelBotones.add(btnEliminar);
        panelBotones.add(btnLimpiar);

        add(panelDatos, BorderLayout.NORTH);
        add(new JScrollPane(tabla), BorderLayout.CENTER);
        add(panelBotones, BorderLayout.SOUTH);

        btnAgregar.addActionListener(e -> agregar());
        btnModificar.addActionListener(e -> modificar());
        btnEliminar.addActionListener(e -> eliminar());
        btnLimpiar.addActionListener(e -> limpiar());

        tabla.getSelectionModel().addListSelectionListener(e -> {
            int fila = tabla.getSelectedRow();
            if (fila != -1) {
                txtId.setText(modelo.getValueAt(fila, 0).toString());
                seleccionarJugador(modelo.getValueAt(fila, 1).toString());
                txtEntrada.setText(modelo.getValueAt(fila, 3).toString());
                txtSalida.setText(modelo.getValueAt(fila, 4).toString());
                txtGoles.setText(modelo.getValueAt(fila, 5).toString());
                txtAsistencias.setText(modelo.getValueAt(fila, 6).toString());
                txtAmarillas.setText(modelo.getValueAt(fila, 7).toString());
                cbRoja.setSelectedItem(modelo.getValueAt(fila, 8).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Estadistica> estadisticas = repo.consultarPorPartido(idPartido);
        for (Estadistica e : estadisticas) {
            String salida = "";
            if (e.getMinutoSalida() != null) {
                salida = e.getMinutoSalida().toString();
            }
            modelo.addRow(new Object[]{e.getIdEstadistica(), e.getIdConvocatoria(), e.getJugador(), e.getMinutoEntrada(),
                    salida, e.getGoles(), e.getAsistencias(), e.getAmarillas(), e.getRoja()});
        }
    }

    // busca en la lista el jugador que tenga esa convocatoria
    private void seleccionarJugador(String idConvocatoria) {
        for (int i = 0; i < cbJugador.getItemCount(); i++) {
            if (cbJugador.getItemAt(i).startsWith(idConvocatoria + " - ")) {
                cbJugador.setSelectedIndex(i);
            }
        }
    }

    private Estadistica leerFormulario() {
        if (cbJugador.getSelectedItem() == null) {
            JOptionPane.showMessageDialog(this, "Este partido no tiene jugadores convocados");
            return null;
        }
        if (txtEntrada.getText().isEmpty() || txtGoles.getText().isEmpty()
                || txtAsistencias.getText().isEmpty() || txtAmarillas.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos (la salida es opcional)");
            return null;
        }
        try {
            int id = 0;
            if (!txtId.getText().isEmpty()) {
                id = Integer.parseInt(txtId.getText());
            }
            // el id de la convocatoria es lo que esta antes del " - "
            String jugador = cbJugador.getSelectedItem().toString();
            int idConvocatoria = Integer.parseInt(jugador.substring(0, jugador.indexOf(" - ")));
            int entrada = Integer.parseInt(txtEntrada.getText());
            Integer salida = null;
            if (!txtSalida.getText().isEmpty()) {
                salida = Integer.parseInt(txtSalida.getText());
            }
            int goles = Integer.parseInt(txtGoles.getText());
            int asistencias = Integer.parseInt(txtAsistencias.getText());
            int amarillas = Integer.parseInt(txtAmarillas.getText());
            String roja = cbRoja.getSelectedItem().toString();
            return new Estadistica(id, idPartido, idConvocatoria, jugador, entrada, salida, goles, asistencias, amarillas, roja);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Los minutos, goles, asistencias y tarjetas deben ser numeros");
            return null;
        }
    }

    private void agregar() {
        Estadistica e = leerFormulario();
        if (e == null) {
            return;
        }
        if (repo.insertarEstadistica(e) > 0) {
            JOptionPane.showMessageDialog(this, "Estadistica agregada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una estadistica de la tabla");
            return;
        }
        Estadistica e = leerFormulario();
        if (e == null) {
            return;
        }
        if (repo.actualizarEstadistica(e) > 0) {
            JOptionPane.showMessageDialog(this, "Estadistica modificada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una estadistica de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar esta estadistica?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarEstadistica(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Estadistica eliminada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtEntrada.setText("0");
        txtSalida.setText("");
        txtGoles.setText("0");
        txtAsistencias.setText("0");
        txtAmarillas.setText("0");
        cbRoja.setSelectedIndex(0);
        if (cbJugador.getItemCount() > 0) {
            cbJugador.setSelectedIndex(0);
        }
        tabla.clearSelection();
    }
}