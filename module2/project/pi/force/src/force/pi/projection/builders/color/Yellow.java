package force.pi.projection.builders.color;

import java.awt.*;

/**
 * Created by alvinlao on 15-04-08.
 */
public class Yellow extends ColorScheme {
    public Yellow() {
        topColor = new Color(248, 210, 2);
        leftColor = new Color(179, 161, 60);
        rightColor = new Color(225, 196, 36);
        frontColor = rightColor;
        backColor = leftColor;
    }
}
