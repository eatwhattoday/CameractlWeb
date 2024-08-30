#!/bin/bash

PHOTO_PATH="/var/www/html/videos/photo_$(date +%s).jpg"
THUMBNAILS_PATH="/var/www/html/thumbnails/photo_$(date +%s).jpg"
# 使用 MJPG-streamer 的 HTTP 流拍照
ffmpeg -y -i http://localhost:8080/?action=stream -vframes 1 $PHOTO_PATH
ffmpeg -y -i http://localhost:8080/?action=stream -vframes 1 $THUMBNAILS_PATH

# 返回拍照文件路径
echo "Content-type: application/json"
echo ""
echo "{\"status\":\"success\", \"filepath\":\"$PHOTO_PATH\"}"

