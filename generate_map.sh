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

#wget -O tampere.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=22.8,61.1850,25,61.7881]"
#wget -O tampere.osm "http://www.overpass-api.de/api/xapi_meta?*[bbox=22.8,61.1850,25,61.7881]"


wget -O tampere.osm "http://z.overpass-api.de/api/xapi_meta?*[bbox=22.8,61.1850,25,61.7881]"


# Split the osm file to smaller pieces


#java -jar -Xmx1000m splitter.jar tampere.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=4096 --max-nodes=3000000 --wanted-admin-level=8

java -jar -Xmx1000m splitter.jar tampere.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=2048 --max-nodes=1000000 --wanted-admin-level=8

#java -jar -Xmx1000m splitter.jar tampere.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=1024 --max-nodes=500000 --wanted-admin-level=8

# Fix the names in the template.args file descriptions, MAX 20 CHARACTERS


python fix_names.py TK_MTB_Tampere


# Create the gmapsupp map file, NOTE THE MAPNAME HAS TO UNIQUE, FAMILY ID IS ALSO UNIQUE

# 6.11.2016 poistettu koodi. Aiheuttaa haamupolkuja overlayerien takia

# java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880001 --family-id=8888 --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK_Tampere.typ

# 6.11.2016 uusi versio, jonka pitaisi estaa haamuviivojen syntyminen


# kes√versio kartasta
java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --mapname=88880001 --description="OpenStreetMap-pohjainen MTB-kartta, Tampereen alue" --family-id=8888 --series-name="OSM MTB Suomi" --style-file=TK/ TK_Tampere.typ --cycle-map --precomp-sea=sea.zip --generate-sea --bounds=bounds.zip --remove-ovm-work-files -c template.args 

# talviversio kartasta
#java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --mapname=88880001 --description="OpenStreetMap-pohjainen MTB-kartta, Tampereen alue" --family-id=8888 --series-name="OSM MTB Suomi" --style-file=TK_W/ TK_Tampere.typ --cycle-map --precomp-sea=sea.zip --generate-sea --bounds=bounds.zip --remove-ovm-work-files -c template.args

# copy the map file to /var/www for downloading and clean up the directory


mv gmapsupp.img tk_tre.img


sudo chown www-data:www-data tk_tre.img


sudo mv -f tk_tre.img /var/www




# Clean the directory
rm -f *.osm osmmap.* *.img *.pbf osmmap_license.txt template* densities* areas*


# OULU
#################
#################


# Retrieving OSM data directly and generating map
#################################################

# Get the osm datafile

#wget -O oulu.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=24.5 ,64.7,26.2,65.25]"
wget -O oulu.osm "http://www.overpass-api.de/api/xapi_meta?*[bbox=24.5 ,64.7,26.2,65.25]"

# Split the osm file to smaller pieces

java -jar -Xmx1000m splitter.jar oulu.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=2048 --max-nodes=1000000 --wanted-admin-level=8

# Fix the names in the template.args file descriptions, MAX 20 CHARACTERS

python fix_names.py TK_MTB_Oulu

# Create the gmapsupp map file, NOTE THE MAPNAME HAS TO UNIQUE, FAMILY ID IS ALSO UNIQUE

java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880002 --family-id=8888 --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK_Oulu.typ

# copy the map file to /var/www for downloading
mv gmapsupp.img tk_oulu.img
sudo chown www-data:www-data tk_oulu.img
sudo mv -f tk_oulu.img /var/www




# LAHTI
#################
#################


# Retrieving OSM data directly and generating map
#################################################

# Get the osm datafile

#wget -O oulu.osm "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=225.3686,60.8862,26.0936,61.1122]"
wget -O lahti.osm "http://www.overpass-api.de/api/xapi_meta?*[bbox=25.3686,60.8862,26.0936,61.1122]"

# Split the osm file to smaller pieces

java -jar -Xmx1000m splitter.jar lahti.osm --precomp-sea=sea.zip --geonames-file=cities15000.zip --max-areas=2048 --max-nodes=1000000 --wanted-admin-level=8

# Fix the names in the template.args file descriptions, MAX 20 CHARACTERS

python fix_names.py TK_MTB_Lahti

# Create the gmapsupp map file, NOTE THE MAPNAME HAS TO UNIQUE, FAMILY ID IS ALSO UNIQUE

java -jar -Xmx1000m mkgmap.jar --max-jobs --gmapsupp --latin1 --tdbfile --nsis --mapname=88880003 --family-id=8888 --style-file=TK/ --precomp-sea=sea.zip --generate-sea --route --drive-on=detect,right --process-destination --process-exits --index --bounds=bounds.zip --location-autofill=is_in,nearest --x-split-name-index --housenumbers --remove-ovm-work-files -c template.args TK_Lahti.typ

# copy the map file to /var/www for downloading
mv gmapsupp.img tk_lahti.img
sudo chown www-data:www-data tk_lahti.img
sudo mv -f tk_lahti.img /var/www



#################################

# Clean the directory
rm -f *.osm osmmap.* *.img *.pbf osmmap_license.txt template* densities* areas*


