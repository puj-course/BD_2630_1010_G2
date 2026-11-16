package mundial.vista;

import mundial.repository.RepositoryReportes;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

// Panel de reportes: goleadores, posiciones e incidencias con filtros por fase, grupo y seleccion
public class VentanaReportes extends JFrame {

    private RepositoryReportes repo = new RepositoryReportes();

    private JComboBox<String> cbFase = new JComboBox<>();
    private JComboBox<String> cbGrupo = new JComboBox<>();
    private JComboBox<String> cbSeleccion = new JComboBox<>();
    private JLabel lblIndicadores = new JLabel(" ");

    private DefaultTableModel modeloGoleadores = crearModelo(
            new String[]{"Jugador", "Seleccion", "Partidos", "Goles", "Asistencias", "Puesto en el Mundial"});
    private DefaultTableModel modeloPosiciones = crearModelo(
            new String[]{"Seleccion", "PJ", "PG", "PE", "PP", "GF", "GC", "DG", "Pts"});
    private DefaultTableModel modeloIncidencias = crearModelo(
            new String[]{"Fecha", "Partido", "Minuto", "Tipo", "Gravedad", "Descripcion"});

    public VentanaReportes() {
        setTitle("Reportes");
        setSize(1050, 600);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        // la primera opcion de cada lista es "Todas", que significa sin filtro
        llenarLista(cbFase, "Todas las fases", repo.consultarFases());
        llenarLista(cbGrupo, "Todos los grupos", repo.consultarGrupos());
        llenarLista(cbSeleccion, "Todas las selecciones", repo.consultarSelecciones());

        // filtros de arriba
        JButton btnGenerar = new JButton("Generar");
        JPanel panelFiltros = new JPanel();
        panelFiltros.add(new JLabel("Fase:"));
        panelFiltros.add(cbFase);
        panelFiltros.add(new JLabel("Grupo:"));
        panelFiltros.add(cbGrupo);
        panelFiltros.add(new JLabel("Seleccion:"));
        panelFiltros.add(cbSeleccion);
        panelFiltros.add(btnGenerar);

        // una pestana por reporte
        JTabbedPane pestanas = new JTabbedPane();
        pestanas.addTab("Goleadores", new JScrollPane(new JTable(modeloGoleadores)));
        pestanas.addTab("Posiciones", new JScrollPane(new JTable(modeloPosiciones)));
        pestanas.addTab("Incidencias", new JScrollPane(new JTable(modeloIncidencias)));

        lblIndicadores.setBorder(BorderFactory.createEmptyBorder(8, 10, 8, 10));
        lblIndicadores.setFont(new Font("Arial", Font.BOLD, 14));

        add(panelFiltros, BorderLayout.NORTH);
        add(pestanas, BorderLayout.CENTER);
        add(lblIndicadores, BorderLayout.SOUTH);

        btnGenerar.addActionListener(e -> generar());

        generar();
    }

    private DefaultTableModel crearModelo(String[] columnas) {
        return new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int fila, int columna) {
                return false;
            }
        };
    }

    private void llenarLista(JComboBox<String> lista, String primera, List<String> opciones) {
        lista.addItem(primera);
        for (String o : opciones) {
            lista.addItem(o);
        }
    }

    // devuelve el id que esta antes del " - ", o null si se eligio "Todas"
    private Integer leerFiltro(JComboBox<String> lista) {
        if (lista.getSelectedIndex() <= 0) {
            return null;
        }
        String texto = lista.getSelectedItem().toString();
        return Integer.parseInt(texto.substring(0, texto.indexOf(" - ")));
    }

    private void generar() {
        repo.limpiarError();
        Integer fase = leerFiltro(cbFase);
        Integer grupo = leerFiltro(cbGrupo);
        Integer seleccion = leerFiltro(cbSeleccion);

        llenarTabla(modeloGoleadores, repo.goleadores(fase, grupo, seleccion));
        llenarTabla(modeloPosiciones, repo.posiciones(fase, grupo, seleccion));
        llenarTabla(modeloIncidencias, repo.incidencias(fase, grupo, seleccion));
        lblIndicadores.setText(repo.indicadores(fase, grupo, seleccion));

        if (!repo.getError().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Hubo un error en algun reporte:\n" + repo.getError());
        }
    }

    private void llenarTabla(DefaultTableModel modelo, List<Object[]> filas) {
        modelo.setRowCount(0);
        for (Object[] fila : filas) {
            modelo.addRow(fila);
        }
    }
}