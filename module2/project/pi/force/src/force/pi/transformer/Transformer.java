package force.pi.transformer;

import force.pi.Point;
import force.pi.Point3D;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Jae on 2015-03-18.
 */

public class Transformer {

    /**
     * transforms a given 3d point to a 2d point on z=0 while maintaining 3d effect if seen from cameraPoint
     * @param  cameraPoint Point3D of current camera location
     * @param  point Point3D of point to be transformed
     * @return Point of transformed point (2D)
     */
    public static Point transform3Dto2D(Point3D cameraPoint, Point3D point){
        //TODO: IMPLEMENT THIS
        return new Point();
    }

    /**
     * transforms a given set of 3d points to a set of 2d point on z=0 while maintaining 3d effect if seen from cameraPoint
     * @param  cameraPoint Point3D of current camera location
     * @param  points Set of of points to be transformed
     * @return HashSet of transformed Points
     */
    public static Set<Point> transform3Dto2D(Point3D cameraPoint, Set<Point3D> points){
        Set<Point> set = new HashSet<Point>();
        for(Point3D point : points){
            set.add(transform3Dto2D(cameraPoint,point));
        }
        return set;
    }
}
