package force.pi;

import force.pi.camera.Camera;
import force.pi.connector.ConnectorC;
import force.pi.filters.kalman.KalmanFilter;
import force.pi.projection.Paint;

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
        Paint paint = new Paint();

        // Create connector
        ConnectorC connector = new ConnectorC();
        Thread connectorThread = new Thread(connector);

        connectorThread.start();

        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                keepRunning = false;
            }
        });

        //keep alive (for time being)
        while (keepRunning) {
            Thread.sleep(10);

            for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
                measurements[i] = connector.getMeasurement(i);
                // HARD CODE ACCURACY
                measurements[i].accuracyRating = 300;
                points[i] = kalmanFilters[i].run(measurements[i]);
            }

            paint.draw(points[0].x, points[0].y);

//            coordinate = camera.transform2Dto3D(points[0], points[1]);
        }
    }
}
