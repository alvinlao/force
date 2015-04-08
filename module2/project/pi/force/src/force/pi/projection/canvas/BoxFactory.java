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
    public Shape build(float xOffset, float yOffset, float zOffset) {
	float width = 0.02f;
	float height = 0.02f;
	float depth = 0.02f;

        // Right
        List<Point3D> rightPoints = new ArrayList<Point3D>();
        rightPoints.add(new Point3D(width/2, -height/2, 0));
        rightPoints.add(new Point3D(width/2, height/2, 0));
        rightPoints.add(new Point3D(width/2, height/2, depth));
        rightPoints.add(new Point3D(width/2, -height/2, depth));

        scalePoints(rightPoints);

        // Back
        List<Point3D> backPoints = new ArrayList<Point3D>();
        backPoints.add(new Point3D(width/2, -height/2, 0));
        backPoints.add(new Point3D(-width/2, -height/2, 0));
        backPoints.add(new Point3D(-width/2, -height/2, depth));
        backPoints.add(new Point3D(width/2, -height/2, depth));

        scalePoints(backPoints);

        // Front
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(width/2, height/2, 0));
        frontPoints.add(new Point3D(-width/2, height/2, 0));
        frontPoints.add(new Point3D(-width/2, height/2, depth));
        frontPoints.add(new Point3D(width/2, height/2, depth));

        scalePoints(frontPoints);

        // Left
        List<Point3D> leftPoints = new ArrayList<Point3D>();
        leftPoints.add(new Point3D(-width/2, -height/2, 0));
        leftPoints.add(new Point3D(-width/2, height/2, 0));
        leftPoints.add(new Point3D(-width/2, height/2, depth));
        leftPoints.add(new Point3D(-width/2, -height/2, depth));

        scalePoints(leftPoints);

        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(width/2, -height/2, depth));
        topPoints.add(new Point3D(-width/2, -height/2, depth));
        topPoints.add(new Point3D(-width/2, height/2, depth));
        topPoints.add(new Point3D(width/2, height/2, depth));

        scalePoints(topPoints);

        // Shadow
        List<Point3D> shadowPoints = new ArrayList<Point3D>();
        shadowPoints.add(new Point3D(width/2, -height/2, 0));
        shadowPoints.add(new Point3D(-width/2, height/2, 0));
        shadowPoints.add(new Point3D(-(3 * width / 2), -height/2, 0));
        shadowPoints.add(new Point3D(-(3 * width / 2), -(3 * height / 2), 0));
        shadowPoints.add(new Point3D(-width/2, -(3 * height / 2), 0));

        scalePoints(shadowPoints);

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        //polygons.add(new Polygon(shadowPoints, new Color(175, 175, 175)));
	polygons.add(new Polygon(backPoints, new Color(160, 160, 160)));
        polygons.add(new Polygon(leftPoints, new Color(160, 160, 160)));
        polygons.add(new Polygon(rightPoints, new Color(195, 195, 195)));
        polygons.add(new Polygon(topPoints, new Color(210, 210, 210)));
        polygons.add(new Polygon(frontPoints, new Color(190, 190, 190)));

        // Apply offset
        Shape s = new Shape(polygons);
        applyOffset(s, xOffset, yOffset, zOffset);
        s.setCentroid();

        return s;
    }

    @Override
    public Shape build() {
        return build(0, 0, 0);
    }
}
