package force.pi.projection;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Paint{
    private PadDraw DrawPad;
	public Paint(){

		JFrame frame = new JFrame("Draw");

		Container content = frame.getContentPane();
		content.setLayout(new BorderLayout());

        DrawPad = new PadDraw();
		content.add(DrawPad, BorderLayout.CENTER);
		
		JPanel panel = new JPanel();
		panel.setPreferredSize(new Dimension(32, 68));
		panel.setMinimumSize(new Dimension(32, 68));
		panel.setMaximumSize(new Dimension(32, 68));
		
		// plan to make it so that when we detect the tracker over 
		// certain parts of the screen we can simulate mouse clicks
		JButton clearButton = new JButton("Clear");
		clearButton.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				DrawPad.clear();
			}
		});

		panel.add(clearButton);

		content.add(panel, BorderLayout.WEST);
		
		frame.setSize(320, 240);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
	}

    public void draw(int x, int y){
        DrawPad.Draw(x, y);
    }

}





