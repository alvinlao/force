package force.pi.projection;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

/**
 * Sets up window and draw pad for drawing
 */

public class Paint {
    static final int SCREEN_WIDTH = 960;
    static final int SCREEN_HEIGHT = 720;
    private PadDraw drawPad;

	public Paint() {

		JFrame frame = new JFrame("Draw");

		Container content = frame.getContentPane();
		content.setLayout(new BorderLayout());

        drawPad = new PadDraw();
		content.add(drawPad, BorderLayout.CENTER);
		
		JPanel panel = new JPanel();
        panel.setPreferredSize(new Dimension(32, 68));
        panel.setMinimumSize(new Dimension(32, 68));
		panel.setMaximumSize(new Dimension(32, 68));

		JButton clearButton = new JButton("Clear");
		clearButton.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				drawPad.clear();
			}
		});

		panel.add(clearButton);

		content.add(panel, BorderLayout.WEST);
		
		frame.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
	}

    /**
     * Clears the draw pad
     */
    public void clear(){
        drawPad.clear();
    }

    /**
     * Draws pixel at x, y coordinate given in
     * @param x
     * @param y
     */
    public void draw(int x, int y){
        drawPad.draw(x, y);
    }

    public void drawPolygon(int[] x, int[]y, int nPoints) {
        drawPad.drawPolygon(x, y, nPoints);
    }
    public void fillPolygon(int[] x, int[]y, int nPoints, int col) {
        drawPad.changeColour(col);
        drawPad.fillPolygon(x, y, nPoints);
    }
}





