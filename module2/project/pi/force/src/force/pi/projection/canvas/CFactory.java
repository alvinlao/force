package force.pi.projection.canvas;

import force.pi.Point3D;
import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by alvinlao on 15-04-05.
 */
public class CFactory extends LetterFactory {

    @Override
    public Shape build(int xOffset, int yOffset, int zOffset) {
        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(-0.5f, -0.5f, 1));
        topPoints.add(new Point3D(0.5f, -0.5f, 1));
        topPoints.add(new Point3D(0.5f, -0.22f, 1));
        topPoints.add(new Point3D(-0.22f, -0.22f, 1));
        topPoints.add(new Point3D(-0.22f, 0.22f, 1));
        topPoints.add(new Point3D(0.5f, 0.22f, 1));
        topPoints.add(new Point3D(0.5f, 0.5f, 1));
        topPoints.add(new Point3D(-0.5f, 0.5f, 1));
        scalePoints(topPoints);

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-0.5f, -0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 1));
        leftPoints.add(new Point3D(-0.5f, -0.5f, 1));
        scalePoints(leftPoints);

        // Right A
        List<Point3D> rightAPoints = new ArrayList<Point3D>();
        rightAPoints.add(new Point3D(0.5f, -0.5f, 0));
        rightAPoints.add(new Point3D(0.5f, -0.22f, 0));
        rightAPoints.add(new Point3D(0.5f, -0.22f, 1));
        rightAPoints.add(new Point3D(0.5f, -0.5f, 1));
        scalePoints(rightAPoints);

        // Right B
        List<Point3D> rightBPoints = new ArrayList<Point3D>();
        rightBPoints.add(new Point3D(-0.22f, -0.22f, 0));
        rightBPoints.add(new Point3D(-0.22f, 0.22f, 0));
        rightBPoints.add(new Point3D(-0.22f, 0.22f, 1));
        rightBPoints.add(new Point3D(-0.22f, -0.22f, 1));
        scalePoints(rightBPoints);

        // Right C
        List<Point3D> rightCPoints = new ArrayList<Point3D>();
        rightCPoints.add(new Point3D(0.5f, 0.5f, 0));
        rightCPoints.add(new Point3D(0.5f, 0.22f, 0));
        rightCPoints.add(new Point3D(0.5f, 0.22f, 1));
        rightCPoints.add(new Point3D(0.5f, 0.5f, 1));
        scalePoints(rightCPoints);

        // Front A
        List<Point3D> frontAPoints = new ArrayList<Point3D>();
        frontAPoints.add(new Point3D(-0.22f, -0.22f, 0));
        frontAPoints.add(new Point3D(0.5f, -0.22f, 0));
        frontAPoints.add(new Point3D(0.5f, -0.22f, 1));
        frontAPoints.add(new Point3D(-0.22f, -0.22f, 1));
        scalePoints(frontAPoints);

        // Front B
        List<Point3D> frontBPoints = new ArrayList<Point3D>();
        frontBPoints.add(new Point3D(-0.5f, 0.5f, 0));
        frontBPoints.add(new Point3D(0.5f, 0.5f, 0));
        frontBPoints.add(new Point3D(0.5f, 0.5f, 1));
        frontBPoints.add(new Point3D(-0.5f, 0.5f, 1));
        scalePoints(frontBPoints);

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(leftPoints, new Color(100, 100, 100)));
        polygons.add(new Polygon(rightAPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(rightBPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(rightCPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(frontAPoints, new Color(168, 168, 168)));
        polygons.add(new Polygon(frontBPoints, new Color(168, 168, 168)));
        polygons.add(new Polygon(topPoints, new Color(208, 208, 208)));

        Shape s = new Shape(polygons);
        applyOffset(s, xOffset, yOffset, zOffset);

        return s;
    }

    @Override
    public Shape build() {
        return build(0, 0, 0);
    }
}
