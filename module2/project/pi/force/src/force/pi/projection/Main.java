package  force.pi.projection;

import force.pi.Point3D;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) throws Exception {
        Paint paint = new Paint();

        // Read stdin init
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;

        Point3D cam = new Point3D(100,100,10);

        Projection pro = new Projection();
        double [][]displayCOORDS = pro.projectIt(cam, paint);
        Thread.sleep(500);

        for(int i = 0; i < 8; i++){
            paint.draw((int)displayCOORDS[i][0], (int)displayCOORDS[i][1]);
        }

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
