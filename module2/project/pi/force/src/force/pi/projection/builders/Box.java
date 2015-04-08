package force.pi.projection.builders;

import force.pi.Point3D;
import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.util.ArrayList;
import java.util.List;

/**
 * Build a box!
 * S
 */
public class Box extends ShapeSpec {
    @Override
    public Shape build() {
        // Right
        List<Point3D> rightPoints = new ArrayList<Point3D>();
        rightPoints.add(new Point3D(width/2, -height/2, 0));
        rightPoints.add(new Point3D(width/2, height/2, 0));
        rightPoints.add(new Point3D(width/2, height/2, depth));
        rightPoints.add(new Point3D(width/2, -height/2, depth));

        // Back
        List<Point3D> backPoints = new ArrayList<Point3D>();
        backPoints.add(new Point3D(width / 2, -height / 2, 0));
        backPoints.add(new Point3D(-width/2, -height/2, 0));
        backPoints.add(new Point3D(-width/2, -height/2, depth));
        backPoints.add(new Point3D(width / 2, height / 2, depth));

        // Front
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(width / 2, height / 2, 0));
        frontPoints.add(new Point3D(-width/2, height/2, 0));
        frontPoints.add(new Point3D(-width / 2, height / 2, depth));
        frontPoints.add(new Point3D(width / 2, height / 2, depth));

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-width / 2, -height / 2, 0));
        leftPoints.add(new Point3D(-width/2, height/2, 0));
        leftPoints.add(new Point3D(-width/2, height/2, depth));
        leftPoints.add(new Point3D(-width / 2, -height / 2, depth));

        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(width / 2, -height / 2, depth));
        topPoints.add(new Point3D(-width/2, -height/2, depth));
        topPoints.add(new Point3D(-width/2, height/2, depth));
        topPoints.add(new Point3D(width / 2, height / 2, depth));

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(backPoints, backColor));
        polygons.add(new Polygon(leftPoints, leftColor));
        polygons.add(new Polygon(rightPoints, rightColor));
        polygons.add(new Polygon(topPoints, topColor));
        polygons.add(new Polygon(frontPoints, frontColor));

        // Shape
        return create(polygons);
    }
}
