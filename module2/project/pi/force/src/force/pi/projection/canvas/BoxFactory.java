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
public class BoxFactory extends ShapeFactory {
    @Override
    public Shape build(int xOffset, int yOffset, int zOffset) {
        // Right
        List<Point3D> rightPoints = new ArrayList<Point3D>();
        rightPoints.add(new Point3D(0.5f, -0.5f, 0));
        rightPoints.add(new Point3D(0.5f, 0.5f, 0));
        rightPoints.add(new Point3D(0.5f, 0.5f, 1));
        rightPoints.add(new Point3D(0.5f, -0.5f, 1));

        scalePoints(rightPoints);

        // Front
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(0.5f, 0.5f, 0));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 0));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 1));
        frontPoints.add(new Point3D(0.5f, 0.5f, 1));

        scalePoints(frontPoints);

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-0.5f, -0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 1));
        leftPoints.add(new Point3D(-0.5f, -0.5f, 1));

        scalePoints(leftPoints);

        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(0.5f, -0.5f, 1));
        topPoints.add(new Point3D(-0.5f, -0.5f, 1));
        topPoints.add(new Point3D(-0.5f, 0.5f, 1));
        topPoints.add(new Point3D(0.5f, 0.5f, 1));

        scalePoints(topPoints);

        // Shadow
        List<Point3D> shadowPoints = new ArrayList<Point3D>();
        shadowPoints.add(new Point3D(0.5f, -0.5f, 0));
        shadowPoints.add(new Point3D(-0.5f, 0.5f, 0));
        shadowPoints.add(new Point3D(-1.5f, -0.5f, 0));
        shadowPoints.add(new Point3D(-1.5f, -1.5f, 0));
        shadowPoints.add(new Point3D(-0.5f, -1.5f, 0));

        scalePoints(shadowPoints);

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(shadowPoints, new Color(170, 170, 170)));
        polygons.add(new Polygon(leftPoints, new Color(160, 160, 160)));
        polygons.add(new Polygon(rightPoints, new Color(190, 190, 190)));
        polygons.add(new Polygon(topPoints, new Color(195, 195, 195)));
        polygons.add(new Polygon(frontPoints, new Color(185, 185, 185)));

        // Apply offset
        Shape s = new Shape(polygons);
        applyOffset(s, xOffset, yOffset, zOffset);

        return s;
    }

    @Override
    public Shape build() {
        return build(0, 0, 0);
    }
}
