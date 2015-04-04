package force.pi.projection;

import force.pi.Point3D;

import java.util.Arrays;
import java.util.List;

/**
 * Created by Shaan on 03/04/2015.
 */
public class Shape {

    Polygon [] projectedPolygons;

    Shape(List<Polygon> polygons, Point3D camPos){
        update(polygons, camPos);
    }

    void update(List<Polygon> polygons, Point3D camPos){
        for(int i = 0; i < polygons.size(); i ++){
            projectedPolygons[i].copy(polygons.get(i));
            projectedPolygons[i].distanceToCamera = projectedPolygons[i].distanceToCamera;
        }

        Arrays.sort(projectedPolygons);
    }

}
