package force.pi.projection;

import Jama.*;
import force.pi.Point3D;

/**
 * Created by Shaan on 17/03/2015.
 * need to pass in camera coordinates
 * call public method "projectIt(Point3D B)"
 * where B is camera coordinates
 */
public class projection {

    public float camX, camY, camZ;
    double [] cam = {camX, camY, camZ};
    Matrix camCOORD = new Matrix(cam , 1);

    double [][] vals = { {-0.5, -0.5, 0},
                        {0.5, -0.5, 0},
                        {0.5, 0.5, 0},
                        {-0.5, 0.5, 0},
                        {-0.5, -0.5, 1},
                        {0.5, -0.5, 1},
                        {0.5, 0.5, 1},
                        {-0.5, 0.5, 1}};

    //all points in object
    Matrix Box = new Matrix(vals);

    //Makes vector of zeros
    Matrix normal = new Matrix(1,3);

    //set normal; takes paramaters: row index, column index, value
    normal.set(1,3,1);

    //takes in two 1x3 matrices
    private double dot(Matrix x, Matrix y){
        double dotVec;
        dotVec = (x.get(1,1) * y.get(1,1)) + (x.get(1,2) * y.get(1,2)) + (x.get(1,3) * y.get(1,3));

        return dotVec;
    }

    /*
    takes in matrix of points (set to 8 points right now)
    returns flattened points ready for display... i hope
    */
    private Matrix flatten(Matrix A) {
        Matrix flattened, l, v;
        flattened = new Matrix(8,3);
        for(int i = 1; i < 9; i++) {
            double a;
            l= A.getMatrix(i, i, 1, 3).minus(camCOORD);
            a = -1.0 * (dot(normal,A.getMatrix(i, i, 1,3)) / dot(normal, l));
            v = A.getMatrix(i, i, 1, 3).plus(l.times(a));
            flattened.set(i,1,v.get(i,1));
            flattened.set(i,2,v.get(i,2));
            flattened.set(i,3,v.get(i,3));
        }
        return flattened;
    }

    //takes in 8byX array and should work fine as long as X >= 2
    private Matrix retXY(Matrix A){
        Matrix retCOORD = new Matrix(8,2);
        for(int i = 1; i < 9; i++){
            retCOORD.set(i,1,A.get(i,1));
            retCOORD.set(i,2,A.get(i,2));
        }
        return retCOORD;
    }

    // A is box matrix. B is camera coordinates
    // returns matrix of flattened box coordinates
    public Matrix projectIt(Point3D B) {
        camX = B.x;
        camY = B.y;
        camZ = B.z;
        Matrix displayCOORDS = retXY(flatten(Box));
        return displayCOORDS;
    }

}
