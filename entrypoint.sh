#!/bin/bash
while :
do
  youtube-dl -U
  ./yt-downloader.sh

  if [ ${NUMBER_OF_EPISODES_TO_KEEP+x} ]; then
    ./cleanup.sh
  fi

  echo "Sleep for $FETCH_INTERVAL ..."
  sleep $FETCH_INTERVAL
done
