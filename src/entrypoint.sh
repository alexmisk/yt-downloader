#!/bin/bash

set -e

while :
do
  youtube-dl -U
  ./yt-downloader.sh
  ./cleanup.sh
  echo "Sleep for $FETCH_INTERVAL ..."
  if [[ $DEBUG ]]; then exit 0; fi
  sleep $FETCH_INTERVAL
done
