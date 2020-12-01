#!/bin/bash

echo "Sleep for $FETCH_INTERVAL ..."
if [[ $DEBUG ]]; then exit 0; fi
sleep $FETCH_INTERVAL
