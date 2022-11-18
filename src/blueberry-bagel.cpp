#include <Arduino.h>
#include "Adafruit_CCS811.h"

Adafruit_CCS811 ccs;
size_t const ErrorLED = 2;

void setup() {
    Serial.begin(9600);

    pinMode(ErrorLED, OUTPUT);

    if(!ccs.begin()) {
        Serial.println("Failed to start sensor! Please check your wiring.");
        while(1);
    }
}

void loop() {
    static bool checkSensor = true;
    static size_t errorPosition = LOW;

    if(!checkSensor) {
        digitalWrite(ErrorLED, errorPosition);
        errorPosition = errorPosition ? LOW : HIGH;
    } else {
        if(ccs.available()) {
            if(!ccs.readData()) {
                Serial.print(ccs.geteCO2());
                Serial.print(" ");
                Serial.println(ccs.getTVOC());
            } else {
                Serial.println("Error reading data. Stopping.");
                checkSensor = false;
            }
        }
    }
}

