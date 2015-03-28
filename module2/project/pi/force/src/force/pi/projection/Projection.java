package force.pi.projection;

import force.pi.Point3D;

import java.lang.reflect.Array;

/**
 * Created by Shaan on 17/03/2015.
 * need to pass in camera coordinates
 * call public method "projectIt(Point3D B)"
 * where B is camera coordinates
 */
public class Projection {
    static final int SCREEN_WIDTH = 960;
    static final int SCREEN_HEIGHT = 720;
    static final int numPoints = 8;
    public double camX, camY, camZ;
    public double [] cam = new double[3];

    Paint paint = new Paint();

    // Points for box to draw out
    int scale = 25;
    double [][] vals = { {-1, 1, 1},
            {1, 1, 1},
            {1, -1, 1},
            {-1, -1, 1},
            {-1, 1, 2},
            {1, 1, 2},
            {1, -1, 2},
            {-1, -1, 2}};

    double [] normal = {0,0,1};

    int[] xPoints;
    int[] yPoints;

    /**
     * Default constructor
     */
    public Projection() {
        camX = 75;
        camY = 75;
        camZ = 75;
        cam[0] = camX;
        cam[1] = camY;
        cam[2] = camZ;

        for (int i = 0; i < vals.length; ++i) {
            for (int j = 0; j < vals[i].length; ++j) {
                vals[i][j] *= scale;
            }
        }
        try {
            Thread.sleep(500);
        } catch (Exception e){

        }
    }

    /**
     * Constructor
     * @param a is x coordinate of camera position
     * @param b is y coordinate of camera position
     * @param c is z coordinate of camera position
     */
    public Projection(double a, double b, double c) {
        camX = a;
        camY = b;
        camZ = c;
        for (int i = 0; i < vals.length; ++i) {
            for (int j = 0; j < vals[i].length; ++j) {
                vals[i][j] *= scale;
            }
        }
        try {
            Thread.sleep(500);
        } catch (Exception e) {

        }
    }

    /**
     * Method to dot two 1x3 arrays
     * @param x is first array
     * @param y is second array
     * @return x dot y
     */
    private double dot(double [] x, double [] y){
        double dotVal;
        dotVal = (x[0] * y[0]) + (x[1] * y[1]) + (x[2] * y[2]);
        return dotVal;
    }

    /**
     * Method to add two 1x3 arrays to each other
     * @param x is first array
     * @param y is second array
     * @return x+y
     */
    private double [] add(double [] x, double [] y){
        double [] addVal = new double[3];
        addVal[0] = (x[0] + y[0]);
        addVal[1] = (x[1] + y[1]);
        addVal[2] = (x[2] + y[2]);
        return addVal;
    }

    /**
     * Method to subtract two 1x3 arrays from one another
     * @param x is first array
     * @param y is second array
     * @return x-y
     */
    private double [] sub(double [] x, double [] y){
        double [] subVal = new double[3];
        subVal[0] = (x[0] - y[0]);
        subVal[1] = (x[1] - y[1]);
        subVal[2] = (x[2] - y[2]);
        return subVal;
    }

    /**
     * Method to scale a 1x3 array
     * @param a is the array
     * @param s is the scaling factor
     * @return a*s
     */
    private double [] scale(double [] a, double s){
        double [] scaleVal = new double[3];
        scaleVal[0] = s*a[0];
        scaleVal[1] = s*a[1];
        scaleVal[2] = s*a[2];
        return scaleVal;
    }

    /**
     * Takes in matrix of points (set to 8 points right now)
     * returns flattened points ready for display...
    */
    private double[][] flatten(double [][] A ) {
        double [][] flattened = new double[numPoints][3];
        double [] l, v;
        for(int i = 0; i < numPoints; i++) {
            double a;
            double [] point = new double[3];
            point[0] = A[i][0];
            point[1] = A[i][1];
            point[2] = A[i][2];
            l= sub(point, cam);
            if(dot(normal,l) != 0)
                a = -1.0 * ((float)dot(normal,point) / dot(normal, l));
            else
                a = -1.0 * (float)dot(normal,point);
            v = add(scale(l,a), point);
            flattened[i][0]= v[0];
            flattened[i][1]= v[1];
            flattened[i][2]= v[2];
        }
        return flattened;
    }

