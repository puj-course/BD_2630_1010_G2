package mundial.vista;

import mundial.modelo.Edicion;
import mundial.repository.RepositoryEdicion;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Date;
import java.util.List;

// Catalogo de ediciones del Mundial
public class VentanaEdiciones extends JFrame {

    private RepositoryEdicion repo = new RepositoryEdicion();

    private JTextField txtId = new JTextField();
    private JTextField txtAnio = new JTextField();
    private JTextField txtNombre = new JTextField();
    private JTextField txtLema = new JTextField();
    private JTextField txtFechaInicio = new JTextField();
    private JTextField txtFechaFin = new JTextField();
    private JTextField txtCupo = new JTextField();
    private JTextField txtNumSelecciones = new JTextField();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Id", "Anio", "Nombre oficial", "Lema", "Inicio", "Fin", "Cupo", "Selecciones"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaEdiciones() {
        setTitle("Catalogo de ediciones");
        setSize(900, 550);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        txtId.setEditable(false);

        // formulario de arriba
        JPanel panelDatos = new JPanel(new GridLayout(8, 2, 5, 5));
        panelDatos.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelDatos.add(new JLabel("Id edicion:"));
        panelDatos.add(txtId);
        panelDatos.add(new JLabel("Anio:"));
        panelDatos.add(txtAnio);
        panelDatos.add(new JLabel("Nombre oficial:"));
        panelDatos.add(txtNombre);
        panelDatos.add(new JLabel("Lema:"));
        panelDatos.add(txtLema);
        panelDatos.add(new JLabel("Fecha inicio (AAAA-MM-DD):"));
        panelDatos.add(txtFechaInicio);
        panelDatos.add(new JLabel("Fecha fin (AAAA-MM-DD):"));
        panelDatos.add(txtFechaFin);
        panelDatos.add(new JLabel("Cupo de convocatoria:"));
        panelDatos.add(txtCupo);
        panelDatos.add(new JLabel("Numero de selecciones:"));
        panelDatos.add(txtNumSelecciones);

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
                txtAnio.setText(modelo.getValueAt(fila, 1).toString());
                txtNombre.setText(modelo.getValueAt(fila, 2).toString());
                txtLema.setText(modelo.getValueAt(fila, 3).toString());
                txtFechaInicio.setText(modelo.getValueAt(fila, 4).toString());
                txtFechaFin.setText(modelo.getValueAt(fila, 5).toString());
                txtCupo.setText(modelo.getValueAt(fila, 6).toString());
                txtNumSelecciones.setText(modelo.getValueAt(fila, 7).toString());
            }
        });

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Edicion> ediciones = repo.consultarEdiciones();
        for (Edicion e : ediciones) {
            modelo.addRow(new Object[]{e.getIdEdicion(), e.getAnio(), e.getNombreOficial(), e.getLema(),
                    e.getFechaInicio(), e.getFechaFin(), e.getCupoConvocatoria(), e.getNumSelecciones()});
        }
    }

    private Edicion leerFormulario() {
        if (txtAnio.getText().isEmpty() || txtNombre.getText().isEmpty() || txtLema.getText().isEmpty()
                || txtFechaInicio.getText().isEmpty() || txtFechaFin.getText().isEmpty()
                || txtCupo.getText().isEmpty() || txtNumSelecciones.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Llene todos los campos");
            return null;
        }
        int id = 0;
        if (!txtId.getText().isEmpty()) {
            id = Integer.parseInt(txtId.getText());
        }
        int anio;
        int cupo;
        int numSelecciones;
        try {
            anio = Integer.parseInt(txtAnio.getText());
            cupo = Integer.parseInt(txtCupo.getText());
            numSelecciones = Integer.parseInt(txtNumSelecciones.getText());
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "El anio, el cupo y el numero de selecciones deben ser numeros");
            return null;
        }
        Date inicio;
        Date fin;
        try {
            inicio = Date.valueOf(txtFechaInicio.getText().trim());
            fin = Date.valueOf(txtFechaFin.getText().trim());
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, "Las fechas deben estar como AAAA-MM-DD, por ejemplo 2026-06-11");
            return null;
        }
        return new Edicion(id, anio, txtNombre.getText(), txtLema.getText(), inicio, fin, cupo, numSelecciones);
    }

    private void agregar() {
        Edicion edicion = leerFormulario();
        if (edicion == null) {
            return;
        }
        if (repo.insertarEdicion(edicion) > 0) {
            JOptionPane.showMessageDialog(this, "Edicion agregada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo agregar:\n" + repo.getError());
        }
    }

    private void modificar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una edicion de la tabla");
            return;
        }
        Edicion edicion = leerFormulario();
        if (edicion == null) {
            return;
        }
        if (repo.actualizarEdicion(edicion) > 0) {
            JOptionPane.showMessageDialog(this, "Edicion modificada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo modificar:\n" + repo.getError());
        }
    }

    private void eliminar() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Seleccione una edicion de la tabla");
            return;
        }
        int respuesta = JOptionPane.showConfirmDialog(this, "Seguro que quiere eliminar esta edicion?");
        if (respuesta != JOptionPane.YES_OPTION) {
            return;
        }
        if (repo.eliminarEdicion(Integer.parseInt(txtId.getText())) > 0) {
            JOptionPane.showMessageDialog(this, "Edicion eliminada");
            limpiar();
            cargarTabla();
        } else {
            JOptionPane.showMessageDialog(this, "No se pudo eliminar:\n" + repo.getError());
        }
    }

    private void limpiar() {
        txtId.setText("");
        txtAnio.setText("");
        txtNombre.setText("");
        txtLema.setText("");
        txtFechaInicio.setText("");
        txtFechaFin.setText("");
        txtCupo.setText("");
        txtNumSelecciones.setText("");
        tabla.clearSelection();
    }
}