#!/bin/bash

set -euo pipefail

PIDFILE="/tmp/recordscreen.pid"
LOGFILE="/tmp/recordscreen.log"

DIR="$HOME/Videos/recordings"
mkdir -p "$DIR"

export DISPLAY=${DISPLAY:-:0}

# =========================
# STOP RECORDING
# =========================

if [[ -f "$PIDFILE" ]]; then

    PID=$(cat "$PIDFILE")

    if kill -0 "$PID" 2>/dev/null; then

        kill -INT "$PID"

        notify-send \
            "󰻃 Recording Stopped" \
            "Saved to $DIR"

    fi

    rm -f "$PIDFILE"

    exit 0
fi

# =========================
# REMOVE OLD PID
# =========================

rm -f "$PIDFILE"

# =========================
# GET CURRENT ACTIVE AUDIO SINK
# =========================

DEFAULT_SINK=$(pactl get-default-sink)

AUDIO_SOURCE="${DEFAULT_SINK}.monitor"

if [[ -z "$AUDIO_SOURCE" ]]; then

    notify-send \
        "󰻃 Recording Failed" \
        "No desktop audio source found"

    exit 1
fi

# =========================
# DETECT RESOLUTION
# =========================

RESOLUTION=$(
    xrandr | \
    grep '*' | \
    head -n1 | \
    awk '{print $1}'
)

[[ -z "$RESOLUTION" ]] && RESOLUTION="1920x1080"

# =========================
# OUTPUT FILE
# =========================

FILE="$DIR/record_$(date +%Y-%m-%d_%H-%M-%S).mp4"

notify-send \
    "󰻃 Recording Started" \
    "🔊 Internal Audio\n📺 $RESOLUTION @ 60 FPS"

# =========================
# START RECORDING
# =========================

ffmpeg \
    -y \
    \
    -thread_queue_size 4096 \
    -f x11grab \
    -video_size "$RESOLUTION" \
    -framerate 60 \
    -i "$DISPLAY" \
    \
    -thread_queue_size 4096 \
    -f pulse \
    -i "$AUDIO_SOURCE" \
    \
    -c:v libx264 \
    -preset veryfast \
    -crf 20 \
    -pix_fmt yuv420p \
    \
    -c:a aac \
    -b:a 192k \
    \
    "$FILE" \
    >"$LOGFILE" 2>&1 &

PID=$!

sleep 1

if kill -0 "$PID" 2>/dev/null; then

    echo "$PID" > "$PIDFILE"

else

    notify-send \
        "󰻃 Recording Failed" \
        "Check $LOGFILE"

    exit 1
fi