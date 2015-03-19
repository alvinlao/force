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

    public String channel1values(){
        return String.format("%3d %3d %3d",channel_1_pos_x, channel_1_pos_y,channel_1_pos_a);
    }
}
