#!/bin/bash
# Vishnu Thiagarajan, 2017
# http://vishnut.me
# This script will set your wallpaper to be one of the curated
# wallpaper images from intelliWAllpaper's training data
# Uses Unsplash

BASEDIR=$(dirname "$0")
echo "$BASEDIR"
FILENAME="${RANDOM}_${RANDOM}"

cd $BASEDIR

echo "Downloading Image URL"
curl "http://ec2-54-197-169-159.compute-1.amazonaws.com/random-good-image" > images/docurl.txt

saveURL=`grep -m 1 -v "\"" images/docurl.txt`
echo "Found Image URL: $saveURL"

rm ${BASEDIR}/images/*.jpg
curl -o images/"$FILENAME".jpg "$saveURL"
echo "Image Saved as images/${FILENAME}.jpg"

rm images/docurl.txt
echo "Removed temp files"
cwdText=`pwd`

saveLoc="${cwdText}/images/${FILENAME}.jpg"
echo $saveLoc

setScript="tell application \"System Events\"
    set desktopCount to count of desktops
    repeat with desktopNumber from 1 to desktopCount
        tell desktop desktopNumber
            set picture to \"${saveLoc}\"
        end tell
    end repeat
end tell"
osascript -e "$setScript"

setScript="tell application \"Finder\" to set desktop picture to \"${saveLoc}\" as POSIX file" 
osascript -e "$setScript"

echo "Wallpaper set!"
