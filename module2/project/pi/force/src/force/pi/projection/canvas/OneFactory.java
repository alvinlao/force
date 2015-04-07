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
public class OneFactory extends LetterFactory {
    @Override
    public Shape build(int xOffset, int yOffset, int zOffset) {
        // Bottom A
        List<Point3D> bottomAPoints = new ArrayList<Point3D>();
        bottomAPoints.add(new Point3D(-0.5f, 0.5f, 0));
        bottomAPoints.add(new Point3D(0.5f, 0.5f, 0));
        bottomAPoints.add(new Point3D(0.5f, 0.5f, 1));
        bottomAPoints.add(new Point3D(-0.5f, 0.5f, 1));

        scalePoints(bottomAPoints);

        // Bottom B
        List<Point3D> bottomBPoints = new ArrayList<Point3D>();
        bottomBPoints.add(new Point3D(-0.25f, -0.25f, 0));
        bottomBPoints.add(new Point3D(-0.25f, -0.25f, 1));
        bottomBPoints.add(new Point3D(-0.1f, -0.35f, 1));
        bottomBPoints.add(new Point3D(-0.1f, -0.35f, 0));

        scalePoints(bottomBPoints);

        // Top B
        List<Point3D> topBPoints = new ArrayList<Point3D>();
        topBPoints.add(new Point3D(-0.4f, -0.35f, 0));
        topBPoints.add(new Point3D(-0.4f, -0.35f, 1));
        topBPoints.add(new Point3D(-0.25f, -0.25f, 1));
        topBPoints.add(new Point3D(-0.25f, -0.25f, 0));

        scalePoints(topBPoints);

        // Left A
        List<Point3D> leftAPoints = new ArrayList<Point3D>();
        leftAPoints.add(new Point3D(-0.1f, -0.5f, 0));
        leftAPoints.add(new Point3D(-0.5f, -0.35f, 0));
        leftAPoints.add(new Point3D(-0.5f, -0.35f, 1));
        leftAPoints.add(new Point3D(-0.1f, -0.5f, 1));

        scalePoints(leftAPoints);

        // Left B
        List<Point3D> leftBPoints = new ArrayList<Point3D>();
        leftBPoints.add(new Point3D(-0.4f, -0.35f, 0));
        leftBPoints.add(new Point3D(-0.4f, -0.35f, 1));
        leftBPoints.add(new Point3D(-0.25f, -0.25f, 1));
        leftBPoints.add(new Point3D(-0.25f, -0.25f, 0));

        scalePoints(leftBPoints);

        // Left C
        List<Point3D> leftCPoints = new ArrayList<Point3D>();
        leftCPoints.add(new Point3D(-0.1f, -0.35f, 0));
        leftCPoints.add(new Point3D(-0.1f, -0.35f, 1));
        leftCPoints.add(new Point3D(-0.1f, 0.25f, 1));
        leftCPoints.add(new Point3D(-0.1f, 0.25f, 0));

        scalePoints(leftCPoints);

        // Left D
        List<Point3D> leftDPoints = new ArrayList<Point3D>();
        leftDPoints.add(new Point3D(-0.5f, 0.25f, 0));
        leftDPoints.add(new Point3D(-0.5f, 0.25f, 1));
        leftDPoints.add(new Point3D(-0.5f, 0.5f, 1));
        leftDPoints.add(new Point3D(-0.5f, 0.5f, 0));

        scalePoints(leftDPoints);

        // Right A
        List<Point3D> rightAPoints = new ArrayList<Point3D>();
        rightAPoints.add(new Point3D(0.1f, -0.5f, 0));
        rightAPoints.add(new Point3D(0.1f, -0.5f, 1));
        rightAPoints.add(new Point3D(0.1f, 0.25f, 1));
        rightAPoints.add(new Point3D(0.1f, 0.25f, 0));

        scalePoints(rightAPoints);

        // Right B
        List<Point3D> rightBPoints = new ArrayList<Point3D>();
        rightBPoints.add(new Point3D(0.5f, 0.25f, 0));
        rightBPoints.add(new Point3D(0.5f, 0.25f, 1));
        rightBPoints.add(new Point3D(0.5f, 0.5f, 1));
        rightBPoints.add(new Point3D(0.5f, 0.5f, 0));

        scalePoints(rightBPoints);

        // Front 1
        List<Point3D> frontPoints = new ArrayList<Point3D>();
        frontPoints.add(new Point3D(-0.1f, -0.5f, 1));
        frontPoints.add(new Point3D(0.1f, -0.5f, 1));
        frontPoints.add(new Point3D(0.1f, 0.25f, 1));
        frontPoints.add(new Point3D(0.5f, 0.25f, 1));
        frontPoints.add(new Point3D(0.5f, 0.5f, 1));
        frontPoints.add(new Point3D(-0.5f, 0.5f, 1));
        frontPoints.add(new Point3D(-0.5f, 0.25f, 1));
        frontPoints.add(new Point3D(-0.1f, 0.25f, 1));
        frontPoints.add(new Point3D(-0.1f, -0.35f, 1));
        frontPoints.add(new Point3D(-0.25f, -0.25f, 1));
        frontPoints.add(new Point3D(-0.4f, -0.35f, 1));

        scalePoints(frontPoints);

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(leftBPoints, new Color(100, 100, 100)));
        polygons.add(new Polygon(leftCPoints, new Color(100, 100, 100)));
        polygons.add(new Polygon(leftDPoints, new Color(100, 100, 100)));
        polygons.add(new Polygon(rightAPoints, new Color(150, 150, 150)));
        polygons.add(new Polygon(rightBPoints, new Color(150, 150, 150)));
        polygons.add(new Polygon(topBPoints, new Color(167, 167, 167)));
        polygons.add(new Polygon(bottomAPoints, new Color(167, 167, 167)));
        polygons.add(new Polygon(bottomBPoints, new Color(167, 167, 167)));
        polygons.add(new Polygon(frontPoints, new Color(208, 208, 208)));

        // Shape
        Shape s = new Shape(polygons);
        applyOffset(s, xOffset, yOffset, zOffset);

        return s;
    }

    @Override
    public Shape build() {
        return null;
    }
}
