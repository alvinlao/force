package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.canvas.BoxFactory;
import force.pi.projection.canvas.Canvas;
import force.pi.projection.canvas.ShapeFactory;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Shaan on 17/03/2015.
 * need to pass in camera coordinates
 * call public method "projectIt(Point3D B)"
 * where B is camera coordinates
 */
public class Projection {
    static final int SCREEN_WIDTH = 960;
    static final int SCREEN_HEIGHT = 720;

    Canvas canvas;
    List<Shape> shapes;

    public Projection() {
        canvas = new Canvas(SCREEN_WIDTH, SCREEN_HEIGHT);

        // Shape factory
        ShapeFactory bb = new BoxFactory();

        // Shape list
        shapes = new ArrayList<Shape>();

        // Create a box
        shapes.add(bb.build());
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
