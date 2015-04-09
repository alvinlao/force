package force.pi.projection.builders;

import force.pi.Point3D;
import force.pi.projection.*;
import force.pi.projection.Polygon;

import java.awt.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by Jae on 2015-04-08.
 */
public class Grid extends ShapeSpec {
    private final Color gridColor = new Color(60, 60, 60);
    private static final float linewidth = 0.002f;

    private List<Polygon> polygons;

    public Grid(int intensity, float width, float height, Orientation orientation){
        float gridwidth = width/intensity;
        float gridheight = height/intensity;
        this.polygons = new ArrayList<Polygon>();

        //draw columns
        for(float col = 0; col < width; col += gridwidth){
            List<Point3D> points = new ArrayList<Point3D>();
            if (orientation == Orientation.XY){
                points.add(new Point3D(col,0,0));
                points.add(new Point3D(col,height,0));
                points.add(new Point3D(col+linewidth,height,0));
                points.add(new Point3D(col+linewidth,0,0));
            }else if (orientation==Orientation.XZ){
                points.add(new Point3D(col,0,0));
                points.add(new Point3D(col,0,height));
                points.add(new Point3D(col+linewidth,0,height));
                points.add(new Point3D(col+linewidth,0,0));
            }else{ // YZ
                points.add(new Point3D(0,0,col));
                points.add(new Point3D(0,height,col));
                points.add(new Point3D(0,height,col+linewidth));
                points.add(new Point3D(0,0,col+linewidth));
            }
            polygons.add(new Polygon(points,gridColor));
        }
        //draw rows
        for(float row = 0; row < height; row += gridheight){
            List<Point3D> points = new ArrayList<Point3D>();
            if (orientation == Orientation.XY){
                points.add(new Point3D(0,row,0));
                points.add(new Point3D(width,row,0));
                points.add(new Point3D(width,row+linewidth,0));
                points.add(new Point3D(0,row+linewidth,0));
            }else if (orientation==Orientation.XZ){
                points.add(new Point3D(0,0,row));
                points.add(new Point3D(width,0,row));
                points.add(new Point3D(width,0,row+linewidth));
                points.add(new Point3D(0,0,row+linewidth));
            }else{ // YZ
                points.add(new Point3D(0,row,0));
                points.add(new Point3D(0,row,width));
                points.add(new Point3D(0,row+linewidth,width));
                points.add(new Point3D(0,row+linewidth,0));
            }
            polygons.add(new Polygon(points,gridColor));
        }
    }

    @Override
    public force.pi.projection.Shape build() {
        return create(polygons);
    }
}
