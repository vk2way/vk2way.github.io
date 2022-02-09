---
title: APRS WX Weather Station
layout: post
categories: [Smart Home]
tags:
- weatherstation
---

While usually I try to consolidate projects to deploy fewer devices, the decision on this 
project was to build it so that it would be useful for anyone wanting to build their own 
weather station. 

Originally this project was just to add some additional sensors to the balcony camera and
radio system; but since it's original inception it has become an entirely standalone project.

# Project Goals

The initial incarnation of this project had the goal of replacing a Holman "iWeather" station
that had been running in my apartment for over 10 years with it's 433Mhz external sensor.

![Old Holman iWeather]({{page.url}}/holman.jpg)

Since getting my radio license and playing with APRS this scope of this project expanded
to become a fully fledged, climate-monitoring weather station collecting as much data as possible,
while working with a friend to install a more plug-and-play version of this at his has seen the 
project cover a range of hardware and microcontrollers.  

What I'm trying to present here though is options.


# The Software

Usually I would dive straight into a project's hardware, what to buy and how to build it.  The
core of this project however is the software so that is what this article will be focussed on; 
the hardware however is covered in two other articles depending upon how you're approaching your
build.

# Controller

There are several options for the controller; and building those will be separated into separate
articles while this article focuses on the common parts between the two.

## The Tinkerer Approach

Thanks to a range of existing infrastructure within my network for smart home and other monitoring
I opted for utilising the MQTT Bridge that was already in place for Home Assistant, as this allows
all devices in the house to publish and/or subscribe to any "topic".   My weather station is 
currently an aggregation of 3 devices, one off the shelf sensor and two ESP microcontrollers running
the Arduino-based code that is published as part of this article.

## The Off-the-Shelf Approach

Thanks to a range of existing infrastructure within my network for smart home and other monitoring
I opted for utilising the MQTT Bridge that was already in place for Home Assistant, as this allows
all devices in the house to publish and/or subscribe to any "topic".   My weather station is 
currently an aggregation of 3 devices, one off the shelf sensor and two ESP microcontrollers running
the Arduino-based code that is published as part of this article.




