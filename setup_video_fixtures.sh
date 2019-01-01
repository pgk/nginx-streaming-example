#!/usr/bin/env bash

set -e

if [ ! -f nginx_rtmp/videos/big_buck_bunny_720p_stereo.avi ]; then
	wget -c -O nginx_rtmp/videos/big_buck_bunny_720p_stereo.avi \
		https://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_720p_stereo.avi
fi

if [ ! -f nginx_rtmp/videos/big_buck_bunny_720p_stereo.flv ]; then

	ffmpeg -i nginx_rtmp/videos/big_buck_bunny_720p_stereo.avi \
		-y -ab 56k -ar 44100 -b 200k -r 15 \
		-f flv nginx_rtmp/videos/big_buck_bunny_720p_stereo.flv
fi

./to_dash.sh nginx_rtmp/videos/big_buck_bunny_720p_stereo.avi bbb
