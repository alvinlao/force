package force.pi.projection;

import javax.swing.*;
import java.awt.*;
import java.awt.image.*;

/**
 * Sets up a draw pad to draw on.
 */
class PadDraw extends JComponent {
    static final int PIXEL_SIZE = 5;
    BufferedImage image;
    Graphics2D graphics2D;

    // Colors
    Color topColor;
    Color leftColor;
    Color rightColor;
    Color frontColor;

    public PadDraw(){
        // Colors
        topColor = new Color(198, 198, 198);
        leftColor = new Color(67, 67, 67);
        frontColor = new Color(140, 140, 140);
        rightColor = new Color(67, 67, 67);

        setDoubleBuffered(true);
    }

    @Override
    public void paintComponent(Graphics g){
	super.paintComponent(g);

        if(image == null){
            image = new BufferedImage(getSize().width, getSize().height, BufferedImage.TYPE_INT_RGB);
            graphics2D = image.createGraphics();
            graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            //clear();
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
            //graphics2D.setPaint(Color.white);
        }
    }

    /**
     * Updates the draw pad after everything has been drawn
     */
    public void update() {
        repaint();
    }

    /**
     * draws to the draw pad
     * @param x is the x coordinate for pixel to draw
     * @param y is the y coordinate for pixel to draw
     */
    public void draw(int x, int y){
        if(graphics2D != null) {
            graphics2D.fillRect(x, y, PIXEL_SIZE, PIXEL_SIZE);
        }
    }

    public void drawPolygon(int[] x, int[] y, int nPoints){
        if(graphics2D != null) {
            graphics2D.drawPolygon(x, y, nPoints);
        }
    }

    public void fillPolygon(int[] x, int[] y, int nPoints){
        if(graphics2D != null) {
            graphics2D.fillPolygon(x, y, nPoints);
        }
    }

    public void changeColour (int x){
        if(graphics2D != null) {
            if (x == 1)
                graphics2D.setPaint(Color.red);
            else if (x == 2)
                graphics2D.setPaint(topColor);
            else if (x == 3)
                graphics2D.setPaint(leftColor);
            else
                graphics2D.setPaint(frontColor);
        }
    }
}
