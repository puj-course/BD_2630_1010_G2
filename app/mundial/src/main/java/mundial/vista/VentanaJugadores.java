package mundial.vista;

import mundial.modelo.Jugador;
import mundial.repository.RepositoryJugador;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Date;
import java.util.List;

// Catalogo de jugadores
public class VentanaJugadores extends JFrame {

    private RepositoryJugador repo = new RepositoryJugador();

    private JTextField txtId = new JTextField();
    private JTextField txtNombres = new JTextField();
    private JTextField txtApellidos = new JTextField();
    private JTextField txtFecha = new JTextField();
    // las mismas posiciones que permite el CHECK de la tabla
    private JComboBox<String> cbPosicion = new JComboBox<>(
            new String[]{"PORTERO", "DEFENSA", "MEDIOCAMPISTA", "DELANTERO"});

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Nombres", "Apellidos", "Fecha nacimiento", "Posicion"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaJugadores() {
        setTitle("Catalogo de jugadores");
        setSize(750, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(5, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id jugador:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Nombres:"));
        panelDatos.add(txtNombres);
        panelDatos.add(new JLabel("Apellidos:"));
        panelDatos.add(txtApellidos);
        panelDatos.add(new JLabel("Fecha de nacimiento (AAAA-MM-DD):"));
        panelDatos.add(txtFecha);
        panelDatos.add(new JLabel("Posicion:"));
        panelDatos.add(cbPosicion);

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
                txtNombres.setText(modelo.getValueAt(fila, 1).toString());
                txtApellidos.setText(modelo.getValueAt(fila, 2).toString());
                txtFecha.setText(modelo.getValueAt(fila, 3).toString());
                cbPosicion.setSelectedItem(modelo.getValueAt(fila, 4).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Jugador> jugadores = repo.consultarJugadores();
        for (Jugador j : jugadores) {
            modelo.addRow(new Object[]{j.getIdJugador(), j.getNombres(), j.getApellidos(),
                    j.getFechaNacimiento(), j.getPosicion()});
        }
    }

    private Jugador leerFormulario() {
        if (txtNombres.getText().isEmpty() || txtApellidos.getText().isEmpty() || txtFecha.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        int id = 0;
        if (!txtId.getText().isEmpty()) {
            id = Integer.parseInt(txtId.getText());
        }
        // Date.valueOf convierte el texto a fecha, si no esta en formato AAAA-MM-DD saca error
        Date fecha;
        try {
            fecha = Date.valueOf(txtFecha.getText().trim());
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, "La fecha debe estar como AAAA-MM-DD, por ejemplo 1998-07-22");
            return null;
        }
        String posicion = cbPosicion.getSelectedItem().toString();
        return new Jugador(id, txtNombres.getText(), txtApellidos.getText(), fecha, posicion);
    }

    private void agregar() {
        Jugador jugador = leerFormulario();
        if (jugador == null) {
            return;
        }
        if (repo.insertarJugador(jugador) > 0) {
            JOptionPane.showMessageDialog(this, "Jugador agregado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un jugador de la tabla");
            return;
        }
        Jugador jugador = leerFormulario();
        if (jugador == null) {
            return;
        }
        if (repo.actualizarJugador(jugador) > 0) {
            JOptionPane.showMessageDialog(this, "Jugador modificado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un jugador de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar este jugador?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarJugador(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Jugador eliminado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtNombres.setText("");
        txtApellidos.setText("");
        txtFecha.setText("");
        cbPosicion.setSelectedIndex(0);
        tabla.clearSelection();
    }
}