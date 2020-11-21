#!/bin/bash
while :
do
  if [ -z ${PLAYLIST+x} ]; then echo "Please set PLAYLIST environmental variable" && exit 1; fi
  youtube-dl -U
  flock -n /tmp/yt-downloader.lock sh yt-downloader.sh

  if [ ${NUMBER_OF_EPISODES_TO_KEEP+x} ]; then
    ./cleanup.sh
  fi

  echo "Sleep for $FETCH_INTERVAL ..."
  sleep $FETCH_INTERVAL
done
