#!/bin/sh
while :
do

  flock -n /tmp/yt-downloader.lock sh yt-downloader.sh
  echo "Sleep..."

  if [ ! -z "$FETCH_INTERVAL" ]
  then
    sleep $FETCH_INTERVAL
  else
    sleep 1d
  fi

done
