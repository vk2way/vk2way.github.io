---
title: PrettyFly (Emoji Heavy) ADS-B Report Generator
layout: post
categories: [Radio, ADS-B]
tags:
- software
- pi
- sdr
---

Warning: This is a work in progress

PrettyFly is a first attempt at turning ADS-B data into interesting reports; it depends on 
[Tar1090](https://github.com/wiedehopf/tar1090) from wiedehopf.  PrettyFly is currently only
able to travel back in time the duration of tar1090's flight path archive.

```
usage: prettyfly [options]

optional arguments:
  -h, --help            show this help message and exit
  --hours HOURS
  --data-dir [DATA_DIR]
  --tar-rundir [TAR_RUNDIR]
  --tar-db [TAR_DB]
  --lon LON
  --lat LAT
```

PrettyFly requires the tar1090 database and runtime directories for processing the data archive.

Project source code: [PrettyFly](https://github.com/jaredquinn/prettyfly)

