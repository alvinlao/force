package force.pi.projection.builders;

import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by alvinlao on 15-04-08.
 */
public class LetterE extends ShapeSpec {
    @Override
    public Shape build() {

        List<Polygon> polygons = new ArrayList<Polygon>();
        return create(polygons);
    }
}
