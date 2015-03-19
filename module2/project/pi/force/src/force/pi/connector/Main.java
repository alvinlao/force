package force.pi.connector;

/**
 * Created by Jae on 2015-03-17.
 */
public class Main {
    private static boolean keepRunning = true;

    public static void main(String[] args) throws Exception{

        ConnectorC connectorC = new ConnectorC();
        Thread connectorThread = new Thread(connectorC);
        connectorThread.start();


/*
        Connector connector = new Connector();
        connector.AttachConnector();
*/
        //attach ctrl-c capture


        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                keepRunning = false;
            }
        });



        //keep alive (for time being)
        while (keepRunning) {
            System.out.println(String.format("%3d %3d %3d",connectorC.getChannel_0_pos_x(),connectorC.getChannel_0_pos_y(),connectorC.getChannel_0_pos_a()));
        }
    }
}
