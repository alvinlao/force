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
public class EFactory extends LetterFactory {
    @Override
    public Shape build(float xOffset, float yOffset, float zOffset) {
        // Front E
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(-0.5f, 0.5f, 0));
        frontPoints.add(new Point3D(0.5f, 0.5f, 0));

        frontPoints.add(new Point3D(0.5f, 0.5f, 0.2f));
        frontPoints.add(new Point3D(0f, 0.5f, 0.2f));
        frontPoints.add(new Point3D(0f, 0.5f, 0.4f));
        frontPoints.add(new Point3D(0.5f, 0.5f, 0.4f));
        frontPoints.add(new Point3D(0.5f, 0.5f, 0.6f));
        frontPoints.add(new Point3D(0f, 0.5f, 0.6f));
        frontPoints.add(new Point3D(0f, 0.5f, 0.8f));
        frontPoints.add(new Point3D(0.5f, 0.5f, 0.8f));
        frontPoints.add(new Point3D(0.5f, 0.5f, 1f));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 1f));

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
        topPoints.add(new Point3D(-0.5f, -0.5f, 1));
        topPoints.add(new Point3D(0.5f, -0.5f, 1));
        topPoints.add(new Point3D(0.5f, 0.5f, 1));
        topPoints.add(new Point3D(-0.5f, 0.5f, 1));

        scalePoints(topPoints);

        // Right A
        List<Point3D> rightAPoints = new ArrayList<Point3D>();
        rightAPoints.add(new Point3D(0.5f, -0.5f, 1));
        rightAPoints.add(new Point3D(0.5f, 0.5f, 1));
        rightAPoints.add(new Point3D(0.5f, 0.5f, 0.8f));
        rightAPoints.add(new Point3D(0.5f, -0.5f, 0.8f));

        scalePoints(rightAPoints);

        // Right B
        List<Point3D> rightBPoints = new ArrayList<Point3D>();
        rightBPoints.add(new Point3D(0, -0.5f, 0.8f));
        rightBPoints.add(new Point3D(0, 0.5f, 0.8f));
        rightBPoints.add(new Point3D(0, 0.5f, 0.6f));
        rightBPoints.add(new Point3D(0, -0.5f, 0.6f));

        scalePoints(rightBPoints);

        // Right C
        List<Point3D> rightCPoints = new ArrayList<Point3D>();
        rightCPoints.add(new Point3D(0.5f, -0.5f, 0.6f));
        rightCPoints.add(new Point3D(0.5f, 0.5f, 0.6f));
        rightCPoints.add(new Point3D(0.5f, 0.5f, 0.4f));
        rightCPoints.add(new Point3D(0.5f, -0.5f, 0.4f));

        scalePoints(rightCPoints);

        // Right D
        List<Point3D> rightDPoints = new ArrayList<Point3D>();
        rightDPoints.add(new Point3D(0, -0.5f, 0.4f));
        rightDPoints.add(new Point3D(0, 0.5f, 0.4f));
        rightDPoints.add(new Point3D(0, 0.5f, 0.2f));
        rightDPoints.add(new Point3D(0, -0.5f, 0.2f));

        scalePoints(rightDPoints);

        // Right E
        List<Point3D> rightEPoints = new ArrayList<Point3D>();
        rightEPoints.add(new Point3D(0.5f, -0.5f, 0.2f));
        rightEPoints.add(new Point3D(0.5f, 0.5f, 0.2f));
        rightEPoints.add(new Point3D(0.5f, 0.5f, 0));
        rightEPoints.add(new Point3D(0.5f, -0.5f, 0));

        scalePoints(rightEPoints);


        // Top A
        List<Point3D> topAPoints = new ArrayList<Point3D>();
        topAPoints.add(new Point3D(0, -0.5f, 0.6f));
        topAPoints.add(new Point3D(0, 0.5f, 0.6f));
        topAPoints.add(new Point3D(0.5f, 0.5f, 0.6f));
        topAPoints.add(new Point3D(0.5f, -0.5f, 0.6f));

        scalePoints(topAPoints);

        // Top B
        List<Point3D> topBPoints = new ArrayList<Point3D>();
        topBPoints.add(new Point3D(0, -0.5f, 0.2f));
        topBPoints.add(new Point3D(0, 0.5f, 0.2f));
        topBPoints.add(new Point3D(0.5f, 0.5f, 0.2f));
        topBPoints.add(new Point3D(0.5f, -0.5f, 0.2f));

        scalePoints(topBPoints);

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(leftPoints, new Color(100, 100, 100)));
        polygons.add(new Polygon(topBPoints, new Color(125, 125, 125)));
        polygons.add(new Polygon(topAPoints, new Color(125, 125, 125)));
        polygons.add(new Polygon(topPoints, new Color(208, 208, 208)));
        polygons.add(new Polygon(rightAPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(rightBPoints, new Color(150, 150, 150)));
        polygons.add(new Polygon(rightCPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(rightDPoints, new Color(150, 150, 150)));
        polygons.add(new Polygon(rightEPoints, new Color(224, 224, 224)));
        polygons.add(new Polygon(frontPoints, new Color(167, 167, 167)));

        // Shape
        Shape s = new Shape(polygons);
        applyOffset(s, xOffset, yOffset, zOffset);

        return s;
    }

    @Override
    public Shape build() {
        return build(0, 0, 0);
    }
}
