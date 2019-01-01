# Nginx Streaming examples

Examples of [MPEG-DASH](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP) streaming using nginx.

* Prepared Mpeg-dash streaming, "vanilla" nginx, dash.js
* Live Mpeg-dash streaming, nginx + nginx-rtmp-module, dash.js, sources: webcam, video stream


## Setup

Note: `docker`, `ffmpeg` and `gpac` need to be installed

To start off, run `./setup_video_fixtures.sh`. This will download a test video,
transcode it to various resolutions and prepare it's mpeg-dash manifest.

Then you can kick things off by running `docker compose up --build`

## Examples

### Streaming a prepared MPEG-DASH video:

You can stream the video from `http://localhost:3110/video/bbb`

### Streaming a live video

Run `./stream_bbb.sh`

Visit `http://localhost:3110/video/live`

### Streaming from webcam (macos)

You need a mac and a webcam for this. Run `./stream_webcam_mac.sh`. Allow webcam access.

Visit `http://localhost:3110/video/webcam`

## Links

- https://nginx.org/en/docs/
- https://github.com/arut/nginx-rtmp-module
- https://github.com/Dash-Industry-Forum/dash.js
- https://gpac.wp.imt.fr/
- https://ffmpeg.org/
