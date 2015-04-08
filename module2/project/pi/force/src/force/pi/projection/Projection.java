package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.builders.Box;
import force.pi.projection.builders.LetterC;
import force.pi.projection.builders.LetterE;
import force.pi.projection.builders.color.Red;
import force.pi.projection.builders.color.Yellow;
import force.pi.projection.canvas.Canvas;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Project 3D builders onto a 2D plane
 */
public class Projection {
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
                .setOffset(-0.16f, -0.06f, -0.05f)
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

                */
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
