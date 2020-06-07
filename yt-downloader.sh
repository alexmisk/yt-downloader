#!/bin/sh

youtube-dl \
  $PLAYLIST \
  --extract-audio --audio-format mp3          \
  --output '%(title)s [%(uploader)s].%(ext)s' \
  --download-archive '/out/downloaded.txt'    \
  --exec 'touch -am {} && mv {} /out'         \
  --add-metadata                              \
  --ignore-errors
