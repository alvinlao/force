package force.pi.filters.particle;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Argument required: Number of measurements per frame");
            return;
        }

        // Number of measurements
        int n = Integer.parseInt(args[0]);

        // Read stdin init
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, weight;

        // Setup measurements
        List<Measurement> measurements = new ArrayList<Measurement>();
        for (int i = 0; i < n; ++i) {
            measurements.add(new Measurement());
        }

        // Filter
        ParticleFilter particleFilter = new ParticleFilter();
        Point best;

        // Read from stdin
//        final long startTime = System.currentTimeMillis();
        while ((s = in.readLine()) != null && s.length() != 0) {
            // Read measurements
            for (Measurement m : measurements) {
                ss = s.split(" ");

                try {
                    x = Integer.parseInt(ss[0]);
                    y = Integer.parseInt(ss[1]);
                    weight = Integer.parseInt(ss[2]);
                } catch(ArrayIndexOutOfBoundsException e) {
                    throw new Exception("Incorrect number of inputs. Format: 'x y accuracy'");
                }

                // Set measurement
                m.x = x;
                m.y = y;
                m.weight = weight;
            }

            best = particleFilter.run(measurements);

            // Output
            System.out.println(best.x + " " + best.y);
        }
//        final long endTime = System.currentTimeMillis();
//        System.out.println("Total time (ms): " + (endTime - startTime));
    }
}
