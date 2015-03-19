package force.pi.connector;

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
