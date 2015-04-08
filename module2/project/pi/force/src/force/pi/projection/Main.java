package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.builders.LetterC;
import force.pi.projection.builders.Box;
import force.pi.projection.builders.LetterE;
import force.pi.projection.builders.color.Red;
import force.pi.projection.builders.color.Yellow;
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
                .setOffset(0, 0, -0.1f)
                .build());

        shapes.add(new Box()
                .setOffset(0, 0, -0.2f)
                .build());

//        shapes.add(new Box()
//                .setOffset(0.05f, -0.04f, -0.05f)
//                .build());
//
//        shapes.add(new Box()
//                .setOffset(0.12f, 0.06f, -0.1f)
//                .build());
//
//        shapes.add(new Box()
//                .setOffset(-0.02f, 0.09f, -0.12f)
//                .setColorScheme(new Red())
//                .build());
//
//        shapes.add(new Box()
//                .setOffset(-0.22f, -0.10f, -0.21f)
//                .setColorScheme(new Yellow())
//                .build());
//
//        shapes.add(new LetterC().setOffset(0.08f, -0.05f, -0.0f)
//                .setWidth(0.015f)
//                .setDepth(0.01f)
//                .build());
//
//        shapes.add(new LetterE().setOffset(-0.018f, -0.06f, 0f)
//                .setWidth(0.015f)
//                .setDepth(0.01f)
//                .build());

        // Canvas
        Canvas c = new Canvas();

        // Simulated camera
        float distanceX = 0.3f;
        float distanceY = 0f;
        int time = 60;
        Point3D camera = new Point3D(-distanceX/2, -distanceY/2, 0.4f);

        while (true) {
            // Move right
            for (int i = 0; i < time; ++i) {
                camera.x += distanceX/time;
                draw(c, shapes, camera);
                Thread.sleep(33);
            }

            // Move down
            for (int i = 0; i < time; ++i) {
                camera.y += distanceY/time;
                draw(c, shapes, camera);
                Thread.sleep(33);
            }

            // Move left
            for (int i = 0; i < time; ++i) {
                camera.x -= distanceX/time;
                draw(c, shapes, camera);
                Thread.sleep(33);
            }

            // Move up
            for (int i = 0; i < time; ++i) {
                camera.y -= distanceY/time;
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
