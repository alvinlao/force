package force.pi.filters.particle;

import java.util.Random;

/**
 * Weighted random number generator
 */
public class WeightedRandom {
    private Random rg = new Random();

    private float[] weights;
    private float totalWeight;

    public void setWeights(float[] weights) {
        this.weights = weights;
        this.totalWeight = 0;

        // Compute total weight
        for (float weight : weights) {
            totalWeight += weight;
        }
    }

    /**
     * Generate a weighted random number
     * Returns a number between 0 and the number of weights set by {#setWeights}
     *
     * @return [0, len(weights)]
     */
    public int next() {
        int randomIndex = -1;
        double random = rg.nextDouble() * totalWeight;
        for (int i = 0; i < weights.length; ++i)
        {
            random -= weights[i];
            if (random <= 0.0d)
            {
                randomIndex = i;
                break;
            }
        }

        return randomIndex;
    }
}
