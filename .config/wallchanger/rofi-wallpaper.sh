#!/bin/sh

WALLDIR="$HOME/.config/wallchanger/wallpapers"
CACHEDIR="$HOME/.cache/wallchanger"

mkdir -p "$CACHEDIR"

# generate thumbnails if missing
for img in "$WALLDIR"/*; do
    [ -f "$img" ] || continue
    name="$(basename "$img")"
    thumb="$CACHEDIR/$name.png"

    if [ ! -f "$thumb" ]; then
        convert "$img" -resize 300x200^ -gravity center -extent 300x200 "$thumb"
    fi
done

# build rofi list with icons
choice=$(for img in "$WALLDIR"/*; do
    name="$(basename "$img")"
    echo -en "$name\0icon\x1f$CACHEDIR/$name.png\n"
done | rofi -dmenu -i \
    -theme-str '
    window { width: 80%; }
    listview { columns: 5; lines: 3; }
    element { orientation: vertical; }
    element-icon { size: 200px; }
    element-text { horizontal-align: 0.5; }
    ')

[ -z "$choice" ] && exit

feh --bg-fill "$WALLDIR/$choice"
