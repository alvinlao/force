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

    @Override
    public void paintComponent(Graphics g){
	super.paintComponent(g);

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
        if (graphics2D != null) {
            graphics2D.setPaint(Color.white);
            graphics2D.fillRect(0, 0, getSize().width, getSize().height);
            graphics2D.setPaint(Color.black);
        }
        //repaint();
    }

    /**
     * draws to the draw pad
     * @param x is the x coordinate for pixel to draw
     * @param y is the y coordinate for pixel to draw
     */
    public void draw(int x, int y){
        if(graphics2D != null) {
            graphics2D.fillRect(x,y,PIXEL_SIZE,PIXEL_SIZE);
        }
        repaint();
    }

    public void drawPolygon(int[] x, int[] y, int nPoints){
        if(graphics2D != null) {
            graphics2D.drawPolygon(x, y, nPoints);
        }
        repaint();
    }

    public void fillPolygon(int[] x, int[] y, int nPoints){
        if(graphics2D != null) {
            graphics2D.fillPolygon(x, y, nPoints);
        }
        repaint();
    }
    public void changeColour (int x){
        if(graphics2D != null) {
            if (x == 1)
                graphics2D.setPaint(Color.red);
            else if (x == 2)
                graphics2D.setPaint(Color.green);
            else if (x == 3)
                graphics2D.setPaint(Color.blue);
            else
                graphics2D.setPaint(Color.black);
        }
    }
}
