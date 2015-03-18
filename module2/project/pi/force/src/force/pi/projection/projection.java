package force.pi.projection;

import force.pi.Point3D;

import java.lang.reflect.Array;

/**
 * Created by Shaan on 17/03/2015.
 * need to pass in camera coordinates
 * call public method "projectIt(Point3D B)"
 * where B is camera coordinates
 */
public class projection {

    public double camX, camY, camZ;

    public projection(){
        camX = 20;
        camY = 20;
        camZ = 10;
    }

    public projection(double a, double b, double c){
        camX = a;
        camY = b;
        camZ = c;
    }

    double [] cam = {camX, camY, camZ};
    //  Matrix camCOORD = new Matrix(cam , 1);

    double [][] vals = { {15, 15, 0},
            {45, 15, 0},
            {45, 15, 0},
            {15, 45, 0},
            {15, 15, 15},
            {45, 15, 15},
            {45, 45, 15},
            {15, 45, 15}};

    //all points in object
    //   Matrix Box = new Matrix(vals);

    //Makes 1x3 vector of zeros
    //  Matrix normal = new Matrix(1,3);
    double [] normal = {0,0,1};

    //set normal; 'set' takes parameters: row index, column index, value
    //normal.set(1, 3, 1.0);

    //takes in two 1x3 matrices
    private double dot(double[] x, double [] y){
        double dotVal;
        dotVal = (x[0] * y[0]) + (x[1] * y[1]) + (x[2] * y[2]);
        return dotVal;
    }

    private double [] add(double[] x, double [] y){
        double [] dotVal = new double[3];
        dotVal[0] = (x[0] + y[0]);
        dotVal[1] = (x[1] + y[1]);
        dotVal[2] = (x[2] + y[2]);
        return dotVal;
    }

    private double [] sub(double[] x, double [] y){
        double [] subVal = new double[3];
        subVal[0] = (x[0] - y[0]);
        subVal[1] = (x[1] - y[1]);
        subVal[2] = (x[2] - y[2]);
        return subVal;
    }

    private double [] scale(double [] a, double s){
        double [] scaleVal = new double[3];
        scaleVal[0] = s*a[0];
        scaleVal[1] = s*a[1];
        scaleVal[2] = s*a[2];
        return scaleVal;
    }

    /*
    takes in matrix of points (set to 8 points right now)
    returns flattened points ready for display...
    */
    private double[][] flatten(double [][] A ) {
        double [][] flattened = new double[8][3];
        double [] l, v;
        for(int i = 1; i < 8; i++) {
            double a;
            double [] point = new double[3];
            point[0] = A[i][0];
            point[1] = A[i][1];
            point[2] = A[i][2];
            l= sub(point, cam);
            a = -1.0 * ((float)dot(normal,point) / dot(normal, l));
            v = add(scale(l,a), point);
            flattened[i][0]= v[0];
            flattened[i][1]= v[1];
            flattened[i][2]= v[2];
        }
        return flattened;
    }

    //takes in 8byX array and should work fine as long as X >= 2
    private double[][] retXY(double [][] A){
        double[][] retCOORD = new double[8][2];
        for(int i = 1; i < 8; i++){
            retCOORD[i][0] = A[i][0];
            retCOORD[i][1] = A[i][1];
        }
        return retCOORD;
    }

    // A is box matrix. B is camera coordinates
    // returns matrix of flattened box coordinates
    public void projectIt(Point3D B, Paint paint) {
        camX = B.x;
        camY = B.y;
        camZ = B.z;
        double [][] displayCOORDS;
        displayCOORDS = retXY(flatten(vals));

        for(int i = 1; i < 8; i++){
            paint.draw((int)displayCOORDS[i][0],(int)displayCOORDS[i][1]);
        }
    }
}