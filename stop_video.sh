#!/bin/bash

# PID 文件保存 FFMPEG 进程 ID
PID_FILE="/tmp/ffmpeg_recording.pid"

# 检查是否存在正在进行的录像进程
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    
    # 使用 SIGINT 信号优雅地停止 FFMPEG
    kill -SIGINT "$PID" 2>/dev/null  # 重定向错误输出以防止额外输出
    wait "$PID" 2>/dev/null          # 确保等待进程结束并且没有多余输出
    
    # 删除 PID 文件
    rm "$PID_FILE"
    
    # 返回成功状态，录像已停止
    echo "Content-type: application/json"
    echo ""
    echo "{\"status\":\"success\", \"message\":\"录像已停止\", \"filepath\":\"/path/to/saved/video.mp4\"}"
else
    # 如果没有找到正在进行的录像进程
    echo "Content-type: application/json"
    echo ""
    echo "{\"status\":\"error\", \"message\":\"没有找到正在进行的录像\"}"
fi

