#!/bin/bash

if [ $# = 0 ]; then
 	echo "simple utility to fix Creation Date metadata in QuickTime videos"
	echo "LifeFlix imports video from DV camera, setting CreationDate tag, but not the localized version (CreationDate-ita-IT)."
	echo "iMovie imports file giving priority to localized tag, so CreationDate is broken and lost" 	
	echo $0 filename
	exit 1
fi

FILE=$1
DATE=`exiftool -S -FileModifyDate $FILE | cut -d' ' -f2-`
echo $FILE "'$DATE'"
exiftool '-all=' $FILE
exiftool "-CreateDate=$DATE" "-ModifyDate=$DATE" "-TrackCreateDate=$DATE" "-TrackModifyDate=$DATE" "-MediaCreateDate=$DATE" "-MediaModifyDate=$DATE" "-CreationDate=$DATE" $FILE
touch -a -m -r ${FILE}_original $FILE 
