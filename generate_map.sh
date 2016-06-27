#!/bin/bash
#
# mktiles.sh
#
# Exit on error
set -o errexit
set -o nounset


cd /home/nissiant/Garmin_OSM_TK_map

# Update the style files before generation
sudo -u nissiant git pull

# TAMPERE
#################
#################


# Retrieving OSM data and splitting to manageable size
#######################################################

# get the osm data file

wget -O tampere.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=22.8,61.1850,25,61.7881]"
###wget -O map.osm "http://www.overpass-api.de/api/xapi_meta?*[bbox=23.2182,61.1850,24.3059,61.7881]"

# Split the osm file to smaller pieces

java -jar -Xmx1000m splitter.jar tampere.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=4096 --max-nodes=3000000 --wanted-admin-level=8

# Fix the names in the template.args file descriptions

python fix_names.py OSM_MTB_Tampere_region


# Create the gmapsupp map file, NOTE THE MAPNAME HAS TO UNIQUE

java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880001 --family-id=8888 --series-name="OSM MTB Tampere region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK.typ

#java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880001 --family-id=8888 --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK.typ

# copy the map file to /var/www for downloading and clean up the directory

mv gmapsupp.img OSM_TK_MTB_map_Tampere.img
sudo chown www-data:www-data OSM_TK_MTB_map_Tampere.img
sudo mv -f OSM_TK_MTB_map_Tampere.img /var/www



# Clean the directory
rm -f *.osm osmmap.* *.img *.pbf osmmap_license.txt template* densities* areas*


# OULU
#################
#################


# Retrieving OSM data directly and generating map
#################################################

# Get the osm datafile

wget -O oulu.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=24.5 ,64.7,26.2,65.25]"

# Split the osm file to smaller pieces

java -jar -Xmx1000m splitter.jar oulu.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=2048 --max-nodes=1000000 --wanted-admin-level=8

# Fix the names in the template.args file descriptions

python fix_names.py OSM_MTB_Oulu_region

# Create the gmapsupp map file, NOTE THE MAPNAME HAS TO UNIQUE

java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880002 --family-id=8888 --series-name="OSM MTB Oulu region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK.typ

# copy the map file to /var/www for downloading
mv gmapsupp.img OSM_TK_MTB_map_Oulu.img
sudo chown www-data:www-data OSM_TK_MTB_map_Oulu.img
sudo mv -f OSM_TK_MTB_map_Oulu.img /var/www

#################################

# Clean the directory
rm -f *.osm osmmap.* *.img *.pbf osmmap_license.txt template* densities* areas*


