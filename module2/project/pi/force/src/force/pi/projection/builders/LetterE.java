package force.pi.projection.builders;

import force.pi.Point3D;
import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.util.ArrayList;
import java.util.List;

public class LetterE extends ShapeSpec {
    public float thickness = DEFAULT_SIZE / 5;

    @Override
    public Shape build() {
        // Back A
        List<Point3D> backAPoints = new ArrayList<Point3D>();
        backAPoints.add(new Point3D(width / 2, -height / 2, 0));
        backAPoints.add(new Point3D(-width / 2, -height / 2, 0));
        backAPoints.add(new Point3D(-width / 2, -height / 2, depth));
        backAPoints.add(new Point3D(width / 2, -height / 2, depth));

        // Back B
        List<Point3D> backBPoints = new ArrayList<Point3D>();
        backBPoints.add(new Point3D(-width / 2 + thickness, -thickness / 2, 0));
        backBPoints.add(new Point3D(width / 2, -thickness / 2, 0));
        backBPoints.add(new Point3D(width / 2, -thickness / 2, depth));
        backBPoints.add(new Point3D(-width / 2 + thickness, -thickness / 2, depth));

        // Back C
        List<Point3D> backCPoints = new ArrayList<Point3D>();
        backCPoints.add(new Point3D(-width / 2 + thickness, height / 2 - thickness, 0));
        backCPoints.add(new Point3D(width / 2, height / 2 - thickness, 0));
        backCPoints.add(new Point3D(width / 2, height / 2 - thickness, depth));
        backCPoints.add(new Point3D(-width / 2 + thickness, height / 2 - thickness, depth));

        // Front A
        List<Point3D> frontAPoints = new ArrayList<Point3D>();
        frontAPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, 0));
        frontAPoints.add(new Point3D(width / 2, -height / 2 + thickness, 0));
        frontAPoints.add(new Point3D(width / 2, -height / 2 + thickness, depth));
        frontAPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, depth));

        // Front B
        List<Point3D> frontBPoints = new ArrayList<Point3D>();
        frontBPoints.add(new Point3D(-width / 2 + thickness, thickness / 2, 0));
        frontBPoints.add(new Point3D(width / 2, thickness / 2, 0));
        frontBPoints.add(new Point3D(width / 2, thickness / 2, depth));
        frontBPoints.add(new Point3D(-width / 2 + thickness, thickness / 2, depth));

        // Front C
        List<Point3D> frontCPoints = new ArrayList<Point3D>();
        frontCPoints.add(new Point3D(width / 2, height / 2, 0));
        frontCPoints.add(new Point3D(-width / 2, height / 2, 0));
        frontCPoints.add(new Point3D(-width / 2, height / 2, depth));
        frontCPoints.add(new Point3D(width / 2, height / 2, depth));

        // Top
        List<Point3D> topPoints = new ArrayList<Point3D>();
        topPoints.add(new Point3D(-width / 2, -height / 2, depth));
        topPoints.add(new Point3D(width / 2, -height / 2, depth));
        topPoints.add(new Point3D(width / 2, -height / 2 + thickness, depth));
        topPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, depth));
        topPoints.add(new Point3D(-width / 2 + thickness, -thickness / 2, depth));
        topPoints.add(new Point3D(width / 2, -thickness / 2, depth));
        topPoints.add(new Point3D(width / 2, thickness / 2, depth));
        topPoints.add(new Point3D(-width / 2 + thickness, thickness / 2, depth));
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
        rightBPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, 0));
        rightBPoints.add(new Point3D(-width / 2 + thickness, -thickness / 2, 0));
        rightBPoints.add(new Point3D(-width / 2 + thickness, -thickness / 2, depth));
        rightBPoints.add(new Point3D(-width / 2 + thickness, -height / 2 + thickness, depth));
        
        // Right C
        List<Point3D> rightCPoints = new ArrayList<Point3D>();
        rightCPoints.add(new Point3D(width / 2, -thickness / 2, 0));
        rightCPoints.add(new Point3D(width / 2, thickness / 2, 0));
        rightCPoints.add(new Point3D(width / 2, thickness / 2, depth));
        rightCPoints.add(new Point3D(width / 2, -thickness / 2, depth));

        // Right D
        List<Point3D> rightDPoints = new ArrayList<Point3D>();
        rightDPoints.add(new Point3D(-width / 2 + thickness, thickness / 2, 0));
        rightDPoints.add(new Point3D(-width / 2 + thickness, height / 2 - thickness, 0));
        rightDPoints.add(new Point3D(-width / 2 + thickness, height / 2 - thickness, depth));
        rightDPoints.add(new Point3D(-width / 2 + thickness, thickness / 2, depth));

        // Right E
        List<Point3D> rightEPoints = new ArrayList<Point3D>();
        rightEPoints.add(new Point3D(width / 2, height / 2 - thickness, 0));
        rightEPoints.add(new Point3D(width / 2, height / 2, 0));
        rightEPoints.add(new Point3D(width / 2, height / 2, depth));
        rightEPoints.add(new Point3D(width / 2, height / 2 - thickness, depth));

        // Polygons
        List<Polygon> polygons = new ArrayList<Polygon>();
        polygons.add(new Polygon(backAPoints, backColor));
        polygons.add(new Polygon(backBPoints, backColor));
        polygons.add(new Polygon(backCPoints, backColor));
        polygons.add(new Polygon(frontAPoints, frontColor));
        polygons.add(new Polygon(frontBPoints, frontColor));
        polygons.add(new Polygon(frontCPoints, frontColor));
        polygons.add(new Polygon(leftPoints, leftColor));
        polygons.add(new Polygon(topPoints, topColor));
        polygons.add(new Polygon(rightAPoints, rightColor));
        polygons.add(new Polygon(rightBPoints, rightColor));
        polygons.add(new Polygon(rightCPoints, rightColor));
        polygons.add(new Polygon(rightDPoints, rightColor));
        polygons.add(new Polygon(rightEPoints, rightColor));

        return create(polygons);
    }
}
