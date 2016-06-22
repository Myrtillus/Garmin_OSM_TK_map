#!/bin/bash
#
# mktiles.sh
#
# Exit on error
set -o errexit
set -o nounset


cd /home/nissiant/Garmin_OSM_TK_map

# TAMPERE
#################


# Splitting the data from finland dump and generate map
#########################################################

osmosis/bin/osmosis --read-pbf file=/var/tmp/osm/finland-latest.osm.pbf --bounding-box left=23 bottom=60.8 right=24.9 top=62.00 --write-pbf tampere_region_final.osm.pbf

java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880001 --description=OSM_MTB_Tampere_region --family-id=8888 --series-name="OSM MTB Tampere region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files tampere_region_final.osm.pbf TK.typ

# Retrieving OSM data directly and generating map
#################################################

#wget -O tampere.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=23.2182,61.1850,24.3059,61.7881]"
#wget -O tampere.osm "http://www.overpass-api.de/api/xapi_meta?*[bbox=23.2182,61.1850,24.3059,61.7881]"

#java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880001 --description=OSM_MTB_Tampere_region --family-id=8888 --series-name="OSM MTB Tampere region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files tampere.osm TK.typ



# copy the map file to /var/www for downloading and clean up the directory

mv gmapsupp.img OSM_TK_MTB_map.img
sudo chown www-data:www-data OSM_TK_MTB_map.img
sudo mv -f OSM_TK_MTB_map.img /var/www
rm tampere.osm


# OULU
#################


# Splitting the file
osmosis/bin/osmosis --read-pbf file=/var/tmp/osm/finland-latest.osm.pbf --bounding-box left=24.4 bottom=64.6 right=26.5 top=65.33 --write-pbf oulu_region_final.osm.pbf

# Generate the map file
java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880002 --description=OSM_MTB_Oulu_region --family-id=8888 --series-name="OSM MTB Oulu region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files oulu_region_final.osm.pbf TK.typ

# copy the map file to /var/www for downloading
mv gmapsupp.img OSM_TK_MTB_map_Oulu.img
sudo chown www-data:www-data OSM_TK_MTB_map_Oulu.img
sudo mv -f OSM_TK_MTB_map_Oulu.img /var/www


#################################

# Clean the directory
rm osmmap.* *.img *.pbf osmmap_license.txt



# uuden datan kiskaiseminen
#  wget -O tampere.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=23.2182,61.1850,24.3059,61.7881]"

