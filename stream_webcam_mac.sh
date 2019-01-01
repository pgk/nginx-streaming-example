#!/usr/bin/env bash

set -e

ffmpeg -loglevel verbose -f avfoundation \
	-framerate 30 -i "0" -s 160x130 -c:v libx264 -an \
	-f flv rtmp://localhost:1935/dash/webcam
