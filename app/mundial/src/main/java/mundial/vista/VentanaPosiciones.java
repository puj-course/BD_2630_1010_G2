package mundial.vista;

import mundial.modelo.Posicion;
import mundial.repository.RepositoryConsultas;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Consulta: tabla de posiciones de cada grupo
public class VentanaPosiciones extends JFrame {

    private RepositoryConsultas repo = new RepositoryConsultas();

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Grupo", "Seleccion", "PJ", "PG", "PE", "PP", "GF", "GC", "DG", "Pts"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaPosiciones() {
        setTitle("Tabla de posiciones");
        setSize(750, 400);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JLabel ayuda = new JLabel("  PJ jugados, PG ganados, PE empatados, PP perdidos, GF goles a favor, GC en contra, DG diferencia");
        JButton btnActualizar = new JButton("Actualizar");
        JPanel panelBotones = new JPanel();
        panelBotones.add(btnActualizar);

        add(ayuda, BorderLayout.NORTH);
        add(new JScrollPane(tabla), BorderLayout.CENTER);
        add(panelBotones, BorderLayout.SOUTH);

        btnActualizar.addActionListener(e -> cargarTabla());

        cargarTabla();
    }

    private void cargarTabla() {
        modelo.setRowCount(0);
        List<Posicion> posiciones = repo.consultarPosiciones();
        for (Posicion p : posiciones) {
            modelo.addRow(new Object[]{p.getGrupo(), p.getSeleccion(), p.getJugados(), p.getGanados(),
                    p.getEmpatados(), p.getPerdidos(), p.getGolesFavor(), p.getGolesContra(),
                    p.getDiferencia(), p.getPuntos()});
        }
        if (posiciones.isEmpty() && !repo.getError().isEmpty()) {
            JOptionPane.showMessageDialog(this, "No se pudo consultar:\n" + repo.getError());
        }
    }
}