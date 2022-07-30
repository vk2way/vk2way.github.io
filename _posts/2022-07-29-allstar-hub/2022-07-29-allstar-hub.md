---
title: Setting up an AllstarLink Hub
layout: post
categories: [VoIP, Radio]
tags:
- voip
- radio
---

# Introduction

One of the first Amateur Radio services I came to use was [AllStarLink](https://allstarlink.org); thanks to it's convenience and familiarity being based on the Open Source Asterisk PBX project - why reinvent an Internet call handling protocol when several exist - in this case AllStarLink (or ASL) is based on the Inter-Asterisk eXchange Protocol (IAX2).

In the course of setting up multiple digital to analogue radio bridges, AllStarLink became a central component in the radio infrastructure I manage for [FreeDMR Australia](https://vkfreedmr.com), had been in use at QTH for some time providing traditional phone services.

The intention of this guide is to step through the process I used for setting up my AllStarLink Hub in the cloud, running on Ubuntu Linux.

# Getting Started

First, get yourself a node number to use from the [AllStarLink](https://allstarlink.org) portal.  

You will initially be assigned a 5 digit node number, due to the limited pool of numbers, before we get started we will expand this to use NNX - the extended
node number system and increase it to 6 digits.  You can do this by clicking Continue in the portal and the option to expand your node to use NNX.

Add a second node in the sequence, assuming your assigned node was 57211; your new node numbers would be 572110 and 572111.

Make a note of your node password, you'll need this soon for your ASL configuration.

# Installing the Software

My recommended suggestion for the install is:

* Ubuntu 21.04 (it is possible on 22.04 with some backports)
* DVSwitch Debian Buster AllStarLink Packages

WARNING: ASL makes heavy use of DAHDI Telecoms kernel module, don't try to run it in docker!

Grab the buster installer script from [http://dvswitch.org/buster](http://dvswitch.org/buster);  I strongly suggest you view it before running it - blindly running scripts form the internet is bad practice!  You'll find it does sensible things like adding a key to the keyring and updating your apt repositories.

```
wget http://dvswitch.org/buster
bash bash
apt install allstar allstar-dahdi-linux-dkms allstar-dahdi-linux-tools allstar-asterisk-sounds allstar-asterisk-tools
```

Once the install is completed you're now ready to setup the allstar configuration.  For first-time setup run the `asl-menu` tool and follow the wizard using the details from your ASL Portal and the first node number you have assigned.  You'll want to select a radio-less node using the dahdi/pseudo channel.

Once you've completed the configuration there's some manual configuration changes I highly recommend to make the configuration more manageble.

You'll find the configuration in /etc/asterisk.  Most of the allstar magic happens in rpt.conf, the "repeater" application.     Open this file and take the first large block of configuration that will start with your node number in square brackets (e.g. [572110]) and move the entire block into a new file /etc/asterisk/custom/rpt\_572110.conf, changing the file name to reflect the node number.

In essence we're stripping out each of the nodes into their own configuration file;  removing them from rpt.conf and creating new files in the custom sub-directory.

Here's my recommended configuration (/etc/asterisk/custom/rpt\_572110.conf) for a bridge node that allows repeating of audio calls across multiple modes but does not carry connect/disconnect announcements and other noise that is unwelcome on DMR and other places.

```
[572110]                                ; Change this to your assigned node number 
rxchannel = dahdi/pseudo

duplex = 0
linktolink = yes                        ; disables forcing physical half-duplex operation of main repeater while
linkmongain = 0                         ; Link Monitor Gain adjusts the audio level of monitored nodes when a signal from another node or the local receiver is received.
erxgain = -3                            ; Echolink receive gain adjustment
etxgain = 3                             ; Echolink transmit gain adjustment
eannmode = 0

scheduler = schedule                    ; scheduler stanza
functions = functions                   ; Repeater Function stanza
phone_functions = functions             ; Phone Function stanza
link_functions = functions              ; Link Function stanza
telemetry=telemetry

morse = morse                           ; Morse stanza
wait_times = wait-times                 ; Wait times stanza

context = radio                         ; dialing context for phone
callerid = "Repeater" <572110>           ; callerid for phone calls
accountcode = RADIO                     ; account code (optional)

hangtime = 1000                         ; squelch tail hang time (in ms) (optional, default 5 seconds, 5000 ms)
althangtime = 4000                      ; longer squelch tail
totime = 180000                         ; transmit time-out time (in ms) (optional, default 3 minutes 180000 ms)

node_lookup_metod=dns

holdofftelem = 0
telemdefault = 0
telemdynamic = 0
phonelinkdefault = 0
phonelinkdynamic = 0
remotect =
unlinkedct =
nounkeyct = yes

notelemtx=yes
telemdefault=0
telemdynamic=0

parrotmode = 0                          ; 0 = Parrot Off (default = 0)

parrottime = 1000                       ; Set the amount of time in milliseconds 

statpost_program = /usr/bin/wget,-q,--timeout=15,--tries=1,--output-document=/dev/null
statpost_url = http://stats.allstarlink.org/uhandler.php
```

You'll notice my 'scheduler', 'functions', 'telemetry' all point to common configuration blocks, the default asl-menu will have named these differently, so we'll need to adjust those too in the master rpt.conf;  so open /etc/asterisk/rpt.conf and make the following changes:

Make a second copy of this file to reflect your next node number and update it accordingly.

Repeat the same process for the private node that would have been created by default, renaming it to a number below 2000 (reserved in ASL for private nodes).  I use 16xx and 17xx but it's up to you what you assign - I have had issues with interconnects when 1999 is kept though so I recommend picking a number for you.   We'll keep this node as later on we'll use it for playing scheduled transmissions by linking it to other nodes automatically.

Lastly make sure your node blocks are removed from rpt.conf and replaced with lines similiar to:

```
#includeifexists custom/nodes.conf

#includeifexists custom/rpt_572110.conf
#includeifexists custom/rpt_572111.conf

#includeifexists custom/rpt_1701.conf
#includeifexists custom/rpt_1702.conf
```

We still need to create the custom/nodes.conf file,  by default ASL will lookup nodes here, using a nodelist and with DNS.  To over-ride lookup for local nodes we define them in this section, so find the [nodes] block in /etc/asterisk/rpt.conf and move it to /etc/asterisk/custom/nodes.conf; which will be included in the includes above.

Create it now; mine contains:

```
[nodes]
1701 = radio@127.0.0.1:4569/1701,NONE
1702 = radio@127.0.0.1:4569/1702,NONE
572110 = radio@127.0.0.1:4569/572110,NONE
572111 = radio@127.0.0.1:4569/572111,NONE
```

While you're in rpt.conf;  find your scheduler, functions and other blocks, I recommend keeping common blocks for these; so rename them without node numbers and remove the duplicate blocks should any exist;

You should end up with blocks for 

* functions
* functions-remote
* telemetry
* morse
* wait-times
* memory
* macro
* controlstates\_public
* schedule

even if the blocks are empty (my schedule block is empty for instance in this file; but a schedule-XYZ is defined in custom/rpt\_XYZ.conf and referenced if required.

Lastly any public nodes must be registered to AllStar to be updated in the nodelist, DNS and be routable,  you cannot accept incomming connections or make outgoing connections with an unregistered node in the [general] section of /etc/asterisk/iax.conf:

```
register => 572110:YOURPASSWORD@register.allstarlink.org
register => 572111:YOURPASSWORD@register.allstarlink.org
```

* NOTE: Be sure to update your password.
* WARNING: Don't register private nodes.


Now we'll enable to nodelist updater service:

```
systemctl enable updatenodelist.service
systemctl start updatenodelist.service
```

and lastly restart the asterisk service:

```
systemctl restart asterisk
```

Asterisk has an excellent CLI that can assist in debugging; the first debugging task we'll check is our node registration.

Run the `asterisk -r` command to lauch the CLI:

```
root@rutherford:/etc/asterisk/custom# asterisk -r

AllStarLink Asterisk Version 1.01 2/13/2018 GIT Version 004b9dd
Copyright (C) 1999 - 2018 Digium, Inc. Jim Dixon, AllStarLink Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk GIT Version 004b9dd currently running on rutherford (pid = 2093125)
Verbosity is at least 3
Core debug is at least 3
rutherford*CLI> iax2 show registry
Host                  dnsmgr  Username    Perceived             Refresh  State
162.248.92.131:4569   Y       560029      45.32.240.26:4569         181  Registered
162.248.92.131:4569   Y       560028      45.32.240.26:4569         181  Registered
162.248.92.131:4569   Y       560027      45.32.240.26:4569         181  Registered
162.248.92.131:4569   Y       560026      45.32.240.26:4569         181  Registered
34.105.111.212:4569   Y       560025      45.32.240.26:4569         180  Registered
162.248.92.131:4569   Y       560024      45.32.240.26:4569         181  Registered
34.105.111.212:4569   Y       560023      45.32.240.26:4569         180  Registered
34.105.111.212:4569   Y       560022      45.32.240.26:4569         180  Registered
34.105.111.212:4569   Y       560021      45.32.240.26:4569         180  Registered
162.248.92.131:4569   Y       560020      45.32.240.26:4569         181  Registered
162.248.92.131:4569   Y       572111      45.32.240.26:4569         181  Registered
162.248.92.131:4569   Y       572110      45.32.240.26:4569         181  Registered
rutherford*CLI> 
```

You should now have a fully functional AllStarLink Hub Node capable of easily managing as many nodes as you need (as you can see from my list - for this host above).

In the next article in this series we'll get supermon up and running under PHP 8.0 with some updates to the code I made.

