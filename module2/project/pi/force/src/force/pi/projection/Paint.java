package force.pi.projection;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import java.awt.Robot;
import java.awt.event.InputEvent;


public class Paint{
	public static void main(String[] args){

		JFrame frame = new JFrame("Draw");
		
		Container content = frame.getContentPane();
		content.setLayout(new BorderLayout());
		
		final PadDraw drawPad = new PadDraw();
		content.add(drawPad, BorderLayout.CENTER);
		
		JPanel panel = new JPanel();
		panel.setPreferredSize(new Dimension(32, 68));
		panel.setMinimumSize(new Dimension(32, 68));
		panel.setMaximumSize(new Dimension(32, 68));
		
		// plan to make it so that when we detect the tracker over 
		// certain parts of the screen we can simulate mouse clicks
		JButton clearButton = new JButton("Clear");
		clearButton.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				drawPad.clear();
			}
		});
		
		panel.add(clearButton);

		content.add(panel, BorderLayout.WEST);
		
		frame.setSize(1000, 600);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
	}
}


class PadDraw extends JComponent{
	Image image;
	Graphics2D graphics2D;
	
	int currentX, currentY, oldX, oldY;
	
	
	//for testing. need to change to buffered reader still. mouse for now
	public PadDraw(){
		setDoubleBuffered(false);
		addMouseListener(new MouseAdapter(){
			public void mousePressed(MouseEvent e){
				oldX = e.getX();
				oldY = e.getY();
			}
		});

		addMouseMotionListener(new MouseMotionAdapter(){
			public void mouseDragged(MouseEvent e){
				currentX = e.getX();
				currentY = e.getY();
				if(graphics2D != null)
				graphics2D.drawLine(oldX, oldY, currentX, currentY);
				repaint();
				oldX = currentX;
				oldY = currentY;
			}

		});
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
	
	
	/*
	// Havent tested yet. Maybe this will work. We can just move the mouse around?
	public moveMouse(int x, int y){

	Robot robot = new Robot();
	robot.mouseMove(x,y);
	
	}
	*/
	
}






