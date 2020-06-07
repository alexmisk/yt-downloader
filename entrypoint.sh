#!/bin/sh
while :
do
  flock -n /tmp/yt-downloader.lock sh yt-downloader.sh
  sleep 30
done
