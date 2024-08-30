#!/bin/bash
# 获取文件列表，返回 JSON 格式

VIDEO_PATH="/var/www/html/videos"

# 获取视频目录中的所有文件
FILES=$(ls $VIDEO_PATH)

# 输出 JSON
echo "Content-type: application/json"
echo ""
echo "{\"files\":["

for file in $FILES
do
    echo "\"$file\","
done

echo "null]}"

