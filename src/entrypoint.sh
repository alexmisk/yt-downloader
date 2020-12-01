#!/bin/bash

set -e

while :
do
  ./yt-downloader.sh
  ./cleanup.sh
  ./sleep.sh
done
