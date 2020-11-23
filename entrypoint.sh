#!/bin/bash

set -e

while :
do
  youtube-dl -U
  ./yt-downloader.sh
  ./cleanup.sh
  echo "Sleep for $FETCH_INTERVAL ..."
  sleep $FETCH_INTERVAL
done
