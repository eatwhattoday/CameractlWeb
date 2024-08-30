
# 摄像头实时监控与控制系统

该项目是一个基于网页的摄像头实时监控与控制系统，支持摄像头实时视频流的播放、拍照、录像、录像停止以及通过箭头按钮来模拟摄像头的方向控制。
该项目使用了 `mjpg-streamer` 来实现实时视频流，并通过 `CGI` 脚本调用 `ffmpeg` 实现拍照和录像功能。

## 功能介绍

1. **实时视频流**：在网页上展示摄像头的实时视频流，使用 `mjpg-streamer` 进行流媒体播放。
2. **拍照**：通过点击按钮，调用后台的 CGI 脚本实现摄像头拍照，并在网页上返回照片保存路径。
3. **录像**：支持用户通过网页开始录像，并保存为 MP4 格式视频文件。
4. **停止录像**：允许用户随时停止录像，并在网页上显示保存的视频路径。
5. **模拟方向控制**：提供上下左右箭头按钮和中间圆圈按钮，便于控制摄像头的方向（可扩展为实际摄像头控制功能）。
6.看缩略图

## 项目结构

```
├── usr/lib/cgi-bin/
│   ├── take_photo.sh       # 拍照脚本
│   ├── start_video.sh      # 开始录像脚本
│   └── stop_video.sh       # 停止录像脚本
│   └── list_file.sh            # 文件列表脚本
│   └── generate_gallery.sh       #生成缩略图脚本
├── var/www/html/
│   └── index.html          # 主网页文件
│   └── gallery.html          # 主网页文件
├── var/www/html/videos/    # 存放录像的视频文件
└── var/www/html/thumbnails/    # 存放缩略图文件
```

### 文件说明

- **`index.html`**：这是项目的前端页面，通过 JavaScript 实现与服务器的交互，控制拍照、录像及方向控制功能。
- **`cgi-bin/take_photo.sh`**：后端 CGI 脚本，用于实现拍照功能。
- **`cgi-bin/start_video.sh`**：后端 CGI 脚本，用于启动摄像头录像，并保存为 MP4 文件。
- **`cgi-bin/stop_video.sh`**：后端 CGI 脚本，用于停止录像，并将保存的录像文件反馈给前端。

## 安装与配置

### 环境要求

1. **操作系统**：Linux 系统（如 Ubuntu）。
2. **Web 服务器**：推荐使用 `Apache`，并确保启用了 `CGI` 模块。
3. **摄像头支持**：确保系统已正确识别 USB 摄像头或其他支持的视频设备。
4. **依赖工具**：
   - `mjpg-streamer`：用于实时视频流播放。
   - `ffmpeg`：用于视频录制和拍照。

### 安装步骤

1. **安装依赖**：

   ```bash
   sudo apt update
   sudo apt install apache2 ffmpeg
   ```

2. **安装并配置 `mjpg-streamer`**：

   安装 `mjpg-streamer` 并确保它可以通过摄像头进行流媒体播放。以下是一个安装参考：

   ```bash
   sudo apt-get install mjpg-streamer
   mjpg_streamer -i "/usr/lib/input_uvc.so -d /dev/video0 -r 640x480" -o "/usr/lib/output_http.so -w /usr/share/mjpg-streamer/www"
   ```

   确保视频流可以通过 `http://localhost:8080/?action=stream` 访问。

3. **配置 Apache 支持 CGI**：

   修改 Apache 的 `cgi-bin` 设置，确保 `.sh` 脚本可以通过 `/cgi-bin/` 目录执行：

   ```bash
   sudo a2enmod cgi
   sudo systemctl restart apache2
   ```

4. **将项目文件放置到正确目录**：

   将 `cgi-bin` 目录中的脚本放置到服务器的 `/usr/lib/cgi-bin/` 或 `/var/www/cgi-bin/` 目录下。

5. **权限配置**：

   确保 `cgi-bin` 中的脚本具有可执行权限：

   ```bash
   sudo chmod +x /var/www/cgi-bin/*.sh
   ```

6. **启动项目**：

   启动 `mjpg-streamer`，并通过 `http://localhost/` 访问网页即可看到实时视频流和控制界面。

## 使用说明

### 拍照

1. 点击“拍照”按钮后，网页会显示“正在拍照”。
2. 拍照成功后，会显示保存照片的文件路径。

### 开始录像

1. 点击“开始录像”按钮，录像将开始，网页会显示录像文件的路径。
2. 录像默认持续一个小时（可在脚本中调整）。

### 停止录像

1. 点击“停止录像”按钮，当前录像会停止，网页上会显示保存的 MP4 文件路径。

### 方向控制

1. 点击页面中的方向按钮（上、下、左、右）或中间的圆圈按钮，可以实现对摄像头方向的模拟控制（可扩展为实际控制）。

## 常见问题

1. **实时视频流无法显示？**
   - 检查 `mjpg-streamer` 是否正常运行，并确认摄像头可以正确连接。使用网页前请现在后台运行 `mjpg-streamer`
   # 运行 mjpg-streamer 来推送视频流
mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 640x480 -f 30" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"


2. **录像文件无法保存或格式不对？**
   - 检查 `ffmpeg` 是否安装并可用，确保脚本中设置的路径存在且具有写权限。

3. **CGI 脚本无法执行？**
   - 确认 Apache 已启用 CGI 模块，并且脚本具有可执行权限。

## 扩展功能

- 添加云台控制，实现箭头按钮的实际摄像头方向控制。
- 添加更高级的视频处理功能，如定时拍照、录像分段存储等。
- 增加多摄像头支持，切换不同摄像头的视频流。

