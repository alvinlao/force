package force.pi.connector;

/**
 * Created by Jae on 2015-03-17.
 */
public class Main {
    private static boolean keepRunning = true;

    public static void main(String[] args) throws Exception{

        Connector connector = new Connector();
        connector.AttachConnector();

        //attach ctrl-c capture

        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                keepRunning = false;
            }
        });


        //keep alive (for time being)
        while (keepRunning) {
            Thread.sleep(500);
        }
    }
}
