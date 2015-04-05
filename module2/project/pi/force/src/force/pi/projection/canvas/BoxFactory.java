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

        for (Point3D point : rightPoints) {
            Point3D.scale(scale, point);
        }

        // Front
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(0.5f, 0.5f, 0));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 0));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 1));
        frontPoints.add(new Point3D(0.5f, 0.5f, 1));

        for (Point3D point : frontPoints) {
            Point3D.scale(scale, point);
        }

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-0.5f, -0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 0));
        leftPoints.add(new Point3D(-0.5f, 0.5f, 1));
        leftPoints.add(new Point3D(-0.5f, -0.5f, 1));

        for (Point3D point : leftPoints) {
            Point3D.scale(scale, point);
        }

        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(0.5f, -0.5f, 1));
        topPoints.add(new Point3D(-0.5f, -0.5f, 1));
        topPoints.add(new Point3D(-0.5f, 0.5f, 1));
        topPoints.add(new Point3D(0.5f, 0.5f, 1));

        for (Point3D point : topPoints) {
            Point3D.scale(scale, point);
        }

        // Apply offset
        for (Point3D point : leftPoints) {
            point.x += xOffset;
            point.y += yOffset;
            point.z += zOffset;
        }

        for (Point3D point : rightPoints) {
            point.x += xOffset;
            point.y += yOffset;
            point.z += zOffset;
        }

        for (Point3D point : topPoints) {
            point.x += xOffset;
            point.y += yOffset;
            point.z += zOffset;
        }

        for (Point3D point : frontPoints) {
            point.x += xOffset;
            point.y += yOffset;
            point.z += zOffset;
        }

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(leftPoints, new Color(67, 67, 67)));
        polygons.add(new Polygon(rightPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(topPoints, new Color(208, 208, 208)));
        polygons.add(new Polygon(frontPoints, new Color(164, 164, 164)));

        return new Shape(polygons);
    }

    @Override
    public Shape build() {
        return build(0, 0, 0);
    }
}
