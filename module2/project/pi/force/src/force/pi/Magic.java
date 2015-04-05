package force.pi;

import force.pi.camera.Camera;
import force.pi.connector.ConnectorC;
import force.pi.filters.kalman.KalmanFilter;
import force.pi.projection.Projection;

/**
 * Perform magic
 * The program's entry point
 *
 * High level overview:
 * stdin | filter | camera | projection
 *
 * stdin: Expecting two lines per frame. Each line is three ints formatted as "x y accuracy"
 * filter: Feed the two coordinates into the filter to reduce measurement noise
 * camera: Transform the two coordinates into a camera coordinate
 * projection: Given a camera coordinate, project 3D object onto a 2D plane
 *
 */
public class Magic {
    private static final int NUM_INPUT_COORDINATES_PER_FRAME = 2;
    private static boolean keepRunning = true;
	private static int RED = 0;
	private static int BLUE = 1;

    public static void main(String[] args) throws Exception {
        // Create filters
        Point[] points = new Point[NUM_INPUT_COORDINATES_PER_FRAME];
        Measurement[] measurements = new Measurement[NUM_INPUT_COORDINATES_PER_FRAME];
        KalmanFilter[] kalmanFilters = new KalmanFilter[NUM_INPUT_COORDINATES_PER_FRAME];

        for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
            measurements[i] = new Measurement();
            kalmanFilters[i] = new KalmanFilter();
        }

        // Create camera
        Point3D coordinate;
        Camera camera = new Camera();

        // Create Projection
        Projection projection = new Projection();

        // Create connector
        ConnectorC connector = new ConnectorC();
        Thread connectorThread = new Thread(connector);

        connectorThread.start();

        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                keepRunning = false;
            }
        });

        long startms, stopms, elapsedms;
        long targetms = 25;

        //keep alive (for time being)
        while (keepRunning) {
            startms = System.currentTimeMillis();

            for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
                measurements[i] = connector.getMeasurement(i);
                // HARD CODE ACCURACY
                measurements[i].accuracyRating = 25;
                points[i] = kalmanFilters[i].run(measurements[i]);
            }

            //System.out.println(String.format("<%d, %d> <%d, %d>", points[RED].x, points[RED].y, points[BLUE].x, points[BLUE].y));

            // Convert two points into a camera coordinate
            coordinate = camera.transform2Dto3D(points[RED], points[BLUE]);
            coordinate.x *= 1000;
            coordinate.y *= 1000;
            coordinate.z *= 1000;

            //System.out.println(coordinate.x + " " + coordinate.y + " " + coordinate.z);

            // Update projection with latest camera coordinate
            projection.update(coordinate);

            stopms = System.currentTimeMillis();
            elapsedms = stopms - startms;
            
            if(elapsedms < targetms) {
                Thread.sleep(targetms - elapsedms);
            }
        }
    }
}
