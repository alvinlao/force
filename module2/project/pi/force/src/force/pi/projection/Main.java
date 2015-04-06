package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.Shape;
import force.pi.projection.canvas.*;

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
        ShapeFactory eFactory = new EFactory();
        ShapeFactory oneFactory = new OneFactory();

        List<Shape> shapes = new ArrayList<Shape>();
        shapes.add(bb.build(-25, 0, 0));
        shapes.add(oneFactory.build(25, 0, 0));

        Canvas c = new Canvas(960, 720);
        Point3D cameraPoint = new Point3D(-150, 150, 100);

        int distance = 300;
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
