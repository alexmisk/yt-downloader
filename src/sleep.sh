#!/bin/bash

if [ -z ${FETCH_INTERVAL+x} ]; then
  export FETCH_INTERVAL=1d
fi

echo "Sleep for $FETCH_INTERVAL ..."
if [[ $DEBUG ]]; then exit 0; fi
sleep $FETCH_INTERVAL
