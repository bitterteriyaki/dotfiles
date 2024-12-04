#!/bin/bash

fmt='{
  "hour": "%I",
  "min": "%M",
  "sec": "%S",
  "day": "%d",
  "month": "%m",
  "year": "%Y",
  "meridiem": "%p"
}'
date=$(date +"$fmt")

echo "$(echo "$date" | jq -c .)"
