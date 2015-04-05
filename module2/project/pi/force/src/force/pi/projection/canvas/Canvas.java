package force.pi.projection.canvas;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;

public class Canvas extends java.awt.Canvas {
    public static final int WIDTH = 800;
    public static final int HEIGHT = 600;

    BufferStrategy strategy;

    public Canvas() {
        // create a frame to contain our game
        JFrame container = new JFrame("Space Invaders 101");

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

    public void draw() {
        // Get hold of a graphics context for the accelerated
        // surface and blank it out
        Graphics2D g = (Graphics2D) strategy.getDrawGraphics();
        g.setColor(Color.white);
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // Draw
        g.setColor(Color.blue);
        g.fillPolygon(new Polygon(new int[]{10, 20, 20, 10}, new int[]{10, 10, 20, 20}, 4));

        // Swap buffers
        g.dispose();
        strategy.show();
    }
}
