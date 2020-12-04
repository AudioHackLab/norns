#!/bin/bash

./build/ws-wrapper/ws-wrapper ws://*:5555 ./build/matron/matron &
fbset -fb /dev/fb1 -xres 128 -yres 64 -depth 24
x11vnc -nocursor -viewonly -loop -forever -rawfb map:/dev/fb1@128x64x16 -scale 4 -no6 -rfbport 5901 &
websockify -D --web=/usr/share/novnc/ --cert=~/norns/novnc.pem 6080 localhost:5901
sleep 10s
open-stage-control --port 8080 --send 127.0.0.1:10111 --load ~/norns/osc-client/norns_openstagecontrol.json &
jack_connect "SuperCollider:out_1" "system:playback_1"
jack_connect "SuperCollider:out_2" "system:playback_2"
