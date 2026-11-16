package mundial.vista;

import mundial.modelo.CuerpoTecnico;
import mundial.repository.RepositoryCuerpoTecnico;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Catalogo del cuerpo tecnico de cada seleccion
public class VentanaCuerpoTecnico extends JFrame {

    private RepositoryCuerpoTecnico repo = new RepositoryCuerpoTecnico();

    private JTextField txtId = new JTextField();
    private JTextField txtIdSeleccion = new JTextField();
    private JTextField txtNombres = new JTextField();
    private JTextField txtApellidos = new JTextField();
    private JTextField txtNacionalidad = new JTextField();
    // los mismos roles que permite el CHECK de la tabla
    private JComboBox<String> cbRol = new JComboBox<>(new String[]{"ENTRENADOR_PRINCIPAL", "ASISTENTE_TECNICO",
            "PREPARADOR_FISICO", "ENTRENADOR_PORTEROS", "MEDICO"});

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Id seleccion", "Nombres", "Apellidos", "Nacionalidad", "Rol"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaCuerpoTecnico() {
        setTitle("Catalogo de cuerpo tecnico");
        setSize(800, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(6, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id miembro:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Id seleccion:"));
        panelDatos.add(txtIdSeleccion);
        panelDatos.add(new JLabel("Nombres:"));
        panelDatos.add(txtNombres);
        panelDatos.add(new JLabel("Apellidos:"));
        panelDatos.add(txtApellidos);
        panelDatos.add(new JLabel("Nacionalidad:"));
        panelDatos.add(txtNacionalidad);
        panelDatos.add(new JLabel("Rol:"));
        panelDatos.add(cbRol);

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
                txtIdSeleccion.setText(modelo.getValueAt(fila, 1).toString());
                txtNombres.setText(modelo.getValueAt(fila, 2).toString());
                txtApellidos.setText(modelo.getValueAt(fila, 3).toString());
                txtNacionalidad.setText(modelo.getValueAt(fila, 4).toString());
                cbRol.setSelectedItem(modelo.getValueAt(fila, 5).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<CuerpoTecnico> miembros = repo.consultarMiembros();
        for (CuerpoTecnico c : miembros) {
            modelo.addRow(new Object[]{c.getIdMiembro(), c.getIdSeleccion(), c.getNombres(),
                    c.getApellidos(), c.getNacionalidad(), c.getRol()});
        }
    }

    private CuerpoTecnico leerFormulario() {
        if (txtIdSeleccion.getText().isEmpty() || txtNombres.getText().isEmpty()
                || txtApellidos.getText().isEmpty() || txtNacionalidad.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        try {
            int id = 0;
            if (!txtId.getText().isEmpty()) {
                id = Integer.parseInt(txtId.getText());
            }
            int idSeleccion = Integer.parseInt(txtIdSeleccion.getText());
            String rol = cbRol.getSelectedItem().toString();
            return new CuerpoTecnico(id, idSeleccion, txtNombres.getText(), txtApellidos.getText(),
                    txtNacionalidad.getText(), rol);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "El id de seleccion debe ser un numero");
            return null;
        }
    }

    private void agregar() {
        CuerpoTecnico miembro = leerFormulario();
        if (miembro == null) {
            return;
        }
        if (repo.insertarMiembro(miembro) > 0) {
            JOptionPane.showMessageDialog(this, "Miembro agregado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un miembro de la tabla");
            return;
        }
        CuerpoTecnico miembro = leerFormulario();
        if (miembro == null) {
            return;
        }
        if (repo.actualizarMiembro(miembro) > 0) {
            JOptionPane.showMessageDialog(this, "Miembro modificado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un miembro de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar este miembro?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarMiembro(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Miembro eliminado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtIdSeleccion.setText("");
        txtNombres.setText("");
        txtApellidos.setText("");
        txtNacionalidad.setText("");
        cbRol.setSelectedIndex(0);
        tabla.clearSelection();
    }
}