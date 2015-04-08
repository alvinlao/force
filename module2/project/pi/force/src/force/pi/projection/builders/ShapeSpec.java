package force.pi.projection.builders;

import force.pi.projection.Shape;

import java.awt.Color;

/**
 * Specifications to build a Shape
 *
 * Set the values using the builder pattern
 */
public abstract class ShapeSpec {
    // Default values

    protected float width = 0.02f;
    protected float height = 0.02f;
    protected float depth = 0.02f;

    protected float xOffset = 0;
    protected float yOffset = 0;
    protected float zOffset = 0;

    protected Color backColor = new Color(160, 160, 160);
    protected Color frontColor = new Color(190, 190, 190);
    protected Color leftColor = new Color(160, 160, 160);
    protected Color rightColor = new Color(195, 195, 195);
    protected Color topColor = new Color(210, 210, 210);

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
}
