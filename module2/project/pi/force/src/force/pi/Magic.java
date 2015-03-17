package force.pi;

import force.pi.filters.kalman.Measurement;

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
 * perspective: Given a camera coordinate, project 3D object onto a 2D plane
 *
 */
public class Magic {
    public static void main(String[] args) {
        // Read stdin
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;

        Measurement m = new Measurement();

    }
}
