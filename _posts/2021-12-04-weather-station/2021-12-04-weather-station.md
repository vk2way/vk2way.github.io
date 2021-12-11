---
title: Weather Station
layout: post
categories: [Smart Home]
tags:
- weatherstation
---

While usually I try to consolidate projects to deploy fewer devices, the decision on this 
project was to build it so that it would be useful for anyone wanting to build a weather station
but also tightly integrate into my [Balcony Radio System](/posts/balcony-multi-cam).

# Project Goals

The first and foremost goal of this project is to replace a Holman iWeather that has been operating
on my balcony for about 10 years with something more modern.  This uses an external 433Mhz sensor 
providing temperature and humidity along with the same from indoors plus pressure, used to calculate
a chance of rain and display that, along with sun and moon information with the standard clock and
alarm.

![Old Holman iWeather]({{page.url}}/holman.jpg)

The replacement should provide better functionalty than the existing system, be able to integrate 
with the smart house and most importantly provide at-a-glace display in the kitchen in a form factor
similar to the Holman for the "cohabitation approval factor".



# Parts List

Parts marked with ⚙️  came from existing items in my parts store and were chosen for that reason.  

* ⚙️  [ESP32 DevKit](https://amzn.to/3IbSxbo) 🛒 ($12) [ESP D32 Mini](https://amzn.to/3DqHQOy) 🛒 ($12)
* Sensors
  * ⚙️  [Waterproof DS18B20](https://amzn.to/31q5n50) 🛒 ($10) External Temperature 
  * ⚙️  [BMP280](https://amzn.to/3rFoSSl) 🛒 ($13) Temperature, Humidity and Barometric Pressure 
* Misol Weather Station Parts 
  * ⚙️  [MS-WH-SP-WS](https://amzn.to/3xQzTkC) 🛒 ($40) Wind Speed
  * Wind Direction (MS-WH-SP-WD)
  * Rainfall

As usual Amazon affiliate links are provided, but all of this can easily be found on AliExpress too.

# ESP32

I also always have a 
pile of ESP32 or ESP8266 SoC microcontrollers on hand, while the Wemos D1 Mini (right) form factor is my preferred 
form factor for production projects, the standard DevKit (left) with header pins is easier for prototyping and
testing.

![ESP32 Wemos D1 and DevKit Formfactors]({{page.url}}/esp.png)

The ESP also enables this project to be used both as data source sending ASCII data over UART to the host 
computer for processing, as I intend to use it, the final code produced will additionally support the ESP WiFi 
networking stack and MQTT client to publish data to any network.

# Windspeed Testing

Now that the radio has been working and cabled for a while, it's time to take a look at the next device that's been sitting here begging for me to take a look at for way too long; it's the anonometer.  I picked it up some time ago and didn't recall any datasheet for it, but managed to identify it as a MS-WH-SP-WD for the Misol Weather Meter, with lots of info and examples available online for it as "spare parts" are available for it from AliExpress.

It simply closes a switch each rotation with each rotation representing a 2.4km/h windspeed, small and plastic:

![Windspeed Meter]({{page.url}}/anom.png)

Connecting the sensor to a ESP is relatively trivial;  trim off the supplied RJ11 connector and connect using GPIO12 (supply) and GPIO13 (interrupt) on the ESP32. We use a GPIO for the supply side so that later on we can programatically turn on/off the sensor, but for now we'll just leave it turned on but utilising the final pin.

For testing purposes we'll just make sure our cabling works and we can trigger an interrupt function every time it trips it's switch, here's some Arduino IDE code for the test:
```

#include "Arduino.h"

const byte ledPin = 2;
const byte interruptPin = 13;
const byte powerPin = 12;

volatile byte state = LOW;

void setup() {
  delay(500);
  Serial.begin(115200);
  
  pinMode(ledPin, OUTPUT);
  pinMode(interruptPin, INPUT_PULLDOWN);
  pinMode(powerPin, OUTPUT);
  digitalWrite(powerPin, HIGH);
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, CHANGE);
}

void loop() {
  digitalWrite(ledPin, state);
}

void blink() {
  if(state) { Serial.print("PING\n"); }
  state = !state;
}
```
{: file="test.ino" }

This isn't yet doing any timing or math to calculate windspeed; it's simply a test to ensure everything can work the way we want it to before we move on to the other sensors.


