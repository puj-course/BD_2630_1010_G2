package mundial.vista;

import javax.swing.*;
import java.awt.*;

// Ventana principal de la aplicacion, desde el menu se abre cada parte
public class VentanaPrincipal extends JFrame {

    public VentanaPrincipal() {
        setTitle("Sistema de gestion - Copa Mundial FIFA");
        setSize(800, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JMenuBar barra = new JMenuBar();

        // catalogos (semana 2)
        JMenu menuCatalogos = new JMenu("Catalogos");
        JMenuItem itemEdiciones = new JMenuItem("Ediciones");
        JMenuItem itemCiudades = new JMenuItem("Ciudades sede");
        JMenuItem itemEstadios = new JMenuItem("Estadios");
        JMenuItem itemSelecciones = new JMenuItem("Selecciones");
        JMenuItem itemGrupos = new JMenuItem("Grupos");
        JMenuItem itemJugadores = new JMenuItem("Jugadores");
        JMenuItem itemCuerpoTecnico = new JMenuItem("Cuerpo tecnico");
        menuCatalogos.add(itemEdiciones);
        menuCatalogos.add(itemCiudades);
        menuCatalogos.add(itemEstadios);
        menuCatalogos.addSeparator();
        menuCatalogos.add(itemSelecciones);
        menuCatalogos.add(itemGrupos);
        menuCatalogos.add(itemJugadores);
        menuCatalogos.add(itemCuerpoTecnico);

        // partidos (semana 3)
        JMenu menuPartidos = new JMenu("Partidos");
        JMenuItem itemRegistrar = new JMenuItem("Registrar partidos y estadisticas");
        menuPartidos.add(itemRegistrar);

        // consultas (semana 3)
        JMenu menuConsultas = new JMenu("Consultas");
        JMenuItem itemPosiciones = new JMenuItem("Tabla de posiciones");
        JMenuItem itemResultados = new JMenuItem("Resultados consolidados");
        JMenuItem itemIncidencias = new JMenuItem("Incidencias");
        menuConsultas.add(itemPosiciones);
        menuConsultas.add(itemResultados);
        menuConsultas.add(itemIncidencias);

        // reportes (semana 3)
        JMenu menuReportes = new JMenu("Reportes");
        JMenuItem itemReportes = new JMenuItem("Panel de reportes");
        menuReportes.add(itemReportes);

        barra.add(menuCatalogos);
        barra.add(menuPartidos);
        barra.add(menuConsultas);
        barra.add(menuReportes);
        setJMenuBar(barra);

        JLabel titulo = new JLabel("Copa Mundial de la FIFA - Gestion integral", SwingConstants.CENTER);
        titulo.setFont(new Font("Arial", Font.BOLD, 24));
        add(titulo, BorderLayout.CENTER);

        // lo que ya esta hecho
        itemEstadios.addActionListener(e -> new VentanaEstadios().setVisible(true));
        itemSelecciones.addActionListener(e -> new VentanaSelecciones().setVisible(true));
        itemGrupos.addActionListener(e -> new VentanaGrupos().setVisible(true));
        itemJugadores.addActionListener(e -> new VentanaJugadores().setVisible(true));
        itemCuerpoTecnico.addActionListener(e -> new VentanaCuerpoTecnico().setVisible(true));

        // lo que falta, por ahora muestra un aviso
        itemEdiciones.addActionListener(e -> pendiente());
        itemCiudades.addActionListener(e -> pendiente());
        itemRegistrar.addActionListener(e -> pendiente());
        itemPosiciones.addActionListener(e -> pendiente());
        itemResultados.addActionListener(e -> pendiente());
        itemIncidencias.addActionListener(e -> pendiente());
        itemReportes.addActionListener(e -> pendiente());
    }

    private void pendiente() {
        JOptionPane.showMessageDialog(this, "Esta parte todavia no esta hecha");
    }
}