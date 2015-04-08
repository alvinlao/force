package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.builders.Box;
import force.pi.projection.builders.Grid;
import force.pi.projection.builders.Orientation;
import force.pi.projection.builders.color.Blue;
import force.pi.projection.builders.color.Purple;
import force.pi.projection.canvas.Canvas;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by alvinlao on 15-04-03.
 */
public class Main {


    private static final int INTENTSITY = 5;
    private static final float depth = 0.5f;
    private static final float screen_width = 0.4f;
    private static final float screen_height = 0.22f;


    public static void main(String[] args) throws Exception {
        // Shapes
        List<Shape> shapes = new ArrayList<Shape>();
        shapes.add(new Box().build());

        shapes.add(new Box()
                .setColorScheme(new Blue())
                .setOffset(0, 0, -0.1f)
                .build());

        shapes.add(new Box()
                .setColorScheme(new Purple())
                .setOffset(0, 0, -0.2f)
                .build());

        //shapes.add(new Grid(INTENTSITY, screen_width, depth, Orientation.XZ).build());

        //left
        shapes.add(new Grid(INTENTSITY,depth,screen_height, Orientation.YZ).setOffset(-screen_width/2,-screen_height/2,-depth).build());
        //right
        shapes.add(new Grid(INTENTSITY,depth,screen_height,Orientation.YZ).setOffset(screen_width/2,-screen_height/2,-depth).build());
        //top
        shapes.add(new Grid(INTENTSITY,screen_width,depth,Orientation.XZ).setOffset(-screen_width/2,-screen_height/2,-depth).build());
        //bottom
        shapes.add(new Grid(INTENTSITY,screen_width,depth,Orientation.XZ).setOffset(-screen_width/2,screen_height/2,-depth).build());
        //back
        shapes.add(new Grid(INTENTSITY,screen_width,screen_height,Orientation.XY).setOffset(-screen_width/2,-screen_height/2,-depth).build());



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
        float distanceY = 0.3f;
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
