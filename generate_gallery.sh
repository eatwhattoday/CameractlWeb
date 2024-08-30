#!/bin/bash
echo "Content-type: application/json"
echo ""

# 指定媒体文件夹和缩略图文件夹
MEDIA_DIR="/var/www/html/videos"   # 放置图片和视频的文件夹路径
THUMBNAIL_DIR="/var/www/html/thumbnails"  # 放置缩略图的文件夹路径
PER_PAGE=12  # 每页显示的缩略图数量

# 获取当前页码
PAGE=$(echo $QUERY_STRING | sed -n 's/^.*page=\([^&]*\).*$/\1/p')
if [ -z "$PAGE" ]; then
    PAGE=1
fi

# 获取所有文件列表
files=($(ls $MEDIA_DIR/*.{jpg,mp4} 2>/dev/null))

# 计算分页参数
TOTAL_FILES=${#files[@]}
TOTAL_PAGES=$(( (TOTAL_FILES + PER_PAGE - 1) / PER_PAGE ))
START_INDEX=$(( (PAGE - 1) * PER_PAGE ))

# 构建 JSON 响应
echo "{"
echo "  \"totalPages\": $TOTAL_PAGES,"
echo "  \"files\": ["

# 遍历当前页的文件
for ((i=START_INDEX; i<START_INDEX+PER_PAGE && i<TOTAL_FILES; i++)); do
    file="${files[$i]}"
    filename=$(basename "$file")
    
    if [[ $file == *.jpg ]]; then
        # 图片文件直接使用原图作为缩略图
        thumbnail="$file"
    elif [[ $file == *.mp4 ]]; then
        # 视频文件生成缩略图
        thumbnail="$THUMBNAIL_DIR/${filename%.*}.jpg"
        if [ ! -f "$thumbnail" ]; then
            # 生成缩略图
            ffmpeg -i "$file" -ss 00:00:01.000 -vframes 1 "$thumbnail"
        fi
    fi
    
    # 输出文件信息到JSON
    echo "    {"
    echo "      \"name\": \"$filename\","
    echo "      \"url\": \"/videos/$filename\","  # 确保URL路径是正确的
    echo "      \"thumbnail\": \"/thumbnails/${filename%.*}.jpg\""
    echo "    }"
    
    if [ $i -lt $((START_INDEX+PER_PAGE-1)) ] && [ $i -lt $((TOTAL_FILES-1)) ]; then
        echo ","
    fi
done

echo "  ]"
echo "}"

