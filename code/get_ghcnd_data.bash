#!/usr/bin/env bash
file=$1

rm data/$file

curl -L -C - -o data/$file https://www.ncei.noaa.gov/pub/data/ghcn/daily/$file