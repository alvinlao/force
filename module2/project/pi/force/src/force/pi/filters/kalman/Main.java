package force.pi.filters.kalman;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Main {

    public static void main(String[] args) throws Exception {
        // Read stdin init
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;
        Measurement m = new Measurement();

        // Filter
        KalmanFilter kalmanFilter = new KalmanFilter();
        Point estimate;

//        final long startTime = System.currentTimeMillis();

        // Read from stdin
        while ((s = in.readLine()) != null && s.length() != 0) {
            ss = s.split(" ");

            // Read measurement
            try {
                x = Integer.parseInt(ss[0]);
                y = Integer.parseInt(ss[1]);
                accuracy = Integer.parseInt(ss[2]);
            } catch(ArrayIndexOutOfBoundsException e) {
                throw new Exception("Incorrect number of inputs. Format: 'x y accuracy'");
            }

            m.set(x, y, accuracy);
            estimate = kalmanFilter.run(m);

            // Output
            System.out.println(estimate.x + " " + estimate.y);
        }
//        final long endTime = System.currentTimeMillis();
//        System.out.println("Total time (ms): " + (endTime - startTime));
    }
}
