#!/bin/sh

youtube-dl $PLAYLIST \
  --playlist-reverse \
  --output '%(id)s.%(ext)s' \
  --download-archive '/out/downloaded.txt' \
  --extract-audio --audio-format mp3 \
  --audio-quality 9 \
  --add-metadata \
  --exec 'touch -am {} && mv {} /out' \
  --ignore-errors
