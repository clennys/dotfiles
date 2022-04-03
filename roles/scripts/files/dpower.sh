#!/bin/sh

choices="shutdown\nreboot\ndwm-restart\nlock"

chosen=$(echo -e "$choices" | dmenu -l 30 -p "Powermenu:")

case "$chosen" in
	shutdown) systemctl poweroff;;
	reboot) systemctl reboot;;
	dwm-restart) killall dwm;;
	lock) slock;;
esac
