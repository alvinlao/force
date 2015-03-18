package force.pi.connector;

/**
 * Created by Jae on 2015-03-17.
 */
public class Main {
    public static void main(String[] args){
        Connector connector = new Connector();
        try {
            connector.RunConnector();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
