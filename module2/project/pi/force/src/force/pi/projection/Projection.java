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
