#!/usr/bin/env bash

set -e

if [ ! -f nginx_rtmp/videos/big_buck_bunny_720p_stereo.flv ]; then

	ffmpeg -i nginx_rtmp/videos/big_buck_bunny_720p_stereo.avi \
		-y -ab 56k -ar 44100 -b 200k -r 15 \
		-f flv nginx_rtmp/videos/big_buck_bunny_720p_stereo.flv
fi

ffmpeg -loglevel verbose -re -i nginx_rtmp/videos/big_buck_bunny_720p_stereo.flv \
	-vcodec libx264 \
	-vprofile baseline -acodec libmp3lame -ar 44100 -ac 1 \
	-f flv rtmp://localhost:1935/dash/movie
