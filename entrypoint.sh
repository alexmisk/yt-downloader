#!/bin/sh
while :
do
  if [ -z ${PLAYLIST+x} ]; then echo "Please set PLAYLIST environmental variable" && exit 1; fi
  youtube-dl -U
  flock -n /tmp/yt-downloader.lock sh yt-downloader.sh
  echo "Sleep for $FETCH_INTERVAL ..."
  sleep $FETCH_INTERVAL
done
