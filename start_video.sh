#!/bin/bash

# -preset ultrafast 选项确保录像进程不会占用过多 CPU 资源
STREAM_URL="http://localhost:8080/?action=stream"
VIDEO_PATH="/var/www/html/videos/video_$(date +%s).mp4"
PID_FILE="/tmp/ffmpeg_recording.pid"

# 启动 ffmpeg 从 mjpg-streamer URL 中录制视频
#nohup ffmpeg -y -i "$STREAM_URL" -c:v libx264 -preset ultrafast -t 3600 "$VIDEO_PATH" > /dev/null 2>&1 &//can't read from browser
nohup ffmpeg -y -i "$STREAM_URL" -c:v libx264 -preset ultrafast -t 3600 -pix_fmt yuv420p -movflags +faststart "$VIDEO_PATH" > /dev/null 2>&1 &
echo $! > "$PID_FILE"

# 返回录像文件路径
echo "Content-type: application/json"
echo ""
echo "{\"status\":\"success\", \"filepath\":\"$VIDEO_PATH\"}"

