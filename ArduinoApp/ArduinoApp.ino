#include <Wire.h>
#include "DataTypes.h"
#include "BME280.h"

sint32 temperature;
uint32 pressure, humidity;
uint32 OldTime, SamplePeriod = 10;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  
  if(BME280_Init(BME280_OS_T_2, BME280_OS_P_2, BME280_OS_H_2,
                  BME280_FILTER_4, BME280_MODE_NORMAL, BME280_TSB_05))
    Serial.println("Sensor init error!");
}

void loop() {
  if((uint32)(OldTime - millis()) >=  SamplePeriod){
    OldTime += SamplePeriod;

    BME280_ReadAll(&temperature, &pressure, &humidity);
  
    Serial.print((float)temperature/100);    Serial.print(' ');
    Serial.print((float)pressure/256/100);   Serial.print(' ');
    Serial.print((float)humidity/1024);      Serial.print('\n');
  }
}

