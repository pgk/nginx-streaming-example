#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No video file supplied"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No output prefix supplied"
    exit 1
fi

if [ ! -f "$1" ]; then
	echo "$1 is not a file."
	exit 1
fi


echo "preparing videos"

source_video="$1"
output_video_prefix="$2"

filename=$(basename -- "$source_video")
extension="${filename##*.}"
filename="${filename%.*}"

echo "$filename, $extension, $output_video_prefix"

function transcode_video() {
	input="$1"
	size="$2"
	bitrate="$3"
	prefix="$4"

	output_path="nginx_rtmp/videos/mp4s/${prefix}_${size}_${bitrate}.mp4"
	if [ -f "$output_path" ]; then
		echo "transcoding to $output_path already done. Skipping"
		return
	fi
	ffmpeg -i "$input" \
		-s "$size" -c:v libx264 -b:v "$bitrate" \
		-g 90 -an \
		"$output_path"
}

transcode_video "$source_video" "160x90"  "250k" "$output_video_prefix"
transcode_video "$source_video" "320x180" "500k" "$output_video_prefix"

if [ ! -f "nginx_rtmp/videos/mp4s/${output_video_prefix}_audio_128k.mp4" ]; then

	ffmpeg -i "$source_video" -c:a aac -b:a 128k -vn \
		"nginx_rtmp/videos/mp4s/${output_video_prefix}_audio_128k.mp4"
fi

transcode_video "$source_video" "640x360"  "750k" "$output_video_prefix"
transcode_video "$source_video" "640x360"  "1000k" "$output_video_prefix"
transcode_video "$source_video" "1280x720" "1500k" "$output_video_prefix"

workdir="$(pwd)"

mkdir -p "$workdir/nginx_rtmp/videos/dash/${output_video_prefix}"

cd "$workdir/nginx_rtmp/videos/dash/${output_video_prefix}" \
	&& mp4box -dash 5000 -rap \
		-profile dashavc264:onDemand \
		-mpd-title "${output_video_prefix}" \
		-out "$workdir/nginx_rtmp/videos/dash/${output_video_prefix}/manifest.mpd" \
		-frag 2000 \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_audio_128k.mp4" \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_160x90_250k.mp4" \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_320x180_500k.mp4" \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_640x360_750k.mp4" \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_640x360_1000k.mp4" \
		"$workdir/nginx_rtmp/videos/mp4s/${output_video_prefix}_1280x720_1500k.mp4"

cd "$workdir"
