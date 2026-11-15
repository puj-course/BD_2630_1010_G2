package mundial.vista;

import mundial.modelo.Estadio;
import mundial.repository.RepositoryEstadio;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Catalogo de estadios: muestra la tabla y deja agregar, modificar y eliminar
public class VentanaEstadios extends JFrame {

    private RepositoryEstadio repo = new RepositoryEstadio();

    private JTextField txtId = new JTextField();
    private JTextField txtIdCiudad = new JTextField();
    private JTextField txtNombre = new JTextField();
    private JTextField txtCapacidad = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Id ciudad", "Nombre", "Capacidad"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaEstadios() {
        setTitle("Catalogo de estadios");
        setSize(650, 450);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        // el id lo pone la base, por eso no se puede escribir
        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(4, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id estadio:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Id ciudad:"));
        panelDatos.add(txtIdCiudad);
        panelDatos.add(new JLabel("Nombre:"));
        panelDatos.add(txtNombre);
        panelDatos.add(new JLabel("Capacidad:"));
        panelDatos.add(txtCapacidad);

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

        // al hacer clic en una fila se pasan los datos al formulario
        tabla.getSelectionModel().addListSelectionListener(e -> {
            int fila = tabla.getSelectedRow();
            if (fila != -1) {
                txtId.setText(modelo.getValueAt(fila, 0).toString());
                txtIdCiudad.setText(modelo.getValueAt(fila, 1).toString());
                txtNombre.setText(modelo.getValueAt(fila, 2).toString());
                txtCapacidad.setText(modelo.getValueAt(fila, 3).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Estadio> estadios = repo.consultarEstadios();
        for (Estadio e : estadios) {
            modelo.addRow(new Object[]{e.getIdEstadio(), e.getIdCiudad(), e.getNombre(), e.getCapacidad()});
        }
    }

    // arma un Estadio con lo que hay en el formulario, o null si algo esta mal
    private Estadio leerFormulario() {
        if (txtIdCiudad.getText().isEmpty() || txtNombre.getText().isEmpty() || txtCapacidad.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        try {
            int id = txtId.getText().isEmpty() ? 0 : Integer.parseInt(txtId.getText());
            int idCiudad = Integer.parseInt(txtIdCiudad.getText());
            int capacidad = Integer.parseInt(txtCapacidad.getText());
            return new Estadio(id, idCiudad, txtNombre.getText(), capacidad);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "El id de ciudad y la capacidad deben ser numeros");
            return null;
        }
    }

    private void agregar() {
        Estadio estadio = leerFormulario();
        if (estadio == null) {
            return;
        }
        if (repo.insertarEstadio(estadio) > 0) {
            JOptionPane.showMessageDialog(this, "Estadio agregado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un estadio de la tabla");
            return;
        }
        Estadio estadio = leerFormulario();
        if (estadio == null) {
            return;
        }
        if (repo.actualizarEstadio(estadio) > 0) {
            JOptionPane.showMessageDialog(this, "Estadio modificado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un estadio de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar este estadio?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarEstadio(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Estadio eliminado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtIdCiudad.setText("");
        txtNombre.setText("");
        txtCapacidad.setText("");
        tabla.clearSelection();
    }
}