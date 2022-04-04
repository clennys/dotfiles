#!/bin/sh

# this file is run when calling startx

# default arch init scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
fi

# user init scripts and settings
# [ -r /etc/X11/xinit/.Xmodmap ] && xmodmap /etc/X11/xinit/.Xmodmap
# [ -r ~/.Xmodmap ] && xmodmap ~/.Xmodmap
if xrandr | grep "DP-1-1.3 connected"
then
	[ -r ~/.local/share/xorg/.Xresources ] && xrdb -merge ~/.local/share/xorg/.Xresources
else
	[ -r ~/.Xresources ] && xrdb -merge ~/.Xresources
fi
[ -r ~/.xprofile ] && . ~/.xprofile

while true; do
   xsetroot -name "$( date +" %Y-%m-%d %a %H:%M " )"
   sleep 1m    # Update time every minute
done &


xmodmap ~/.Xmodmap

# launch the session, commands below this line will be ignored
# exec dwm
exec ~/.local/bin/startdwm.sh
