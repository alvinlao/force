package force.pi;

import force.pi.filters.kalman.KalmanFilter;
import force.pi.filters.kalman.Measurement;
import force.pi.filters.kalman.Point;

import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * Perform magic
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

    public static void main(String[] args) throws Exception {
        // Input variables
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;

        // Create filters
        Point[] points = new Point[NUM_INPUT_COORDINATES_PER_FRAME];
        Measurement[] measurements = new Measurement[NUM_INPUT_COORDINATES_PER_FRAME];
        KalmanFilter[] kalmanFilters = new KalmanFilter[NUM_INPUT_COORDINATES_PER_FRAME];

        for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
            measurements[i] = new Measurement();
            kalmanFilters[i] = new KalmanFilter();
        }

        // Create camera

        // Create projection

        // Read stdin
        while (true) {
            // Read # coordinates per frame
            for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
                s = in.readLine();

                // Terminate
                if (s == null || s.length() == 0) break;

                ss = s.split(" ");

                // Convert input into measurement
                try {
                    x = Integer.parseInt(ss[0]);
                    y = Integer.parseInt(ss[1]);
                    accuracy = Integer.parseInt(ss[2]);
                } catch (ArrayIndexOutOfBoundsException e) {
                    throw new Exception("Incorrect number of inputs. Expected format: 'x y accuracy'");
                }

                // Note: Testing hardcoded accuracy
                measurements[i].set(x, y, 300);
                points[i] = kalmanFilters[i].run(measurements[i]);
            }

            // Execute per frame logic
            for (int i = 0; i < NUM_INPUT_COORDINATES_PER_FRAME; ++i) {
                System.out.println(points[i].x + " " + points[i].y);
            }
        }
    }
}
