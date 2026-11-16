package mundial.vista;

import mundial.modelo.CiudadSede;
import mundial.repository.RepositoryCiudadSede;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Catalogo de ciudades sede de cada edicion
public class VentanaCiudades extends JFrame {

    private RepositoryCiudadSede repo = new RepositoryCiudadSede();

    private JTextField txtId = new JTextField();
    private JTextField txtIdEdicion = new JTextField();
    private JTextField txtNombre = new JTextField();
    private JTextField txtPais = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Id edicion", "Ciudad", "Pais"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaCiudades() {
        setTitle("Catalogo de ciudades sede");
        setSize(650, 450);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(4, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id ciudad:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Id edicion:"));
        panelDatos.add(txtIdEdicion);
        panelDatos.add(new JLabel("Nombre:"));
        panelDatos.add(txtNombre);
        panelDatos.add(new JLabel("Pais:"));
        panelDatos.add(txtPais);

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
                txtIdEdicion.setText(modelo.getValueAt(fila, 1).toString());
                txtNombre.setText(modelo.getValueAt(fila, 2).toString());
                txtPais.setText(modelo.getValueAt(fila, 3).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<CiudadSede> ciudades = repo.consultarCiudades();
        for (CiudadSede c : ciudades) {
            modelo.addRow(new Object[]{c.getIdCiudad(), c.getIdEdicion(), c.getNombre(), c.getPais()});
        }
    }

    private CiudadSede leerFormulario() {
        if (txtIdEdicion.getText().isEmpty() || txtNombre.getText().isEmpty() || txtPais.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        try {
            int id = 0;
            if (!txtId.getText().isEmpty()) {
                id = Integer.parseInt(txtId.getText());
            }
            int idEdicion = Integer.parseInt(txtIdEdicion.getText());
            return new CiudadSede(id, idEdicion, txtNombre.getText(), txtPais.getText());
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "El id de edicion debe ser un numero");
            return null;
        }
    }

    private void agregar() {
        CiudadSede ciudad = leerFormulario();
        if (ciudad == null) {
            return;
        }
        if (repo.insertarCiudad(ciudad) > 0) {
            JOptionPane.showMessageDialog(this, "Ciudad agregada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una ciudad de la tabla");
            return;
        }
        CiudadSede ciudad = leerFormulario();
        if (ciudad == null) {
            return;
        }
        if (repo.actualizarCiudad(ciudad) > 0) {
            JOptionPane.showMessageDialog(this, "Ciudad modificada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una ciudad de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar esta ciudad?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarCiudad(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Ciudad eliminada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtIdEdicion.setText("");
        txtNombre.setText("");
        txtPais.setText("");
        tabla.clearSelection();
    }
}