package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.Shape;
import force.pi.projection.canvas.BoxFactory;
import force.pi.projection.canvas.Canvas;
import force.pi.projection.canvas.ShapeFactory;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by alvinlao on 15-04-03.
 */
public class Main {
    public static void main(String[] args) throws Exception {
        // Box!
        ShapeFactory bb = new BoxFactory();
        List<Shape> shapes = new ArrayList<Shape>();
        shapes.add(bb.build());

        Canvas c = new Canvas(960, 720);
        Point3D cameraPoint = new Point3D(-100, 100, 200);

        int distance = 200;
        int time = 30;

        while (true) {
            // Move right
            for (int i = 0; i < time; ++i) {
                cameraPoint.x += distance/time;
                draw(c, shapes, cameraPoint);
                Thread.sleep(33);
            }

            // Move left
            for (int i = 0; i < time; ++i) {
                cameraPoint.x -= distance/time;
                draw(c, shapes, cameraPoint);
                Thread.sleep(33);
            }

        }
    }

    public static void draw(Canvas c, List<Shape> shapes, Point3D camera) {
        for (Shape shape : shapes) {
            shape.update(camera);
        }

        Collections.sort(shapes);

        c.draw(shapes);
    }
}
