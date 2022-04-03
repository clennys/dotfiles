#!/usr/bin/env bash

filemanager=vifm
term=st
editor=nvim
videoplayer=mpv
audioplayer=mpv
imageviewer=sxiv
pdfviewer=zathura

path="$(find /home/dennys/Nextcloud/notes/notability/04_FS22 -not -name "*.zip"| dmenu -l 30 -p "Open File/Dir:")"

[[ -d "$path" ]] && ($term -e $filemanager "$path" &) && exit

case "$(xdg-mime query filetype "$path")" in

	text/*) ($term -e $editor "$path" &);;
	video/*) "$videoplayer" "$path";;
	audio/*) "$audioplayer" "$path";;
	image/*) "$imageviewer" "$path";;
	application/pdf*) "$pdfviewer" "$path";;
	*) xdg-open "$path";;
esac
