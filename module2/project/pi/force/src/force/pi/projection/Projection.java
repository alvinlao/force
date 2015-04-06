package force.pi.projection;

import force.pi.Point3D;

import java.awt.*;
import java.util.ArrayList;

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
    double [][] vals = { {-0.8f, 1, 0},
            {0.8f, 1, 0},
            {0.8f, -1, 0},
            {-0.8f, -1, 0},
            {-0.8f, 1, 1},
            {0.8f, 1, 1},
            {0.8f, -1, 1},
            {-0.8f, -1, 1}};

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

    private ArrayList<Point3D> flatten(Point3D[] points) {
        double [][] flattened = new double[points.length][3];
        ArrayList<Point3D> returnVal = new ArrayList<Point3D>();
        Point3D currentPoint;
        double [] l, v;
        for(int i = 0; i < points.length; i++) {
            double a;
            double [] point = new double[3];
            point[0] = points[i].x;
            point[1] = points[i].y;
            point[2] = points[i].z;
            l= sub(point, cam);
            if(dot(normal,l) != 0)
                a = -1.0 * ((float)dot(normal,point) / dot(normal, l));
            else
                a = -1.0 * (float)dot(normal,point);
            v = add(scale(l,a), point);
            flattened[i][0]= v[0];
            flattened[i][1]= v[1];
            flattened[i][2]= v[2];
            currentPoint = new Point3D((float)flattened[i][0], (float)flattened[i][0], (float)flattened[i][0]);
            returnVal.add(currentPoint);
        }
        return returnVal;
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

    private double[][] retXY(ArrayList<Point3D> points){
        double[][] retCOORD = new double[points.size()][2];
        for(int i = 0; i < points.size(); i++){
            retCOORD[i][0] = points.get(i).x;
            retCOORD[i][1] = points.get(i).y;
        }
        return retCOORD;
    }

    /**
     * Sets up internal camera coordinates and prints out
     * transformed points of the box to the draw pad
     * @param B is camera coordinates
     */
    public void projectIt(Point3D B) {
        /**
        cam[0] = B.x;
        cam[1] = B.y;
        cam[2] = B.z;
        double [][] displayCOORDS;
        double [][] displayCOORDSletterE;
        int xDraw, yDraw;
        displayCOORDS = retXY(flatten(vals));

        paint.clear();
//        xPoints = new int[4];
//        yPoints = new int[4];

        ArrayList<Polygon> letterEPolygons = new ArrayList<Polygon>();

        // Front face
        ArrayList<Point3D> letterEfront = new ArrayList<Point3D>();
        Point3D e1 = new Point3D(0,0,1);
        Point3D e2 = new Point3D(2,0,1);
        Point3D e3 = new Point3D(2,1,1);
        Point3D e4 = new Point3D(1,1,1);
        Point3D e5 = new Point3D(1,2,1);
        Point3D e6 = new Point3D(2,2,1);
        Point3D e7 = new Point3D(2,3,1);
        Point3D e8 = new Point3D(1,3,1);
        Point3D e9 = new Point3D(1,4,1);
        Point3D e10 = new Point3D(2,4,1);
        Point3D e11 = new Point3D(2,5,1);
        Point3D e12 = new Point3D(0,5,1);
        letterEfront.add(e1);
        letterEfront.add(e2);
        letterEfront.add(e3);
        letterEfront.add(e4);
        letterEfront.add(e5);
        letterEfront.add(e6);
        letterEfront.add(e7);
        letterEfront.add(e8);
        letterEfront.add(e9);
        letterEfront.add(e10);
        letterEfront.add(e11);
        letterEfront.add(e12);
        Polygon Efrontside = new Polygon(letterEfront, B, Color.black);
        letterEPolygons.add(Efrontside);

        // left side face
        ArrayList<Point3D> letterEleftSide = new ArrayList<Point3D>();
        Point3D eb1 = new Point3D(0,0,1);
        Point3D eb2 = new Point3D(0,5,1);
        Point3D eb3 = new Point3D(0,5,0);
        Point3D eb4 = new Point3D(0,0,0);
        letterEleftSide.add(eb1);
        letterEleftSide.add(eb2);
        letterEleftSide.add(eb3);
        letterEleftSide.add(eb4);
        Polygon Eleftside = new Polygon(letterEleftSide, B, Color.blue);
        letterEPolygons.add(Eleftside);

        //right bottom right vertical
        ArrayList<Point3D> letterErightSide1 = new ArrayList<Point3D>();
        Point3D ec1 = new Point3D(2,0,1);
        Point3D ec2 = new Point3D(2,1,1);
        Point3D ec3 = new Point3D(2,1,0);
        Point3D ec4 = new Point3D(2,0,0);
        letterEleftSide.add(ec1);
        letterEleftSide.add(ec2);
        letterEleftSide.add(ec3);
        letterEleftSide.add(ec4);
        Polygon Erightside1 = new Polygon(letterErightSide1, B, Color.blue);
        letterEPolygons.add(Erightside1);

        //right bottom top horizontal
        ArrayList<Point3D> letterErightSide2 = new ArrayList<Point3D>();
        Point3D ed1 = new Point3D(2,1,1);
        Point3D ed2 = new Point3D(1,1,1);
        Point3D ed3 = new Point3D(1,1,0);
        Point3D ed4 = new Point3D(2,1,0);
        letterEleftSide.add(ed1);
        letterEleftSide.add(ed2);
        letterEleftSide.add(ed3);
        letterEleftSide.add(ed4);
        Polygon Erightside2 = new Polygon(letterErightSide2, B, Color.blue);
        letterEPolygons.add(Erightside2);

        //right bottom inner vertical
        ArrayList<Point3D> letterErightSide3 = new ArrayList<Point3D>();
        Point3D ee1 = new Point3D(1,1,1);
        Point3D ee2 = new Point3D(1,1,0);
        Point3D ee3 = new Point3D(1,2,0);
        Point3D ee4 = new Point3D(1,2,1);
        letterEleftSide.add(ee1);
        letterEleftSide.add(ee2);
        letterEleftSide.add(ee3);
        letterEleftSide.add(ee4);
        Polygon Erightside3 = new Polygon(letterErightSide3, B, Color.blue);
        letterEPolygons.add(Erightside3);

        //right center vertical
        ArrayList<Point3D> letterErightSide4 = new ArrayList<Point3D>();
        Point3D ef1 = new Point3D(2,2,1);
        Point3D ef2 = new Point3D(2,2,0);
        Point3D ef3 = new Point3D(2,3,0);
        Point3D ef4 = new Point3D(2,3,1);
        letterEleftSide.add(ef1);
        letterEleftSide.add(ef2);
        letterEleftSide.add(ef3);
        letterEleftSide.add(ef4);
        Polygon Erightside4 = new Polygon(letterErightSide4, B, Color.blue);
        letterEPolygons.add(Erightside4);

        //right center horizontal
        ArrayList<Point3D> letterErightSide5 = new ArrayList<Point3D>();
        Point3D eg1 = new Point3D(2,1,1);
        Point3D eg2 = new Point3D(1,1,1);
        Point3D eg3 = new Point3D(1,1,0);
        Point3D eg4 = new Point3D(2,1,0);
        letterEleftSide.add(eg1);
        letterEleftSide.add(eg2);
        letterEleftSide.add(eg3);
        letterEleftSide.add(eg4);
        Polygon Erightside5 = new Polygon(letterErightSide5, B, Color.blue);
        letterEPolygons.add(Erightside5);

        //right top inner vertical
        ArrayList<Point3D> letterErightSide6 = new ArrayList<Point3D>();
        Point3D eh1 = new Point3D(1,3,1);
        Point3D eh2 = new Point3D(1,3,0);
        Point3D eh3 = new Point3D(1,4,0);
        Point3D eh4 = new Point3D(1,4,1);
        letterEleftSide.add(eh1);
        letterEleftSide.add(eh2);
        letterEleftSide.add(eh3);
        letterEleftSide.add(eh4);
        Polygon Erightside6 = new Polygon(letterErightSide6, B, Color.blue);
        letterEPolygons.add(Erightside6);

        //right side top outer vertical
        ArrayList<Point3D> letterErightSide7 = new ArrayList<Point3D>();
        Point3D ei1 = new Point3D(2,4,1);
        Point3D ei2 = new Point3D(2,5,1);
        Point3D ei3 = new Point3D(2,5,0);
        Point3D ei4 = new Point3D(2,4,0);
        letterEleftSide.add(ei1);
        letterEleftSide.add(ei2);
        letterEleftSide.add(ei3);
        letterEleftSide.add(ei4);
        Polygon Erightside7 = new Polygon(letterErightSide7, B, Color.blue);
        letterEPolygons.add(Erightside7);

        Shape letterE = new Shape(letterEPolygons, B);

        for(int i = 0; i < letterE.projectedPolygons.length; i++){
            xPoints = new int[letterE.projectedPolygons[i].polyPoints.length];
            yPoints = new int[letterE.projectedPolygons[i].polyPoints.length];
            for(int j = 0; j < letterE.projectedPolygons[i].polyPoints.length; j++){
                // do projection to 2D here
                // and do painting to screen here
                displayCOORDSletterE = retXY(flatten(letterE.projectedPolygons[i].polyPoints.clone()));
                for(int k = 0; k < letterE.projectedPolygons[i].polyPoints.length; k ++){
                    xPoints[k] = (int)letterE.projectedPolygons[i].polyPoints[j].x + SCREEN_WIDTH/2;
                    yPoints[k] = (int)letterE.projectedPolygons[i].polyPoints[j].y + SCREEN_HEIGHT/2;
                }
                paint.fillPolygon(xPoints, yPoints, letterE.projectedPolygons[i].polyPoints.length, letterE.projectedPolygons[i].color);
            }
        }

        for(int i = 0; i < numPoints; i++){
            xDraw = (-1 * (int)displayCOORDS[i][0])+SCREEN_WIDTH/2;
            yDraw = (int)displayCOORDS[i][1]+SCREEN_HEIGHT/2;
            if(yDraw < 0){
                displayCOORDS[i][1] = 0;
            }
            if(yDraw > (SCREEN_HEIGHT -1) ){
                displayCOORDS[i][1] = SCREEN_HEIGHT -1;
            }
            if(xDraw < 0){
                displayCOORDS[i][0] = 0;
            }
            if(yDraw > (SCREEN_WIDTH -1) ){
                displayCOORDS[i][0] = SCREEN_HEIGHT -1;
            }
        }

        if(B.x <= 0){
            //draw right face first

            //right face
            xPoints[0] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[2][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[6][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[2][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[6][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 2);

            //left face
            xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[7][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[3][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[7][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[3][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 3);

            //front face
            xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 4);

            //topface
            for(int i = 0; i < 4; i++){
                xPoints[i] = -1*(int)displayCOORDS[i+4][0]+SCREEN_WIDTH/2;
                yPoints[i] = (int)displayCOORDS[i+4][1]+SCREEN_HEIGHT/2;
            }
            paint.fillPolygon(xPoints, yPoints, 4, 2);
        }
        else {
            //draw left face first

            //left face
            xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[7][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[3][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[7][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[3][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 2);

            //right face
            xPoints[0] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[2][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[6][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[2][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[6][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 3);

            //front face
            xPoints[0] = -1*(int)displayCOORDS[0][0]+SCREEN_WIDTH/2;
            xPoints[1] = -1*(int)displayCOORDS[1][0]+SCREEN_WIDTH/2;
            xPoints[2] = -1*(int)displayCOORDS[5][0]+SCREEN_WIDTH/2;
            xPoints[3] = -1*(int)displayCOORDS[4][0]+SCREEN_WIDTH/2;
            yPoints[0] = (int)displayCOORDS[0][1]+SCREEN_HEIGHT/2;
            yPoints[1] = (int)displayCOORDS[1][1]+SCREEN_HEIGHT/2;
            yPoints[2] = (int)displayCOORDS[5][1]+SCREEN_HEIGHT/2;
            yPoints[3] = (int)displayCOORDS[4][1]+SCREEN_HEIGHT/2;
            paint.fillPolygon(xPoints, yPoints, 4, 4);

            //topface
            for(int i = 0; i < 4; i++){
                xPoints[i] = -1*(int)displayCOORDS[i+4][0]+SCREEN_WIDTH/2;
                yPoints[i] = (int)displayCOORDS[i+4][1]+SCREEN_HEIGHT/2;
            }
            paint.fillPolygon(xPoints, yPoints, 4, 2);
        }
        paint.update();
         **/
    }
}
