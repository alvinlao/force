package force.pi.projection;

import force.pi.Point3D;

import force.pi.projection.canvas.BoxFactory;
import force.pi.projection.canvas.CFactory;
import force.pi.projection.canvas.EFactory;
import force.pi.projection.canvas.Canvas;
import force.pi.projection.canvas.EFactory;
import force.pi.projection.canvas.ShapeFactory;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Project 3D shapes onto a 2D plane
 */
public class Projection {
    Canvas canvas;
    List<Shape> shapes;

    public Projection() {
        canvas = new Canvas();

        // Shape factory
        ShapeFactory shapeFactory = new BoxFactory();

        // Shape list
        shapes = new ArrayList<Shape>();

        // Create a box
        shapes.add(shapeFactory.build(0, 0, 0));
    }

    /**
     * Run projection update
     * @param camera
     */
    public void update(Point3D camera) {
        for (Shape shape : shapes) {
            shape.update(camera);
        }

        //Collections.sort(shapes);

        // Draw
        canvas.draw(shapes);
    }
}
