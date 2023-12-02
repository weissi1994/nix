#!/bin/sh
exec swayidle -w \
	timeout 480 '~/.config/sway/lock.sh' \
	timeout 960 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
	\
	before-sleep '~/.config/sway/lock.sh' #timeout 600 'systemctl suspend"' \
