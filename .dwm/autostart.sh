#!/bin/sh

# ---- Disable screen sleep ----
xset s off
xset -dpms
xset s noblank

# ---- wallpaper ----
[ -f "$HOME/.fehbg" ] && "$HOME/.fehbg" &

# ---- Compositor ----
pgrep -x picom >/dev/null || picom &

# ---- Load st theme + alpha BEFORE any terminal starts ----
xrdb -merge ~/.config/suckless/st/xresources

# ---- Display settings ----
(sleep 2 && xrandr --output HDMI-A-0 --mode 1920x1080 --rate 165) &
(sleep 2 && xrandr --output eDP --gamma 0.95:0.98:1.05 --brightness 0.92) &

# ---- Notifications ----
dunst --replace &

# ---- Eww ----
pgrep -x eww >/dev/null || eww daemon &

# ---- Clipboard ----
pgrep -x greenclip >/dev/null || greenclip daemon &

# ---- Status bar ----
pkill dwmblocks 2>/dev/null
/usr/local/bin/dwmblocks &

# ---- Network tray ----
pgrep -x nm-applet >/dev/null || nm-applet &

# ---- Polkit ----
pgrep -f polkit-gnome-authentication-agent-1 >/dev/null || \
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# ---- Keyboard layout ----
setxkbmap -model pc105 -layout us,ru -option grp:alt_shift_toggle &

# ---- Mouse settings ----
(sleep 1 && xinput --set-prop "E-Signal USB Gaming Mouse" "libinput Accel Profile Enabled" 0,1,0) &
(sleep 1 && xinput --set-prop "E-Signal USB Gaming Mouse" "libinput Accel Speed" -0.6) &

# ---- Cursor fix ----
xsetroot -cursor_name left_ptr &
