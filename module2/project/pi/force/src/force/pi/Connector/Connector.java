package force.pi.Connector;

import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPin;
import com.pi4j.io.gpio.GpioPinDigitalInput;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.PinDirection;
import com.pi4j.io.gpio.PinMode;
import com.pi4j.io.gpio.PinPullResistance;
import com.pi4j.io.gpio.PinState;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.gpio.trigger.GpioCallbackTrigger;
import com.pi4j.io.gpio.trigger.GpioPulseStateTrigger;
import com.pi4j.io.gpio.trigger.GpioSetStateTrigger;
import com.pi4j.io.gpio.trigger.GpioSyncStateTrigger;
import com.pi4j.io.gpio.event.GpioPinListener;
import com.pi4j.io.gpio.event.GpioPinDigitalStateChangeEvent;
import com.pi4j.io.gpio.event.GpioPinEvent;
import com.pi4j.io.gpio.event.GpioPinListenerDigital;
import com.pi4j.io.gpio.event.PinEventType;

import java.util.BitSet;


/**
 * Created by Jae on 2015-03-17.
 */
public class Connector {
    private GpioController gpio;
    private GpioPinDigitalInput pin_en;
    private GpioPinDigitalOutput pin_ack;
    private GpioPinDigitalInput pin_keep;
    private GpioPinDigitalInput[] pin_data;

    private boolean isprocessing;
    private BitSet buffer;
    private int lastIndex;


    public Connector() throws java.lang.InterruptedException {
        isprocessing = false;
        buffer = new BitSet(32);
        lastIndex = 0;

        gpio = GpioFactory.getInstance();
        pin_en = gpio.provisionDigitalInputPin(RaspiPin.GPIO_27, "EN", PinPullResistance.PULL_DOWN);
        pin_ack = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_26, "ACK", PinState.LOW);
        pin_keep = gpio.provisionDigitalInputPin(RaspiPin.GPIO_25, "KEEP", PinPullResistance.PULL_DOWN);

        pin_data = new GpioPinDigitalInput[8];
        pin_data[0] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_16, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[1] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_17, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[2] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_18, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[3] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_19, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[4] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_20, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[5] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_21, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[6] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_22, "DATA", PinPullResistance.PULL_DOWN);
        pin_data[7] = gpio.provisionDigitalInputPin(RaspiPin.GPIO_23, "DATA", PinPullResistance.PULL_DOWN);

        pin_en.addListener(new GpioPinListenerDigital() {
            @Override
            public void handleGpioPinDigitalStateChangeEvent(GpioPinDigitalStateChangeEvent event) {
                // display pin state on console

                if (pin_en.isHigh()) {
                    if (!isprocessing) {
                        isprocessing = true;

                        //build byte
                        for (int i = 0; i < 8; i++) {
                            buffer.set(lastIndex+i,pin_data[i].isHigh());
                        }
                        lastIndex += 8;

                        if(pin_keep.isLow()){

                            int posx = toInt(buffer.get(16,25));
                            int posy = toInt(buffer.get(8,15));
                            int acc = toInt(buffer.get(0,7));
                            int channel = buffer.get(31)?1:0;

                            buffer.clear();
                            lastIndex = 0;

                            //do something with these data
                            System.out.println(String.format("{0} {1} {2} {3}",posx,posy,acc,channel));
                        }
                    }
                    pin_ack.high();
                } else {
                    isprocessing = false;
                    pin_ack.low();
                }
            }

        });

        //keep alive (for time being)
        for (;;) {
            Thread.sleep(500);
        }
    }


    public static int toInt(BitSet bits) {
        int value = 0;
        for (int i = 0; i < bits.length(); ++i) {
            value += bits.get(i) ? (1L << i) : 0L;
        }
        return value;
    }
}
