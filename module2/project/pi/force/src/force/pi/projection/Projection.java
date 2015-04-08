package force.pi.projection;

import force.pi.Point3D;

import force.pi.projection.canvas.*;
import force.pi.projection.builders.Box;

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

        // Create a box
        shapes.add(new Box().build());
        shapes.add(new Box().setOffset(0.05f, -0.04f, -0.05f).build());
        shapes.add(new Box().setOffset(0.12f, 0.06f, -0.1f).build());
        shapes.add(new Box().setOffset(-0.02f, 0.09f, -0.12f).build());
        shapes.add(new Box().setOffset(-0.22f, -0.10f, -0.21f).build());
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
