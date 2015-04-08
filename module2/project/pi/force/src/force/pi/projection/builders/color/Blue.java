package force.pi.projection.builders.color;

import java.awt.*;

public class Blue extends ColorScheme {
    public Blue() {
        topColor = new Color(76, 182, 243);
        rightColor = new Color(44, 162, 229);
        frontColor = rightColor;
        leftColor = new Color(55, 152, 207);
        backColor = leftColor;
    }
}
