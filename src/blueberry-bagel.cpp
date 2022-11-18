#include <Arduino.h>
#include "Adafruit_CCS811.h"

Adafruit_CCS811 ccs;

void setup() {
    Serial.begin(9600);

    if(!ccs.begin()) {
        Serial.println("Failed to start sensor! Please check your wiring.");
        while(1);
    }
}

void loop() {
    if(ccs.available() && !ccs.readData()) {
        Serial.print(ccs.geteCO2());
        Serial.print(" ");
        Serial.println(ccs.getTVOC());
    }
}

