package force.pi.connector;

/**
 * Created by Jae on 2015-03-18.
 */
public class ConnectorC {
    native void connectorFromC();
    static{
        System.loadLibrary("connector_c");
    }
}
