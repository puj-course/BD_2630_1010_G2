package mundial.vista;

import mundial.modelo.Seleccion;
import mundial.repository.RepositorySeleccion;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Catalogo de selecciones que juegan cada edicion del Mundial
public class VentanaSelecciones extends JFrame {

    private RepositorySeleccion repo = new RepositorySeleccion();

    private JTextField txtId = new JTextField();
    private JTextField txtIdEdicion = new JTextField();
    private JTextField txtIdFederacion = new JTextField();
    private JTextField txtIdGrupo = new JTextField();
    private JTextField txtRanking = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Id edicion", "Id federacion", "Id grupo", "Ranking FIFA"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaSelecciones() {
        setTitle("Catalogo de selecciones");
        setSize(700, 450);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(5, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id seleccion:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Id edicion:"));
        panelDatos.add(txtIdEdicion);
        panelDatos.add(new JLabel("Id federacion:"));
        panelDatos.add(txtIdFederacion);
        panelDatos.add(new JLabel("Id grupo (opcional):"));
        panelDatos.add(txtIdGrupo);
        panelDatos.add(new JLabel("Ranking FIFA (opcional):"));
        panelDatos.add(txtRanking);

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
                txtIdFederacion.setText(modelo.getValueAt(fila, 2).toString());
                txtIdGrupo.setText(modelo.getValueAt(fila, 3).toString());
                txtRanking.setText(modelo.getValueAt(fila, 4).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Seleccion> selecciones = repo.consultarSelecciones();
        for (Seleccion s : selecciones) {
            // si es null se muestra vacio en la tabla
            String grupo = "";
            if (s.getIdGrupo() != null) {
                grupo = s.getIdGrupo().toString();
            }
            String ranking = "";
            if (s.getRankingFifa() != null) {
                ranking = s.getRankingFifa().toString();
            }
            modelo.addRow(new Object[]{s.getIdSeleccion(), s.getIdEdicion(), s.getIdFederacion(), grupo, ranking});
        }
    }

    private Seleccion leerFormulario() {
        if (txtIdEdicion.getText().isEmpty() || txtIdFederacion.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "La edicion y la federacion son obligatorias");
            return null;
        }
        try {
            int id = 0;
            if (!txtId.getText().isEmpty()) {
                id = Integer.parseInt(txtId.getText());
            }
            int idEdicion = Integer.parseInt(txtIdEdicion.getText());
            int idFederacion = Integer.parseInt(txtIdFederacion.getText());
            Integer idGrupo = null;
            if (!txtIdGrupo.getText().isEmpty()) {
                idGrupo = Integer.parseInt(txtIdGrupo.getText());
            }
            Integer ranking = null;
            if (!txtRanking.getText().isEmpty()) {
                ranking = Integer.parseInt(txtRanking.getText());
            }
            return new Seleccion(id, idEdicion, idFederacion, idGrupo, ranking);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Todos los campos deben ser numeros");
            return null;
        }
    }

    private void agregar() {
        Seleccion seleccion = leerFormulario();
        if (seleccion == null) {
            return;
        }
        if (repo.insertarSeleccion(seleccion) > 0) {
            JOptionPane.showMessageDialog(this, "Seleccion agregada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una seleccion de la tabla");
            return;
        }
        Seleccion seleccion = leerFormulario();
        if (seleccion == null) {
            return;
        }
        if (repo.actualizarSeleccion(seleccion) > 0) {
            JOptionPane.showMessageDialog(this, "Seleccion modificada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una seleccion de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar esta seleccion?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarSeleccion(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Seleccion eliminada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtIdEdicion.setText("");
        txtIdFederacion.setText("");
        txtIdGrupo.setText("");
        txtRanking.setText("");
        tabla.clearSelection();
    }
}