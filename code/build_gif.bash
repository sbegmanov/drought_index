#!/usr/bin/env bash


mkdir -p map_tempdir

git log --pretty=format:"%h %ai %s" --after "2025-12-30 12:00:00" visuals/world_drought_on_2025_data.png |
while read h; do
  HASH=$(echo "$h" | sed 's/^\(.*\) 20..-.*/\1/')
  DATE=$(echo "$h" | sed 's/.* \(20..-..-..\).*/\1/')
  echo "$DATE"
  echo "$HASH"
  git cat-file -p ${HASH}:visuals/world_drought_on_2025_data.png > map_tempdir/${DATE}.png
done

convert -delay 20 map_tempdir/*png visuals/world_drought.gif