#!/bin/bash

if [ -z ${NUMBER_OF_EPISODES_TO_KEEP+x} ]; then
  exit 0
fi

if ! [[ $NUMBER_OF_EPISODES_TO_KEEP =~ ^[0-9]+$ ]]; then
   echo "NUMBER_OF_EPISODES_TO_KEEP is not a number. Aborting..." >&2
   exit 1
fi

if [ -z ${NUMBER_OF_EPISODES_TO_KEEP+x} ]; then
  export NUMBER_OF_ITEMS_TO_DOWNLOAD -1
fi


EPISODES_COUNT=$(find /out -regex '.*\.mp3' -printf '%f\n' | wc -l)
NUMBER_OF_EPISODES_TO_DELETE=$((EPISODES_COUNT-NUMBER_OF_EPISODES_TO_KEEP))

if [ $NUMBER_OF_EPISODES_TO_DELETE -gt 0 ]; then
  find /out -name "*.mp3" -printf "%T@ %p\n" \
    | sort -n \
    | awk '{print $2}' \
    | head -$NUMBER_OF_EPISODES_TO_DELETE \
    | xargs rm && \
  echo "Cleaning: Deleted $NUMBER_OF_EPISODES_TO_DELETE episodes"
else
  echo "Cleaning: Nothing deleted"
fi
