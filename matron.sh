#!/bin/bash

./build/ws-wrapper/ws-wrapper ws://*:5555 ./build/matron/matron &
x11vnc -rawfb map:/dev/fb1@128x64x16 -scale 4 &
sleep 10s
jack_connect "SuperCollider:out_1" "system:playback_1"
jack_connect "SuperCollider:out_2" "system:playback_2"
