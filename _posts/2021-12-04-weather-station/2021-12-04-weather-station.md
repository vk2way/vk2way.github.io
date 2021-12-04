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

I did not want to use WiFi for this originally due to generating more RF near my antennas, 
so a project goal of both UART and WiFi connectivity was decided and an ESP low power microcontroller
which can be mounted inside the mast or in a small enclosure nearby was selected.  I also always have a 
pile of ESP32 or ESP8266 SoC microcontrollers on hand, while the Wemos D1 Mini (right) form factor is my preferred 
form factor for production projects, the standard DevKit (left) with header pins is easier for prototyping and
testing.


![ESP32 Wemos D1 and DevKit Formfactors]({{page.url}}/esp.png)

# Parts List

* [ESP32 DevKit](https://amzn.to/3IbSxbo) 🛒 ($12) [ESP D32 Mini](https://amzn.to/3DqHQOy) 🛒 ($12)
* Sensors
  * Temperature
  * Humidity
  * Barometric Pressure
* Weather Station Sensors (MS-WH-SP-WS02)
  * Wind Speed ($20)
  * Wind Direction (MS-WH-SP-WD)
  * Rainfall

This project is ongoing, but now taking form with some final plans, so unlike everything to date
on this blog it will consist of ongoing updates in parts until project completion.

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


