#!/bin/bash

chosen=$(cat ~/.config/emoji | rofi -dmenu | sed "s/ .*//")

[ -z "$chosen" ] && exit

printf "%s" "$chosen" | xclip -selection clipboard

notify-send "'$chosen' copied to clipboard."
