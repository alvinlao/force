package force.pi.projection;

import force.pi.Point3D;

import java.awt.*;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Shaan on 03/04/2015.
 */
public class Polygon implements Comparable<Polygon> {

    public Point3D[] polyPoints;
    public Color color;
    double distanceToCamera;

    /**
     * Makes a polygon ready to be transformed into the 2d world
     * @param points assumes points are in a order where a line is drawn from one point to the next
     */
    Polygon(List<Point3D> points, Point3D camPos, Color color) {
        polyPoints = new Point3D[points.size()];
        this.color = color;
        distanceToCamera = distance(points, camPos);
    }

    @Override
    public int compareTo(Polygon other) {
        return (int) (other.distanceToCamera - this.distanceToCamera);
    }

    public double distance (List<Point3D> points, Point3D camPos){
        double distance = 1000;
        for(int i = 0; i < points.size(); i ++){
            if(points.get(i).distance(camPos) < distance){
                distance = points.get(i).distance(camPos);
            }
        }
        return distance;
    }
    public void copy(Polygon other) {
        this.polyPoints = other.polyPoints;
        this.color = other.color;
        this.distanceToCamera = other.distanceToCamera;
    }

}
