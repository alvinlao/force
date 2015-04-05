package force.pi.projection.canvas;

import force.pi.projection.Shape;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by alvinlao on 15-04-03.
 */
public class Main {
    public static void main(String[] args) {
        // Box!
        BoxFactory bb = new BoxFactory();
        List<Shape> shapes = new ArrayList<Shape>();
        shapes.add(bb.build());

        Canvas c = new Canvas();

        while (true) {
            c.draw(shapes);
        }
    }
}
