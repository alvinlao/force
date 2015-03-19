package force.pi.connector;

import com.sun.javaws.exceptions.InvalidArgumentException;
import force.pi.Measurement;

/**
 * Created by Jae on 2015-03-18.
 */
public class ConnectorC implements Runnable{
    private int channel_0_pos_x;
    private int channel_0_pos_y;
    private int channel_0_pos_a;
    private int channel_1_pos_x;
    private int channel_1_pos_y;
    private int channel_1_pos_a;

    native void connectorFromC();
    static{
        System.loadLibrary("connector_c");
    }

    @Override
    public void run() {
        connectorFromC();
    }

    public Measurement getMeasurement(int channel){
        if(channel == 0){
            return new Measurement(channel_0_pos_x,channel_0_pos_y,channel_0_pos_a);
        }else if (channel == 1){
            return new Measurement(channel_1_pos_x,channel_1_pos_y,channel_1_pos_a);
        }
        return null;
    }

    public int getChannel_0_pos_x() {
        return channel_0_pos_x;
    }

    public int getChannel_0_pos_y() {
        return channel_0_pos_y;
    }

    public int getChannel_0_pos_a() {
        return channel_0_pos_a;
    }

    public int getChannel_1_pos_x() {
        return channel_1_pos_x;
    }

    public int getChannel_1_pos_y() {
        return channel_1_pos_y;
    }

    public int getChannel_1_pos_a() {
        return channel_1_pos_a;
    }
}
