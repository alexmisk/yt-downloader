#!/bin/sh
while :
do
  youtube-dl -U
  flock -n /tmp/yt-downloader.lock sh yt-downloader.sh
  echo "Sleep for $FETCH_INTERVAL ..."
  sleep $FETCH_INTERVAL
done