    /**
     * Takes in 8 by X array and should work fine as long as X >= 2
     */
    private double[][] retXY(double [][] A){
        double[][] retCOORD = new double[numPoints][2];
        for(int i = 0; i < numPoints; i++){
            retCOORD[i][0] = A[i][0];
            retCOORD[i][1] = A[i][1];
        }
        return retCOORD;
    }

    /**
     * Sets up internal camera coordinates and prints out
     * transformed points of the box to the draw pad
     * @param B is camera coordinates
     */
    public void projectIt(Point3D B) {
        camX = B.x;
        camY = B.y;
        camZ = B.z;
        cam[0] = camX;
        cam[1] = camY;
        cam[2] = camZ;
        double [][] displayCOORDS;
        int xDraw, yDraw;
        displayCOORDS = retXY(flatten(vals));
        paint.clear();
        xPoints = new int[4];
        yPoints = new int[4];

        for(int i = 0; i < numPoints; i++){
            xDraw = (-1 * (int)displayCOORDS[i][0])+SCREEN_WIDTH/2;
            yDraw = (int)displayCOORDS[i][1]+SCREEN_HEIGHT/2;
            paint.draw(xDraw, yDraw);
        }
        for(int i = 0; i < 4; i++){
            xPoints[i] = -1*(int)displayCOORDS[i][0]+SCREEN_WIDTH/2;
            yPoints[i] = (int)displayCOORDS[i][1]+SCREEN_HEIGHT/2;
        }
        paint.drawPolygon(xPoints, yPoints, 4);
        for(int i = 0; i < 4; i++){
            xPoints[i] = -1*(int)displayCOORDS[i+4][0]+SCREEN_WIDTH/2;
            yPoints[i] = (int)displayCOORDS[i+4][1]+SCREEN_HEIGHT/2;
        }
        paint.drawPolygon(xPoints, yPoints, 4);
    //    paint.fillPolygon(xPoints, yPoints, 4, 1);

        xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
        xPoints[1] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
        xPoints[2] = -1*(int)displayCOORDS[7][0]+SCREEN_WIDTH/2;
        xPoints[3] = -1*(int)displayCOORDS[3][0]+SCREEN_WIDTH/2;
        yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
        yPoints[1] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
        yPoints[2] = (int)displayCOORDS[7][1]+SCREEN_HEIGHT/2;
        yPoints[3] = (int)displayCOORDS[3][1]+SCREEN_HEIGHT/2;
        paint.drawPolygon(xPoints, yPoints, 4);
    //    paint.fillPolygon(xPoints, yPoints, 4, 2);

        xPoints[0] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
        xPoints[1] = -1*(int)displayCOORDS[2][0]+SCREEN_WIDTH/2;
        xPoints[2] = -1*(int)displayCOORDS[6][0]+SCREEN_WIDTH/2;
        xPoints[3] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
        yPoints[0] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
        yPoints[1] = (int)displayCOORDS[2][1]+SCREEN_HEIGHT/2;
        yPoints[2] = (int)displayCOORDS[6][1]+SCREEN_HEIGHT/2;
        yPoints[3] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
        paint.drawPolygon(xPoints, yPoints, 4);
     //   paint.fillPolygon(xPoints, yPoints, 4, 3);

        xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
        xPoints[1] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
        xPoints[2] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
        xPoints[3] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
        yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
        yPoints[1] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
        yPoints[2] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
        yPoints[3] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
        paint.drawPolygon(xPoints, yPoints, 4);
    //    paint.fillPolygon(xPoints, yPoints, 4, 1);

        xPoints[0] = -1*(int)displayCOORDS[3][0]+SCREEN_WIDTH/2;
        xPoints[1] = -1*(int)displayCOORDS[2][0]+SCREEN_WIDTH/2;
        xPoints[2] = -1*(int)displayCOORDS[6][0]+SCREEN_WIDTH/2;
        xPoints[3] = -1*(int)displayCOORDS[7][0]+SCREEN_WIDTH/2;
        yPoints[0] = (int)displayCOORDS[3][1]+SCREEN_HEIGHT/2;
        yPoints[1] = (int)displayCOORDS[2][1]+SCREEN_HEIGHT/2;
        yPoints[2] = (int)displayCOORDS[6][1]+SCREEN_HEIGHT/2;
        yPoints[3] = (int)displayCOORDS[7][1]+SCREEN_HEIGHT/2;
        paint.drawPolygon(xPoints, yPoints, 4);
     //   paint.fillPolygon(xPoints, yPoints, 4, 2);

    }
}
