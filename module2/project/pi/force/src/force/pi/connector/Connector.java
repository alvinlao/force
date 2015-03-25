/**
 * Created by Jae on 2015-03-17.
 */

package force.pi.connector;

import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPinDigitalInput;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.PinPullResistance;
import com.pi4j.io.gpio.PinState;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.gpio.event.GpioPinDigitalStateChangeEvent;
import com.pi4j.io.gpio.event.GpioPinListenerDigital;

public class Connector {
    private static final String EN = "EN";
    private static final String ACK = "ACK";
    private static final String KEEP = "KEEP";
    private static final String DATA = "DATA";

    private static final int X_MASK = 0x000001FF;
    private static final int Y_MASK = 0x000000FF;
    private static final int ACC_MASK = 0x000000FF;
    private static final int CHANNEL_MASK = 0x00000001;

    private GpioController gpio;
    private GpioPinDigitalInput pin_en;
    private GpioPinDigitalOutput pin_ack;
    private GpioPinDigitalInput pin_keep;
    private GpioPinDigitalInput[] pin_data;

    private boolean isprocessing;
    private int buffer;

    public Connector(){
        isprocessing = false;
        buffer = 0;

        //initialize GPIO
        System.out.println("Initializing GPIO");

        gpio = GpioFactory.getInstance();
        pin_en = gpio.provisionDigitalInputPin(RaspiPin.GPIO_08, EN, PinPullResistance.PULL_DOWN);
        pin_ack = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_09, ACK, PinState.LOW);
        pin_keep = gpio.provisionDigitalInputPin(RaspiPin.GPIO_10, KEEP, PinPullResistance.PULL_DOWN);

        pin_data = new GpioPinDigitalInput[8];
        pin_data[0] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_00, DATA, PinPullResistance.PULL_DOWN);
        pin_data[1] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_01, DATA, PinPullResistance.PULL_DOWN);
        pin_data[2] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_02, DATA, PinPullResistance.PULL_DOWN);
        pin_data[3] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_03, DATA, PinPullResistance.PULL_DOWN);
        pin_data[4] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_04, DATA, PinPullResistance.PULL_DOWN);
        pin_data[5] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_05, DATA, PinPullResistance.PULL_DOWN);
        pin_data[6] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_06, DATA, PinPullResistance.PULL_DOWN);
        pin_data[7] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_07, DATA, PinPullResistance.PULL_DOWN);

    }

    /**
     * Starts a listener for the current Connector object.
     * @throws java.lang.InterruptedException
     */
    public void AttachConnector() throws java.lang.InterruptedException {
        //start listener
        pin_en.addListener(new GpioPinListenerDigital() {
            @Override
            public void handleGpioPinDigitalStateChangeEvent(GpioPinDigitalStateChangeEvent event) {
                // display pin state on console

                if (pin_en.isHigh()) {
                    if (!isprocessing) {
                        isprocessing = true;

                        //build byte
                        int value = 0;
                        for (int i = 0; i < 8; i++) {
                            value = value << 1;
                            value = value | (pin_data[i].isHigh() ? 1 : 0);
                        }

                        //build buffer
                        buffer = buffer << 8;
                        buffer = buffer | value;

                        if (pin_keep.isLow()) {
                            //finalize buffer
                            int posx = (buffer >> 16) & X_MASK;
                            int posy = (buffer >> 8) & Y_MASK;
                            int acc = buffer & ACC_MASK;
                            int channel = (buffer >> 31) & CHANNEL_MASK;

                            //do something with these data
                            System.out.println(String.format("%8x %d %d %d %d", buffer, posx, posy, acc, channel));
                            buffer = 0;
                        }
                    }
                    pin_ack.high();
                } else {
                    isprocessing = false;
                    pin_ack.low();
                }
            }
        });

        System.out.println("Listening..\n\n");
    }
}
