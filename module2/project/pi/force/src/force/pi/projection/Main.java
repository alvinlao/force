package  force.pi.projection;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Main {

    public static void main(String[] args) throws Exception {
        // Read stdin init
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;
        Paint paint = new Paint();

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

            // Output
            paint.draw(x, y);
        }
    }
}
