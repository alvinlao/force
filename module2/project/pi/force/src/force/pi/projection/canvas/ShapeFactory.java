package force.pi.projection.canvas;

import force.pi.projection.Shape;

/**
 * Created by alvinlao on 15-04-05.
 */
public abstract class ShapeFactory {
    public static final int scale = 25;

    public abstract Shape build(int xOffset, int yOffset, int zOffset);
    public abstract Shape build();
}
