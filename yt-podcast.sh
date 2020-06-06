#!/bin/sh

youtube-dl \
  $PLAYLIST \
  --extract-audio --audio-format mp3          \
  --output '%(title)s [%(uploader)s].%(ext)s' \
  --download-archive '/out/downloaded.txt'    \
  --add-metadata                              \
  --ignore-errors

touch -am *.mp3
mv *.mp3 /out
