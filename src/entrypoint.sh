#!/bin/sh

if [ -z ${PLAYLIST+x} ]; then
  echo "Nothing to download. Please set PLAYLIST environmental variable" >&2
  exit 1
fi

if [ -z ${FILENAME_TEMPLATE+x} ]; then
  export FILENAME_TEMPLATE='%(epoch)s-%(id)s.%(ext)s'
fi

if [ -z ${AUDIO_QUALITY+x} ]; then
  export AUDIO_QUALITY=9
fi

if [ -z ${NUMBER_OF_ITEMS_TO_DOWNLOAD+x} ]; then
  export NUMBER_OF_ITEMS_TO_DOWNLOAD=-1
fi

mkdir -p /var
curl $DOWNLOADED_LINK -o /var/downloaded.txt

youtube-dl -U

youtube-dl $PLAYLIST \
  --playlist-reverse \
  --playlist-end $NUMBER_OF_ITEMS_TO_DOWNLOAD \
  --output $FILENAME_TEMPLATE \
  --download-archive '/var/downloaded.txt' \
  --extract-audio --audio-format mp3 \
  --audio-quality $AUDIO_QUALITY \
  --add-metadata \
  --exec 'touch -am {} && python transfer.py {}' \
  --ignore-errors
