#!/bin/bash

fmt='{
  "hour": "%I",
  "min": "%M",
  "sec": "%S",
  "pretty": "%d %B, %Y",
  "day": "%A",
  "month": "%B",
  "dom": "%e",
  "year": "%Y",
  "day_num": "%d",
  "month_num": "%m",
  "year_num": "%y"
}'
date=$(date +"$fmt")

echo "$(echo "$date" | jq -c .)"

