package force.pi.projection.canvas;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;
import java.util.List;

public class Canvas extends java.awt.Canvas {
    public static final int WIDTH = 800;
    public static final int HEIGHT = 600;

    BufferStrategy strategy;

    public Canvas() {
        // create a frame to contain our game
        JFrame container = new JFrame("EECE 381");

        // get hold the content of the frame and set up the resolution of the game
        JPanel panel = (JPanel) container.getContentPane();
        panel.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        panel.setLayout(null);

        // setup our canvas size and put it into the content of the frame
        setBounds(0,0,WIDTH,HEIGHT);
        panel.add(this);

        // Tell AWT not to bother repainting our canvas since we're
        // going to do that our self in accelerated mode
        setIgnoreRepaint(true);

        // finally make the window visible
        container.pack();
        container.setResizable(false);
        container.setVisible(true);

        // add a listener to respond to the user closing the window. If they
        // do we'd like to exit the game
        container.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        // request the focus so key events come to us
        requestFocus();

        // create the buffering strategy which will allow AWT
        // to manage our accelerated graphics
        createBufferStrategy(2);
        strategy = getBufferStrategy();
    }

    /**
     *
     * @param shapes
     */
    public void draw(List<force.pi.projection.Shape> shapes) {
        // Get hold of a graphics context for the accelerated
        // surface and blank it out
        Graphics2D g = (Graphics2D) strategy.getDrawGraphics();
        g.setColor(Color.white);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // Draw
        for (force.pi.projection.Shape shape : shapes) {
            for (force.pi.projection.Polygon polygon : shape.polygons) {
                g.setColor(polygon.color);

                // Offset
                offsetPoints(polygon.xpoints, WIDTH / 2);
                offsetPoints(polygon.ypoints, HEIGHT / 2);

                g.fillPolygon(polygon.xpoints, polygon.ypoints, polygon.npoints);
            }
        }

        // Swap buffers
        g.dispose();
        strategy.show();
    }

    /**
     * Offset all points
     * @param points
     * @param offset
     */
    public void offsetPoints(int[] points, int offset) {
        for (int i = 0; i < points.length; ++i) {
            points[i] += offset;
        }
    }
}
