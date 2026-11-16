package mundial.vista;

import mundial.modelo.Grupo;
import mundial.repository.RepositoryGrupo;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Catalogo de grupos de la fase de grupos (A, B, C...)
public class VentanaGrupos extends JFrame {

    private RepositoryGrupo repo = new RepositoryGrupo();

    private JTextField txtId = new JTextField();
    private JTextField txtIdFase = new JTextField();
    private JTextField txtNombre = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Id fase", "Grupo"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaGrupos() {
        setTitle("Catalogo de grupos");
        setSize(550, 400);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(3, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id grupo:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Id fase:"));
        panelDatos.add(txtIdFase);
        panelDatos.add(new JLabel("Letra del grupo (A - L):"));
        panelDatos.add(txtNombre);

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
                txtIdFase.setText(modelo.getValueAt(fila, 1).toString());
                txtNombre.setText(modelo.getValueAt(fila, 2).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Grupo> grupos = repo.consultarGrupos();
        for (Grupo g : grupos) {
            modelo.addRow(new Object[]{g.getIdGrupo(), g.getIdFase(), g.getNombre()});
        }
    }

    private Grupo leerFormulario() {
        if (txtIdFase.getText().isEmpty() || txtNombre.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        // el grupo es una sola letra y en la base esta en mayuscula
        String letra = txtNombre.getText().trim().toUpperCase();
        if (letra.length() != 1) {
            JOptionPane.showMessageDialog(this, "El grupo debe ser una sola letra");
            return null;
        }
        try {
            int id = 0;
            if (!txtId.getText().isEmpty()) {
                id = Integer.parseInt(txtId.getText());
            }
            int idFase = Integer.parseInt(txtIdFase.getText());
            return new Grupo(id, idFase, letra);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "El id de fase debe ser un numero");
            return null;
        }
    }

    private void agregar() {
        Grupo grupo = leerFormulario();
        if (grupo == null) {
            return;
        }
        if (repo.insertarGrupo(grupo) > 0) {
            JOptionPane.showMessageDialog(this, "Grupo agregado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un grupo de la tabla");
            return;
        }
        Grupo grupo = leerFormulario();
        if (grupo == null) {
            return;
        }
        if (repo.actualizarGrupo(grupo) > 0) {
            JOptionPane.showMessageDialog(this, "Grupo modificado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione un grupo de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar este grupo?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarGrupo(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Grupo eliminado");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtIdFase.setText("");
        txtNombre.setText("");
        tabla.clearSelection();
    }
}