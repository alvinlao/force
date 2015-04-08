package force.pi.camera;

import java.lang.Math.*;

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
    // Real width of object: (m)
    private static final float R_OBJECT_WIDTH = 0.154f;

    // Real distance from camera for object to fill screen horizontally: (m)
    private static final float R_OBJECT_FILL_DEPTH = 0.070f;

    // How far away is the object from the camera when it appears as one point (m)
    private static final float R_EFFECTIVE_INF = 0.125f;

    // Real distance from camera to center of projection
    private static final float R_CAMERA_TO_PROJECTION_CENTER = 0.0012f;

    // Conversion factor: C = real distance / camera distance
    //private static final float CAMERA_TO_REAL_CONVERSION = 0.004166f;
    private static final float CAMERA_TO_REAL_CONVERSION = 0.0011f;

    private static final float CAMERA_TO_REAL_X_CONVERSION = 0.0011f;
    private static final float CAMERA_TO_REAL_Y_CONVERSION = 0.00165f;

    // Camera tilt angle (from table) in degrees
    private static final float DEGREES_TILTED = 90;

    // Camera view angle
    private static final float CAMERA_VIEW_ANGLE_X = 95;
    private static final float CAMERA_VIEW_ANGLE_Y = 85;




    // Fields
    private Point3D transformedPoint = new Point3D();


    /**
     * Transforms two camera 2D points into a real world 3D point
     *
     * @param left
     * @param right
     * @return
     */
    public Point3D transform2Dto3D(final Point left, final Point right) {
        Point mid = Point.midpoint(left, right);
	// Real distance from camera to object
	float r_d = calculateDistance((float) left.distance(right));

	// Percentage of y relative to screen height
	float ratio_x = mid.x / (float) Frame.WIDTH;
	float ratio_y = mid.y / (float) Frame.HEIGHT;

	// Angle of y relative to x=0, z=0
	float theta_x = CAMERA_VIEW_ANGLE_X * ratio_x - (CAMERA_VIEW_ANGLE_X / 2);
	float theta_y = CAMERA_VIEW_ANGLE_Y * ratio_y - (CAMERA_VIEW_ANGLE_Y / 2);

	// Pixel distances
	float px = mid.x - Frame.WIDTH/2.0f;
	float py = mid.y - Frame.HEIGHT/2.0f;
	float pz = py / (float) Math.tan(Math.toRadians(theta_y));

	// Distance theta
	float pd = (float) Math.sqrt(px * px + py * py);
	float theta_d = (float) Math.atan(pz / pd);
	// Pixel distances

	// Real coordinates
	float r_z = r_d * (float) Math.sin(theta_d);
	float r_y = r_z * (float) Math.tan(Math.toRadians(theta_y));
	float r_x = r_z * (float) Math.tan(Math.toRadians(theta_x));

	transformedPoint.z = r_z;
	transformedPoint.x = r_x;
	transformedPoint.y = r_y;

	// Apply translate
	transformedPoint.y -= R_CAMERA_TO_PROJECTION_CENTER;

        return transformedPoint;
    }


	/**
	Calculate real distance from camera to eye
	*/
	private float calculateDistance(final float width) {
		float denum = 2 * (float) Math.tan(Math.toRadians((CAMERA_VIEW_ANGLE_X * width) / (Frame.WIDTH * 2)));

		return R_OBJECT_WIDTH / denum;
	}

/*
    private float calculateZ(final Point left, final Point right) {
        float r_distance = ((float) left.distance(right)) * CAMERA_TO_REAL_CONVERSION;

        float num = ((R_OBJECT_WIDTH * R_EFFECTIVE_INF) - (r_distance * R_EFFECTIVE_INF) + (r_distance * R_OBJECT_FILL_DEPTH));
        return num / R_OBJECT_WIDTH;
    }
*/

    /**
     * Change coordinate system from relative 
     * to camera to table coordinates.
     *
     * @param point 3D point relative to camera
     */
    private void tilt(Point3D point) {
        float distance = (float)Math.sqrt(Math.pow(point.y, 2) + Math.pow(point.z, 2));

        float temp_theta = DEGREES_TILTED + (float) Math.toDegrees(Math.asin(point.z / distance));

        point.y = distance * (float)Math.cos(Math.toRadians(temp_theta));
        point.z = distance * (float)Math.sin(Math.toRadians(temp_theta));
    }

    /**
     * Move the origin to the center of our projection
     */
    private void translateOrigin(Point3D point) {
        point.y = point.y - R_CAMERA_TO_PROJECTION_CENTER;
    }
}
