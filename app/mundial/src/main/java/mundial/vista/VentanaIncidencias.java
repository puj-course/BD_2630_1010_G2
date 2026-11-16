package mundial.vista;

import mundial.modelo.Incidencia;
import mundial.repository.RepositoryConsultas;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.text.SimpleDateFormat;
import java.util.List;

// Consulta: incidencias que pasaron en los partidos
public class VentanaIncidencias extends JFrame {

    private RepositoryConsultas repo = new RepositoryConsultas();
    private SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Fecha", "Partido", "Minuto", "Tipo", "Gravedad", "Descripcion"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaIncidencias() {
        setTitle("Incidencias");
        setSize(1000, 400);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        // la descripcion es larga, por eso esa columna es mas ancha
        tabla.getColumnModel().getColumn(5).setPreferredWidth(400);

        JButton btnActualizar = new JButton("Actualizar");
        JPanel panelBotones = new JPanel();
        panelBotones.add(btnActualizar);

        add(new JScrollPane(tabla), BorderLayout.CENTER);
        add(panelBotones, BorderLayout.SOUTH);

        btnActualizar.addActionListener(e -> cargarTabla());

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Incidencia> incidencias = repo.consultarIncidencias();
        for (Incidencia i : incidencias) {
            modelo.addRow(new Object[]{formato.format(i.getFechaHora()), i.getPartido(), i.getMinuto(),
                    i.getTipo(), i.getGravedad(), i.getDescripcion()});
        }
        if (incidencias.isEmpty() && !repo.getError().isEmpty()) {
            JOptionPane.showMessageDialog(this, "No se pudo consultar:\n" + repo.getError());
        }
    }
}