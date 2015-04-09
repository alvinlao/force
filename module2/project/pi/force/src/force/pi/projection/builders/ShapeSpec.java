package force.pi.projection.builders;

import force.pi.projection.Polygon;
import force.pi.projection.Shape;
import force.pi.projection.builders.color.ColorScheme;

import java.awt.Color;
import java.util.List;

/**
 * Specifications to build a Shape
 *
 * Set the values using the builder pattern
 */
public abstract class ShapeSpec {
    // Default values
    protected static final float DEFAULT_SIZE = 0.02f;

    protected float width = DEFAULT_SIZE;
    protected float height = DEFAULT_SIZE;
    protected float depth = DEFAULT_SIZE;

    protected float xOffset = 0;
    protected float yOffset = 0;
    protected float zOffset = 0;

    protected Color backColor = new Color(133, 133, 133);
    protected Color frontColor = new Color(152, 152, 152);
    protected Color leftColor = new Color(133, 133, 133);
    protected Color rightColor = new Color(152, 152, 152);
    protected Color topColor = new Color(187, 187, 187);

    public ShapeSpec setOffset(float xOffset, float yOffset, float zOffset) {
        this.xOffset = xOffset;
        this.yOffset = yOffset;
        this.zOffset = zOffset;

        return this;
    }

    public ShapeSpec setWidth(float width) {
        this.width = width;
        return this;
    }

    public ShapeSpec setHeight(float height) {
        this.height = height;
        return this;
    }

    public ShapeSpec setDepth(float depth) {
        this.depth = depth;
        return this;
    }

    public ShapeSpec setSize(float width, float height, float depth) {
        this.width = width;
        this.height = height;
        this.depth = depth;

        return this;
    }

    public ShapeSpec setColorScheme(ColorScheme colorScheme) {
        setTopColor(colorScheme.topColor);
        setLeftColor(colorScheme.leftColor);
        setRightColor(colorScheme.rightColor);
        setFrontColor(colorScheme.frontColor);
        setBackColor(colorScheme.backColor);
        return this;
    }

    public ShapeSpec setFrontColor(Color color) {
        this.frontColor = color;
        return this;
    }

    public ShapeSpec setBackColor(Color color) {
        this.backColor = color;
        return this;
    }

    public ShapeSpec setTopColor(Color color) {
        this.topColor = color;
        return this;
    }

    public ShapeSpec setLeftColor(Color color) {
        this.leftColor = color;
        return this;
    }

    public ShapeSpec setRightColor(Color color) {
        this.rightColor = color;
        return this;
    }

    public abstract Shape build();

    /**
     * Create the shape
     * @param polygons
     * @return
     */
    protected Shape create(List<Polygon> polygons) {
        Shape s = new Shape(polygons);
        s.applyOffset(xOffset, yOffset, zOffset);
        return s;
    }
}
