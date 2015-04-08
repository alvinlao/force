package force.pi.projection.builders.color;

import java.awt.*;

/**
 * Created by alvinlao on 15-04-08.
 */
public class Green extends ColorScheme {
    public Green() {
        topColor = new Color(115, 220, 51);
        rightColor = new Color(115, 200, 53);
        frontColor = rightColor;
        leftColor = new Color(121, 178, 80);
        backColor = leftColor;
    }
}
