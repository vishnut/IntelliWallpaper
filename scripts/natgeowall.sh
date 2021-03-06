#!/bin/bash
# Vishnu Thiagarajan, 2017
# http://vishnut.me
# This script will set your wallpaper to be National Geographic's picture
# of the Day.
# Published under MIT license

BASEDIR=$(dirname "$0")
echo "$BASEDIR"
FILENAME="${RANDOM}_${RANDOM}"

cd $BASEDIR

echo "Downloading Document"
curl "https://www.nationalgeographic.com/photography/photo-of-the-day/" > images/doc.txt

echo "Finding Image URL"
grep -i -h -o "https://yourshot.nationalgeographic.com/u/.*./" images/doc.txt > images/docurl.txt

saveURL=`grep -m 1 -v "\"" images/docurl.txt`
echo "Found Image URL: $saveURL"

rm ${BASEDIR}/images/*.jpg
curl -o images/"$FILENAME".jpg "$saveURL"
echo "Image Saved as images/${FILENAME}.jpg"

rm images/doc.txt
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
