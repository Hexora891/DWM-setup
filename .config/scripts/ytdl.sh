#!/bin/bash

# ==============================
# Minimal Rofi yt-dlp Downloader
# ==============================

VIDEO_DIR="$HOME/Videos"
MUSIC_DIR="$HOME/Music"

URL=$(printf "" | rofi \
-dmenu \
-p "YouTube URL" \
-theme-str 'listview {lines: 1;}')

[ -z "$URL" ] && exit

CHOICE=$(printf "Best Video\nMP3 Audio\n1080p\n720p" | \
rofi \
-dmenu \
-i \
-p "Download" \
-theme-str 'listview {lines: 2;}')

[ -z "$CHOICE" ] && exit

notify-send "yt-dlp" "Starting download..."

case "$CHOICE" in

"Best Video")
    yt-dlp \
    -f bestvideo+bestaudio \
    --merge-output-format mp4 \
    -P "$VIDEO_DIR" \
    "$URL"
    ;;

"MP3 Audio")
    yt-dlp \
    -x \
    --audio-format mp3 \
    --embed-thumbnail \
    --embed-metadata \
    -P "$MUSIC_DIR" \
    "$URL"
    ;;

"1080p")
    yt-dlp \
    -f "bestvideo[height<=1080]+bestaudio" \
    --merge-output-format mp4 \
    -P "$VIDEO_DIR" \
    "$URL"
    ;;

"720p")
    yt-dlp \
    -f "bestvideo[height<=720]+bestaudio" \
    --merge-output-format mp4 \
    -P "$VIDEO_DIR" \
    "$URL"
    ;;
esac

notify-send "yt-dlp" "Download completed."