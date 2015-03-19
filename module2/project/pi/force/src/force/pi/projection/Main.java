package  force.pi.projection;

import force.pi.Point3D;

import java.io.BufferedReader;
import java.io.InputStreamReader;




public class Main {

    public static void main(String[] args) throws Exception {

        // Read stdin init
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        String[] ss;
        int x, y, accuracy;

        Point3D cam = new Point3D(-100, 100, 100);

        Projection pro = new Projection();
        pro.projectIt(cam);
        while(true) {
            for (int i = 0; i < 20; ++i) {
                cam.x += 10;
                pro.projectIt(cam);
                Thread.sleep(33);
            }

            for (int i = 0; i < 20; ++i) {
                cam.y -= 10;
                pro.projectIt(cam);
                Thread.sleep(33);
            }

            for (int i = 0; i < 20; ++i) {
                cam.z += 10;
                pro.projectIt(cam);
                Thread.sleep(33);
            }

            for (int i = 0; i < 10; ++i) {
                cam.x -= 10;
                cam.y += 10;
                pro.projectIt(cam);
                Thread.sleep(33);
            }

            for (int i = 0; i < 10; ++i) {
                cam.x -= 10;
                cam.y += 10;
                cam.z -= 20;
                pro.projectIt(cam);
                Thread.sleep(33);
            }
            System.out.println(cam.x + " " + cam.y + " " + cam.z);
        }
/*
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
            //paint.draw(x, y);

        }*/
    }
}
