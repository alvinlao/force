// wiringPi Library needs to be installed
// COMPILE WITH -lwiringPi

#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <jni.h>
#include "force_pi_connector_ConnectorC.h"

const int pin_en = 8;
const int pin_ack = 9;
const int pin_keep = 10;
const int pin_data = 0;

unsigned char keepRunning = 1;
unsigned char processing = 0;
unsigned long buffer = 0;


//JNIEnv* jenv;
jobject jobj;
JavaVM* jvm;

void setJavaVariable_0_x(int val){
	JNIEnv *jenv;
	(*jvm)->AttachCurrentThread(jvm, (void **) &jenv, NULL);

	jclass jClass = (*jenv)->GetObjectClass(jenv, jobj);
	jfieldID fidToWrite = (*jenv)->GetFieldID(jenv, jClass, "channel_1_pos_x", "I");
	(*jenv)-> SetIntField(jenv, jobj, fidToWrite, (jint) val);
}

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
        //printf("%d %d %d %d \n",posx,posy,acc, channel);
		setJavaVariable_0_x(posx);
        buffer = 0;
}

void HandleData(){
	if (digitalRead(pin_en)){
		if (!processing){
			processing = 1;
			unsigned char value = 0;
			int i;
			for(i=pin_data;i<pin_data+8;i++){
				value = value << 1;
				value = value | digitalRead(i);
			}
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


void run(){
//	signal(SIGINT, &intHandler);
	if (wiringPiSetup()==-1){
		printf("C-failed to setup wiringPi");
		printf("C-exiting");
		return;
	}

	setupPins();

//	printf("C-waiting.. \n");

	if (wiringPiISR(pin_en, INT_EDGE_BOTH, &HandleData)==-1){
		printf("Unable to start interrupt for En\n");
		printf("exiting");
		return;
	}
	printf("C-Listening...\n\n\n");

	pause();
}


JNIEXPORT void JNICALL Java_force_pi_connector_ConnectorC_connectorFromC(JNIEnv *env, jobject obj) {
	//jenv = env;
	jobj = obj;
	(*env)->GetJavaVM(env, &jvm);


    run();
    return;
}
