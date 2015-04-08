package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.builders.LetterC;
import force.pi.projection.builders.Box;
import force.pi.projection.canvas.Canvas;

import java.awt.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by alvinlao on 15-04-03.
 */
public class Main {
    public static void main(String[] args) throws Exception {
        // Shapes
        List<Shape> shapes = new ArrayList<Shape>();
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
                .setTopColor(new Color(248, 210, 2))
                .setRightColor(new Color(225, 196, 36))
                .setFrontColor(new Color(225, 196, 36))
                .setLeftColor(new Color(179, 161, 60))
                .setBackColor(new Color(244, 215, 55))
                .build());

        shapes.add(new LetterC().setOffset(0.08f, -0.05f, -0.25f)
                .setWidth(0.015f)
                .build());

        // Canvas
        Canvas c = new Canvas();

        // Simulated camera
        Point3D camera = new Point3D(-0.15f, 0.1f, 0.4f);

        float distance = 0.3f;
        int time = 30;

        while (true) {
            // Move right
            for (int i = 0; i < time; ++i) {
                camera.x += distance/time;
                draw(c, shapes, camera);
                Thread.sleep(33);
            }

            // Move left
            for (int i = 0; i < time; ++i) {
                camera.x -= distance/time;
                draw(c, shapes, camera);
                Thread.sleep(33);
            }
        }
    }

    /**
     * Helper function
     * Draw shapes on canvas
     * @param c
     * @param shapes
     * @param camera
     */
    public static void draw(Canvas c, List<Shape> shapes, Point3D camera) {
        for (Shape shape : shapes) {
            shape.update(camera);
        }

        Collections.sort(shapes);

        c.draw(shapes);
    }
}
