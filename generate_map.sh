#!/bin/bash
#
# mktiles.sh
#
# Exit on error
set -o errexit
set -o nounset


cd /home/nissiant/Garmin_OSM_TK_map

# Splitting the file
#osmosis/bin/osmosis --read-pbf file=/var/tmp/osm/finland-latest.osm.pbf --bounding-box left=23.20 bottom=61.20 right=24.6 top=62.00 --write-pbf tampere_region_final.osm.pbf
osmosis/bin/osmosis --read-pbf file=/var/tmp/osm/finland-latest.osm.pbf --bounding-box left=23 bottom=60.8 right=24.9 top=62.00 --write-pbf tampere_region_final.osm.pbf

# Generate the map file
java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88889999 --description=OSM_MTB_Tampere_region --family-id=8888 --series-name="OSM MTB Tampere region" --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files tampere_region_final.osm.pbf TK.typ

# copy the map file to /var/www for downloading
mv gmapsupp.img OSM_TK_MTB_map.img
sudo chown www-data:www-data OSM_TK_MTB_map.img
sudo mv -f OSM_TK_MTB_map.img /var/www

# Clean the directory
rm osmmap.* *.img *.pbf osmmap_license.txt

