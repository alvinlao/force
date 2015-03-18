package force.pi.connector;

/**
 * Created by Jae on 2015-03-17.
 */
public class Main {
    public static void main(String[] args) throws Exception{
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() { /*
       my shutdown code here
    */ }
        });
        Connector connector = new Connector();
        connector.RunConnector();
    }
}
