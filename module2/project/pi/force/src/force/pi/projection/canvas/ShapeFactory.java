package force.pi.projection.canvas;

import force.pi.projection.Shape;

/**
 * Created by alvinlao on 15-04-05.
 */
public abstract class ShapeFactory {
    public static final int scale = 50;

    public abstract Shape build(int x, int y, int z);
    public abstract Shape build();
}
