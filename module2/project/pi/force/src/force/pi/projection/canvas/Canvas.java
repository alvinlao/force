package force.pi.projection.canvas;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;
import java.util.List;

public class Canvas extends java.awt.Canvas {
    int canvasWidth;
    int canvasHeight;

    BufferStrategy strategy;

    /**
     * Default constructor
     * Creates a canvas with the screen width and screen height set to the actual
     * width and height of the screen.
     */
    public Canvas() {
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        canvasWidth = ((int) screenSize.getWidth());
        canvasHeight = ((int) screenSize.getHeight());
        
        // Create a frame
        JFrame container = new JFrame("EECE 381");

        // Set resolution
        JPanel panel = (JPanel) container.getContentPane();
        panel.setPreferredSize(new Dimension(canvasWidth, canvasHeight));
        panel.setLayout(null);

        // Setup canvas size and put into frame
        setBounds(0, 0, canvasWidth, canvasHeight);
        panel.add(this);

        // Tell AWT not to bother repainting our canvas since we're
        // going to do that our self in accelerated mode
        setIgnoreRepaint(true);

        // Make the window visible
        container.pack();
        container.setResizable(false);
        container.setVisible(true);

        // Add a listener to respond to the user closing the window. If they
        container.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        // Request the focus so key events come to us
        requestFocus();

        // Create the buffering strategy which will allow AWT
        // to manage our accelerated graphics
        createBufferStrategy(2);
        strategy = getBufferStrategy();
    }

    /**
     * Parameterized constructor
     * @param width The screen width in pixels.
     * @param height The screen height in pixels.
     */
    public Canvas(int width, int height) {
        canvasWidth = width;
        canvasHeight = height;

        // Create a frame
        JFrame container = new JFrame("EECE 381");

        // Set resolution
        JPanel panel = (JPanel) container.getContentPane();
        panel.setPreferredSize(new Dimension(canvasWidth, canvasHeight));
        panel.setLayout(null);

        // Setup canvas size and put into frame
        setBounds(0, 0, canvasWidth, canvasHeight);
        panel.add(this);

        // Tell AWT not to bother repainting our canvas since we're
        // going to do that our self in accelerated mode
        setIgnoreRepaint(true);

        // Make the window visible
        container.pack();
        container.setResizable(false);
        container.setVisible(true);

        // Add a listener to respond to the user closing the window. If they
        container.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        // Request the focus so key events come to us
        requestFocus();

        // Create the buffering strategy which will allow AWT
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
        g.fillRect(0, 0, canvasWidth, canvasHeight);

        // Draw
        for (force.pi.projection.Shape shape : shapes) {
            for (force.pi.projection.Polygon polygon : shape.polygons) {
                g.setColor(polygon.color);

                // Offset
                offsetPoints(polygon.xpoints, canvasWidth / 2);
                offsetPoints(polygon.ypoints, canvasHeight / 2);

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
