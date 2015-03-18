package force.pi.connector;

import org.junit.Test;

import java.util.BitSet;

import static org.junit.Assert.*;

public class ConnectorTest {
    BitSet buffer = new BitSet(32);
    int lastIndex = 0;

    @Test
    public void testsometing() {
        readByte(0x11,true);
        readByte(0x11,true);
        readByte(0x11,true);
        readByte(0xFF,false);
        readByte(0xAB,true);
        readByte(0xCD,true);
        readByte(0x12,true);
        readByte(0x34,false);
        System.out.println("done");

    }

    private void readByte(int b, boolean k){
        boolean[] pin_data = toBoolArray(b);

        for (int i = 0; i < 8; i++) {
            buffer.set(lastIndex+i,pin_data[i]);
        }
        lastIndex += 8;

        if(!k){

            int posx = Connector.toInt(buffer.get(16,25));
            int posy = Connector.toInt(buffer.get(8,15));
            int acc = Connector.toInt(buffer.get(0,7));
            int channel = buffer.get(31)?1:0;

            buffer.clear();
            lastIndex = 0;

            //do something with these data
            System.out.println(String.format("%d %d %d %d",posx,posy,acc,channel));
        }
    }

    private boolean[] toBoolArray(int bi){
        boolean[] r = new boolean[8];
        for(int i = 0;i<8;i++){
            r[i] = ((bi & 1)==1);
            bi = bi >> 1;
        }
        return r;
    }
}
