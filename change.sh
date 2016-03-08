#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PID=$(pgrep gnome-session)
for i in $PID; do
	export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$i/environ|cut -d= -f2-);
done

files=(01-Early-Morning.png 02-Mid-Morning.png 03-Late-Morning.png 04-Early-Afternoon.png 05-Mid-Afternoon.png 06-Late-Afternoon.png 07-Early-Evening.png 08-Mid-Evening.png 09-Late-Evening.png 10-Early-Night.png 11-Mid-Night.png 12-Late-Night.png
);

timing=(6 8 10 12 14 15 16 17 18 19 21 23
);

hour=`date +%H`
hour=$(echo $hour | sed 's/^0*//')

case $XDG_CURRENT_DESKTOP in
	Mint|Mate) setcmd="gsettings set org.mate.background picture-uri";;
	Cinnamon) setcmd="gsettings set org.cinnamon.background picture-uri";;
	i3) setcmd="feh --bg-fill";;
	*) setcmd="gsettings set org.gnome.desktop.background picture-uri";; # GNOME/Unity, default
esac

for i in {11..0..-1}; do # Loop backwards through the wallpapers 
    if [[ $hour -ge ${timing[i]} ]]; then
	$setcmd file://$DIR/${files[i]}
        echo "Wallpaper set to ${files[i]}"
        exit
    fi
done

# Fallback at last wallpaper if time is not relevant
$setcmd file://$DIR/${files[11]}
echo "Wallpaper set to ${files[11]}"
