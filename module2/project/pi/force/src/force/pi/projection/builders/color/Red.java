package force.pi.projection.builders.color;

import java.awt.*;

/**
 * Created by alvinlao on 15-04-08.
 */
public class Red extends ColorScheme {
    public Red() {
        topColor = new Color(244, 111, 52);
        leftColor = new Color(198, 70, 13);
        backColor = leftColor;
        rightColor = new Color(231, 87, 23);
        frontColor = rightColor;
    }
}
