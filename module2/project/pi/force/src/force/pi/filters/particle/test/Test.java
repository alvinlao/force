package force.pi.filters.particle.test;

import force.particlefilter.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Test {
    public static void main(String[] args) {
//        testParticle();
//        testMeasurement();
        testParticleFilter();
//        testWeightedRandom();
    }

    public static void testParticle() {
        System.out.println("Testing particle walk");

        Random r = new Random();
        Particle p = new Particle();

        for(int i = 0; i < 20; ++i) {
            p.walk(2 * r.nextDouble() - 1, 2 * r.nextDouble() - 1, r.nextDouble() + 0.5, new float[]{5.0f, 5.0f});
            System.out.println(p.x + " " + p.y);
        }
    }

    public static void testMeasurement() {
        System.out.println("Testing measurement");

        Measurement m = new Measurement(100, 100, 200);
        Particle p1 = new Particle(0, 0, 10);
        Particle p2 = new Particle(90, 90, 10);

        System.out.println("Weight 1: " + m.weightOf(p1));
        System.out.println("Weight 2: " + m.weightOf(p2));
    }

    public static void testParticleFilter() {
        System.out.println("Testing particle filter");

        ParticleFilter pf = new ParticleFilter();
        List<Measurement> measurements = new ArrayList<Measurement>();
        measurements.add(new Measurement(100, 100, 0));

        Point p;
        for (int i = 0; i < 30; ++i) {
            p = pf.run(measurements);
            System.out.println(p.x + " " + p.y);
        }
    }

    public static void testWeightedRandom() {
        System.out.println("Testing weighted random");

        WeightedRandom wr = new WeightedRandom();
        wr.setWeights(new float[] {0.3f, 0.1f, 0.6f});

        int[] res = new int[3];
        for (int i = 0; i < 1000; i++) {
            res[wr.next()]++;
        }

        System.out.println("0: " + res[0]);
        System.out.println("1: " + res[1]);
        System.out.println("2: " + res[2]);
    }
}
