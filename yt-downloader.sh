#!/bin/sh

youtube-dl $PLAYLIST \
  --playlist-reverse \
  --playlist-end $NUMBER_OF_ITEMS_TO_DOWNLOAD \
  --output $FILENAME_TEMPLATE \
  --download-archive '/out/downloaded.txt' \
  --extract-audio --audio-format mp3 \
  --audio-quality $AUDIO_QUALITY \
  --add-metadata \
  --exec 'touch -am {} && mv {} /out' \
  --ignore-errors
