package force.pi.projection;

import force.pi.Point3D;

import force.pi.projection.builders.LetterC;
import force.pi.projection.canvas.*;
import force.pi.projection.builders.Box;
import force.pi.projection.canvas.Canvas;

import java.awt.*;
import java.util.ArrayList;
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
        shapes.add(new Box().build());

        shapes.add(new Box()
                .setOffset(0, 0, -0.1f)
                .build());

        shapes.add(new Box()
                .setOffset(0, 0, -0.2f)
                .build());
        shapes.add(new Box().build());
    }

    /**
     * Run projection update
     * @param camera
     */
    public void update(Point3D camera) {
        for (Shape shape : shapes) {
            shape.update(camera);
        }

        //Collections.sort(builders);

        // Draw
        canvas.draw(shapes);
    }
}
