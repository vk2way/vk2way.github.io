---
title: Xiaomi Aqara Button Homeassistant Blueprint
layout: post
categories: [Smart Home]
tags:
- smarthome
- homeassistant
---

## Actions

I love these Xiami buttons and used them to replace all of the light switches in 
the house, each button is configured so that:

* Single tap - nearest light
* Double tap - next nearest light
* Long press - make any light on bright (or brighten both if both off)

The blueprint supports any lighting entities/areas or devices as the two target
devices; any button as the input, however it must contain the 'click_type' attribute
with a value of 'single', 'double' or 'long_click_press', in the event data, while it 
may work with other buttons it will always work best with Xiaomi Aqara buttons.

## Products required

* [Xiaomi Aqara ZigBee Buttons](https://amzn.to/3klBb1w) 🛒
* [Xiaomi Aqara ZigBee Gateway](https://amzn.to/3bVVKgs) 🛒

I strongly encourage folks to consider a full DIY ZigBee solution utilising a
USB ZigBee radio, along the lines of

* [ConBee Universal USB ZigBee Radio](https://amzn.to/3H4IioG) 🛒

# Import this Blueprint

Import this Blueprint to your Home Assistant instance using the URL:

* [{{site.url}}{{page.url}}xiaomi_lights.yaml]({{page.url}}xiaomi_lights.yaml)


![Homeassistant Screenshot - Create Automation]({{page.url}}screenshot.jpg)
