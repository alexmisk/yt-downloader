#!/bin/bash

set -e

while :
do
  ./download.sh
  ./cleanup.sh
  ./sleep.sh
done
