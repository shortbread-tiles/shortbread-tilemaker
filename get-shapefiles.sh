#! /bin/bash

cd "$(dirname "$0")" || exit

mkdir -p data
cd data || exit
if [ ! -s water-polygons-split-4326.zip ] ; then
	curl -LO "https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip"
fi

if [ water-polygons-split-4326.zip -nt water-polygons-split-4326/water_polygons.shp ] ; then
	unzip -u water-polygons-split-4326.zip
	touch water-polygons-split-4326/*
fi
