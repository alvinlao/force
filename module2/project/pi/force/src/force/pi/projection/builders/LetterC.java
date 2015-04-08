package force.pi.projection.builders;

import force.pi.Point3D;
import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.util.ArrayList;
import java.util.List;

public class LetterC extends ShapeSpec {
    protected float thickness = 0.02f / 4;

    @Override
    public Shape build() {
        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(-width / 2, -height / 2, depth));
        topPoints.add(new Point3D(width / 2, -height / 2, depth));
        topPoints.add(new Point3D(width / 2, -height / 2 + thickness, depth));
        topPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, depth));
        topPoints.add(new Point3D(-width / 2 + thickness, height / 2 - thickness, depth));
        topPoints.add(new Point3D(width / 2, height / 2 - thickness, depth));
        topPoints.add(new Point3D(width / 2, height / 2, depth));
        topPoints.add(new Point3D(-width / 2, height / 2, depth));

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-width / 2, -height / 2, 0));
        leftPoints.add(new Point3D(-width / 2, height / 2, 0));
        leftPoints.add(new Point3D(-width / 2, height / 2, depth));
        leftPoints.add(new Point3D(-width / 2, -height / 2, depth));

        // Right A
        List<Point3D> rightAPoints = new ArrayList<Point3D>();
        rightAPoints.add(new Point3D(width / 2, -height / 2, 0));
        rightAPoints.add(new Point3D(width / 2, -height / 2 + thickness, 0));
        rightAPoints.add(new Point3D(width / 2, -height / 2 + thickness, depth));
        rightAPoints.add(new Point3D(width / 2, -height / 2, depth));

        // Right B
        List<Point3D> rightBPoints = new ArrayList<Point3D>();
        rightBPoints.add(new Point3D(-width/2 + thickness, -height / 2 + thickness, 0));
        rightBPoints.add(new Point3D(-width/2 + thickness, height / 2 - thickness, 0));
        rightBPoints.add(new Point3D(-width/2 + thickness, height / 2 - thickness, depth));
        rightBPoints.add(new Point3D(-width/2 + thickness, -height / 2 + thickness, depth));

        // Right C
        List<Point3D> rightCPoints = new ArrayList<Point3D>();
        rightCPoints.add(new Point3D(width / 2, height / 2, 0));
        rightCPoints.add(new Point3D(width / 2, height / 2 - thickness, 0));
        rightCPoints.add(new Point3D(width / 2, height / 2 - thickness, depth));
        rightCPoints.add(new Point3D(width / 2, height / 2, depth));

        // Front A
        List<Point3D> frontAPoints = new ArrayList<Point3D>();
        frontAPoints.add(new Point3D(-width/2 + thickness, -height / 2 + thickness, 0));
        frontAPoints.add(new Point3D(width / 2, -height / 2 + thickness, 0));
        frontAPoints.add(new Point3D(width / 2, -height / 2 + thickness, depth));
        frontAPoints.add(new Point3D(-width/2 + thickness, -height / 2 + thickness, depth));

        // Front B
        List<Point3D> frontBPoints = new ArrayList<Point3D>();
        frontBPoints.add(new Point3D(-width / 2, height / 2, 0));
        frontBPoints.add(new Point3D(width / 2, height / 2, 0));
        frontBPoints.add(new Point3D(width / 2, height / 2, depth));
        frontBPoints.add(new Point3D(-width / 2, height / 2, depth));

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(leftPoints, leftColor));
        polygons.add(new Polygon(rightAPoints, rightColor));
        polygons.add(new Polygon(rightBPoints, rightColor));
        polygons.add(new Polygon(rightCPoints, rightColor));
        polygons.add(new Polygon(frontAPoints, frontColor));
        polygons.add(new Polygon(frontBPoints, frontColor));
        polygons.add(new Polygon(topPoints, topColor));

        Shape shape = new Shape(polygons);
        shape.applyOffset(xOffset, yOffset, zOffset);

        return shape;
    }
}
