package force.pi.projection;

import javax.swing.*;
import java.awt.*;

class PadDraw extends JComponent {
    Image image;
    Graphics2D graphics2D;

    //for testing. need to change to buffered reader still. mouse for now
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

    //clear screen
    public void clear(){
        graphics2D.setPaint(Color.white);
        graphics2D.fillRect(0, 0, getSize().width, getSize().height);
        graphics2D.setPaint(Color.black);
        repaint();
    }

    public void Draw (int x, int y){
        if(graphics2D != null)
            graphics2D.drawLine(x, y, x, y);
        repaint();
    }
}
