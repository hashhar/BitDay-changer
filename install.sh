#!/bin/bash

pwd=`pwd`

echo
echo "*** BitDay Wallpaper Changer ***"
echo

echo "Select your screen resolution (or the one nearest to yours):"
echo "1)  1280x720"
echo "2)  1280x800"
echo "3)  1440x900"
echo "4)  1600x900"
echo "5)  1680x1050"
echo "6)  1920x1080"
echo "7)  1920x1200"
echo "8)  2560x1400"
echo "9)  2560x1600"
echo "10) 2880x1800"
echo "11) 3840x2160"
echo "12) 4096x2304"
echo

while read -p "Input your choice (1-12): " input; do
	if [[ -n $input ]]; then
		case $input in
			1) resolution="1280x720"; break;;
			2) resolution="1280x800"; break;;
			3) resolution="1440x900"; break;;
			4) resolution="1600x900"; break;;
			5) resolution="1680x1050"; break;;
			6) resolution="1920x1080"; break;;
			7) resolution="1920x1200"; break;;
			8) resolution="2560x1400"; break;;
			9) resolution="2560x1600"; break;;
			10) resolution="2880x1800"; break;;
			11) resolution="3840x2160"; break;;
			12) resolution="4096x2304"; break;;
		esac
	fi
done

if [[ -z $resolution ]]; then
	resolution="4096x2304"
fi

# Set the download link
download="https://github.com/hashhar/BitDay-changer/raw/master/zip/BitDay-2-$resolution.zip"

echo
echo "Downloading files, please wait..."
echo

# Check if 
if [[ -e "./BitDay-2-$resolution.zip" ]]; then
	echo "Wallpapers already downloaded, skipping download."
else
	wget $download
fi

# Download additional scripts
wget "https://github.com/hashhar/BitDay-changer/raw/master/change.sh"
wget "https://github.com/hashhar/BitDay-changer/raw/master/uninstall.sh"
chmod +x change.sh uninstall.sh

echo
echo "Extracting wallpapers"
unzip "BitDay-2-$resolution.zip"
mv $resolution/* .
rm -rf $resolution
rm -rf __MACOSX
rm -f "BitDay-2-$resolution.zip"
echo "Done"

echo
echo "Creating cron jobs"

line="0 * * * * ${pwd}/change.sh"
if ! crontab -l | grep -Fxq "$line"; then
	(crontab -l ; echo "$line") | crontab -
fi

line="@reboot ${pwd}/change.sh"
if ! crontab -l | grep -Fxq "$line"; then
	(crontab -l ;  echo "$line") | crontab -
fi

echo "Done!"
