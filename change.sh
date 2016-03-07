#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sessionfile=`find "${HOME}/.dbus/session-bus/" -type f`
export `grep "DBUS_SESSION_BUS_ADDRESS" "${sessionfile}" | sed '/^#/d'`

files=(01-Early-Morning.png 02-Mid-Morning.png 03-Late-Morning.png 04-Early-Afternoon.png 05-Mid-Afternoon.png 06-Late-Afternoon.png 07-Early-Evening.png 08-Mid-Evening.png 09-Late-Evening.png 10-Early-Night.png 11-Mid-Night.png 12-Late-Night.png
);

timing=(6 8 10 12 14 15 16 17 18 19 21 23
);

hour=`date +%H`
hour=$(echo $hour | sed 's/^0*//')

case $XDG_CURRENT_DESKTOP in
	Mint|Mate) setcmd="gsettings set org.mate.background picture-uri";;
	Cinnamon) setcmd="gsettings set org.cinnamon.background picture-uri";;	
	*) setcmd="gsettings set org.gnome.desktop.background picture-uri";; # GNOME/Unity, default
esac
if [[ -z $XDG_CURRENT_DESKTOP ]]; then # Fallback for i3
	case $DESKTOP_SESSION in
		i3) setcmd="feh --bg-max"
	esac
fi

for i in {13..0..-1}; do # Loop backwards through the wallpapers 
    if [[ $hour -le ${timing[i]} ]]; then
	$setcmd file://$DIR/${files[i]}
        echo "Wallpaper set to ${files[i]}"
        exit
    fi
done

# Fallback at last wallpaper if time is not relevant
$setcmd file://$DIR/${files[11]}
echo "Wallpaper set to ${files[11]}"
