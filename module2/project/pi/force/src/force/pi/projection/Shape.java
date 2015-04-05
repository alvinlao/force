package force.pi.projection;

import force.pi.Point3D;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Shaan on 03/04/2015.
 */
public class Shape {

    Polygon[] projectedPolygons;
    Point3D camPosition;

    Shape(List<Polygon> polygons, Point3D camPos) {
        projectedPolygons = new Polygon[polygons.size()];
        update(polygons, camPos);
    }

    void update(List<Polygon> polygons, Point3D camPos) {
        for (int i = 0; i < polygons.size(); i++) {
            projectedPolygons[i] = polygons.get(i);
            projectedPolygons[i].distanceToCamera = projectedPolygons[i].distanceToCamera;
        }
        camPosition = camPos;
        Arrays.sort(projectedPolygons);
    }


}