package force.pi.projection.builders.color;

import java.awt.*;

public class Purple extends ColorScheme {
    public Purple() {
        topColor = new Color(187, 98, 255);
        rightColor = new Color(161, 71, 230);
        frontColor = rightColor;
        leftColor = new Color(135, 60, 193);
        backColor = leftColor;
    }
}
