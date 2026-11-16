package mundial.vista;

import mundial.modelo.Resultado;
import mundial.repository.RepositoryConsultas;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.text.SimpleDateFormat;
import java.util.List;

// Consulta: resultados de todos los partidos que ya se jugaron
public class VentanaResultados extends JFrame {

    private RepositoryConsultas repo = new RepositoryConsultas();
    private SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private DefaultTableModel modelo = new DefaultTableModel(
            new String[]{"Fecha", "Fase", "Grupo", "Estadio", "Local", "Marcador", "Visitante", "Penales"}, 0) {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private JTable tabla = new JTable(modelo);

    public VentanaResultados() {
        setTitle("Resultados consolidados");
        setSize(950, 450);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

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
        List<Resultado> resultados = repo.consultarResultados();
        for (Resultado r : resultados) {
            String grupo = "";
            if (r.getGrupo() != null) {
                grupo = r.getGrupo();
            }
            // los penales solo se muestran si el partido se definio asi
            String penales = "";
            if (r.getPenalesLocal() != null) {
                penales = r.getPenalesLocal() + " - " + r.getPenalesVisitante();
            }
            String marcador = r.getGolesLocal() + " - " + r.getGolesVisitante();
            modelo.addRow(new Object[]{formato.format(r.getFechaHora()), r.getFase(), grupo, r.getEstadio(),
                    r.getLocal(), marcador, r.getVisitante(), penales});
        }
        if (resultados.isEmpty() && !repo.getError().isEmpty()) {
            JOptionPane.showMessageDialog(this, "No se pudo consultar:\n" + repo.getError());
        }
    }
}