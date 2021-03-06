// wiringPi Library needs to be installed
// COMPILE WITH -lwiringPi

#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

const int pin_en = 8;
const int pin_ack = 9;
const int pin_keep = 10;
const int pin_data = 0;

unsigned char keepRunning = 1;
unsigned char processing = 0;

unsigned long buffer = 0;

void setupPins(){
	pinMode(pin_en, INPUT);
	pullUpDnControl(pin_en,PUD_DOWN);

	pinMode(pin_keep, INPUT);
	pullUpDnControl(pin_en,PUD_DOWN);

	pinMode(pin_ack, OUTPUT);
	int i;
	for(i=pin_data; i < pin_data +8; i++){
        	pinMode(i,INPUT);
	}
}

void finalizeData(){
	//analyze buffer in promised format
	unsigned int posx;
	unsigned int posy;
	int acc;
	unsigned char channel;
	acc = buffer & 0x000000FF;
	posy = (buffer >> 8) & 0x000000FF;
	posx = (buffer >> 16) & 0x000001FF;
	channel = (buffer >> 31) & 0x00000001;
        printf("%d %d %d %d \n",posx,posy,acc, channel);
        buffer = 0;
}

void HandleData(){
	if (digitalRead(pin_en)){
		if (!processing){
			processing = 1;
			unsigned char value = 0;
			int i;
			for(i=pin_data;i<pin_data+8;i++){
//		printf("%d",digitalRead(i));
				value = value << 1;
				value = value | digitalRead(i);
			}
//		printf("\n");
//		printf("accpted byte : %x\n",value);

			buffer = buffer << 8;
			buffer = buffer | value;

			if(digitalRead(pin_keep)){
				//expecting more stream
			}else{
				finalizeData();
			}
		}
		digitalWrite(pin_ack,HIGH);
	}else{
		processing = 0;
		digitalWrite(pin_ack,LOW);
	}
}

void intHandler(){
	keepRunning = 0;
}


void main(){
	signal(SIGINT, &intHandler);
	if (wiringPiSetup()==-1){
		printf("failed to setup wiringPi");
		printf("exiting");
		return;
	}

	setupPins();

//	printf("waiting.. \n");

	if (wiringPiISR(pin_en, INT_EDGE_BOTH, &HandleData)==-1){
		printf("Unable to start interrupt for En\n");
		printf("exiting");
		return;
	}

	pause();

//	while(keepRunning==1){
//	}
}
