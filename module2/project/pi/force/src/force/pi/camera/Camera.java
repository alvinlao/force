package force.pi.camera;

import force.pi.Frame;
import force.pi.Point;
import force.pi.Point3D;

/**
 * Background:
 * A camera is used to track two objects.
 * The coordinates of these two points on the camera frame is known.
 * The purpose of this class is to transform these two 2D points into a 3D point.
 *
 * Assumptions:
 * 1) The line the two points form is perpendicular to the origin point at all times.
 * 2) These two points are a fixed distance from each other in reality at all times.
 *
 * NOTE: Variables containing real life measurements are prefixed with a 'r'
 *
 * VERSION 1: This version makes extra assumptions
 * 1) The object is one point
 * 2) The object is a fixed distance (rFixedDistance) from the camera at all times
 * 3) The origin point is the camera location
 *
 */
public class Camera {
    // Our object's two point distance to camera ratio: 
    // Frame width / z = object real width / distance from camera to fill screen
    private static final float R_FIXED_POINTS_RATIO = Frame.WIDTH * (0.136f / 0.33f);

    // The real fixed distance between the two points (in meters)
    private static final float R_FIXED_POINTS_DISTANCE = 1f;       // TODO

    // Conversion factor: C = real distance / camera distance
    private static final float CAMERA_TO_REAL_CONVERSION = 0.004166f;

    // TODO: Version 1 assumption
    private static final float R_FIXED_DISTANCE = 1f;

    private Point3D transformedPoint = new Point3D();

    // TODO
    public void calibrate() {

    }

    /**
     * Transforms two camera 2D points into a real world 3D point
     *
     * @param left
     * @param right
     * @return
     */
    public Point3D transform2Dto3D(final Point left, final Point right) {
        // TODO Version one only uses one point
        transformedPoint.x = (left.x - (Frame.WIDTH/2.0f)) * CAMERA_TO_REAL_CONVERSION * -1;
        transformedPoint.y = (left.y - (Frame.HEIGHT/2.0f)) * CAMERA_TO_REAL_CONVERSION;
        transformedPoint.z = (float) Math.sqrt(Math.pow(R_FIXED_DISTANCE, 2) - Math.pow(transformedPoint.x, 2) - Math.pow(transformedPoint.y, 2));

        return transformedPoint;
    }

    private float calculateZ(final Point left, final Point right) {
        return left.distance(right) * R_FIXED_POINTS_RATIO;
    }
}
