package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.builders.*;
import force.pi.projection.builders.color.Red;
import force.pi.projection.builders.color.Yellow;
import force.pi.projection.builders.color.Green;
import force.pi.projection.builders.color.Blue;
import force.pi.projection.builders.color.Purple;
import force.pi.projection.canvas.Canvas;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Project 3D builders onto a 2D plane
 */
public class Projection {
    // Grid constants
    private static final int INTENTSITY = 5;
    private static final float depth = 0.5f;
    private static final float screen_width = 0.46f;
    private static final float screen_height = 0.35f;

    Canvas canvas;
    List<Shape> shapes;

    public Projection() {
        canvas = new Canvas();

        // Shape list
        shapes = new ArrayList<Shape>();

        // Create a boxes
        shapes.add(new Box()
                .setOffset(0, 0, -0.02f)
                .build());

        shapes.add(new Box()
                .setOffset(-0.04f, -0.04f, -0.08f)
                .build());

        shapes.add(new Box()
                .setOffset(0.08f, 0.08f, -0.08f)
                .setColorScheme(new Red())
                .build());

        shapes.add(new Box()
                .setOffset(0.1f, 0.05f, -0.04f)
                .build());

        shapes.add(new Box()
                .setOffset(0.2f, -0.09f, -0.06f)
                .setColorScheme(new Yellow())
                .build());

        shapes.add(new Box()
                .setOffset(-0.18f, 0.08f, -0.03f)
                .build());

        shapes.add(new Box()
                .setColorScheme(new Green())
                .setOffset(-0.16f, -0.06f, -0.05f)
                .build());

        shapes.add(new Box()
                .setOffset(-0.09f, 0.005f, -0.16f)
                .build());

        shapes.add(new Box()
                .setColorScheme(new Blue())
                .setOffset(0.035f, -0.09f, -0.13f)
                .build());

        shapes.add(new Box()
                .setColorScheme(new Purple())
                .setOffset(-0.05f, 0.1f, -0.02f)
                .build());

        shapes.add(new Box()
                .setOffset(0.12f, -0.13f, -0.1f)
                .build());

        /*
        shapes.add(new Box().build());

        shapes.add(new Box()
                .setOffset(0.05f, -0.04f, -0.05f)
                .build());

        shapes.add(new Box()
                .setOffset(0.12f, 0.06f, -0.1f)
                .build());

        shapes.add(new Box()
                .setOffset(-0.02f, 0.09f, -0.12f)
                .build());

        shapes.add(new Box()
                .setOffset(-0.22f, -0.10f, -0.21f)
                .setColorScheme(new Red())
                .build());

        shapes.add(new LetterC().setOffset(0.08f, -0.05f, -0.0f)
                .setWidth(0.015f)
                .setDepth(0.01f)
                .build());

        shapes.add(new LetterE().setOffset(-0.018f, -0.06f, 0f)
                .setWidth(0.015f)
                .setDepth(0.01f)
                .build());
                */

        // Grid
        //left
        shapes.add(new Grid(INTENTSITY,depth,screen_height, Orientation.YZ).setOffset(-screen_width/2,-screen_height/2,-depth).build());
        //right
        shapes.add(new Grid(INTENTSITY,depth,screen_height,Orientation.YZ).setOffset(screen_width/2,-screen_height/2,-depth).build());
        //top
        shapes.add(new Grid(INTENTSITY,screen_width,depth,Orientation.XZ).setOffset(-screen_width/2,-screen_height/2,-depth).build());
        //bottom
        shapes.add(new Grid(INTENTSITY,screen_width,depth,Orientation.XZ).setOffset(-screen_width/2,screen_height/2,-depth).build());
        //back
        shapes.add(new Grid(INTENTSITY,screen_width,screen_height, Orientation.XY).setOffset(-screen_width / 2, -screen_height / 2, -depth).build());
    }

    /**
     * Run projection update
     * @param camera
     */
    public void update(Point3D camera) {
        for (Shape shape : shapes) {
            shape.update(camera);
        }

        Collections.sort(shapes);

        // Draw
        canvas.draw(shapes);
    }
}
