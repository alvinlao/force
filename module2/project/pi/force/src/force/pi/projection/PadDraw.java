package force.pi.projection;

import javax.swing.*;
import java.awt.*;

/**
 * Sets up a draw pad to draw on.
 */
class PadDraw extends JComponent {
    static final int PIXEL_SIZE = 5;
    Image image;
    Graphics2D graphics2D;

    public PadDraw(){
        setDoubleBuffered(false);
    }

    public void paintComponent(Graphics g){
        if(image == null){
            image = createImage(getSize().width, getSize().height);
            graphics2D = (Graphics2D)image.getGraphics();
            graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            clear();
        }
        g.drawImage(image, 0, 0, null);
    }

    /**
     * clears the draw pad
     */
    public void clear(){
        graphics2D.setPaint(Color.white);
        graphics2D.fillRect(0, 0, getSize().width, getSize().height);
        graphics2D.setPaint(Color.black);
        repaint();
    }

    /**
     * draws to the draw pad
     * @param x is the x coordinate for pixel to draw
     * @param y is the y coordinate for pixel to draw
     */
    public void Draw (int x, int y){
        if(graphics2D != null) {
            graphics2D.fillRect(x,y,PIXEL_SIZE,PIXEL_SIZE);
        }
        repaint();
    }
}
