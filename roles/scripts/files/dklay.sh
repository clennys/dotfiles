#!/bin/sh

choices="us\ndvorak\nswiss"

chosen=$(echo -e "$choices" | dmenu -l 30 -p "Keyboard Layout:")

case "$chosen" in
	dvorak) setxkbmap us -variant dvorak-alt-intl;;
	us) setxkbmap us altgr-intl;;
	swiss) setxkbmap ch;;
esac
xmodmap ~/.Xmodmap
