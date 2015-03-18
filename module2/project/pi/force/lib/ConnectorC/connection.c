// wiringPi Library needs to be installed
// COMPILE WITH -lwiringPi

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <jni.h>
#include "force_pi_connector_ConnectorC.h"


JNIEXPORT void JNICALL Java_force_pi_connector_ConnectorC_connectorFromC(JNIEnv *env, jobject thisObj) {
   printf("Hello World! from c\n");
   return;
}
