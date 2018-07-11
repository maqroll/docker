# TODO rewrite as makefile

# download basic data
# curl -O http://download.geofabrik.de/europe/spain-latest.osm.pbf
# curl -O http://download.geofabrik.de/europe/portugal-latest.osm.pbf

# merge spain & portugal 
# osrm-extract don't work with peninsula.osm.pbf 
# too big? incompatible? extract galicia or check with spain?
#docker run --rm  -it --volume ${PWD}:/osm mediagis/osmtools osmconvert spain-latest.osm.pbf -o=spain-latest.o5m
#docker run --rm  -it --volume ${PWD}:/osm mediagis/osmtools osmconvert portugal-latest.osm.pbf -o=portugal-latest.o5m
#docker run --rm  -it --volume ${PWD}:/osm mediagis/osmtools osmconvert spain-latest.o5m portugal-latest.o5m -o=peninsula.o5m
#docker run --rm  -it --volume ${PWD}:/osm mediagis/osmtools osmconvert peninsula.o5m -o=peninsula.osm.pbf

#docker run --rm -it -v $(pwd):/data osrm/osrm-backend osrm-extract -p /opt/car.lua /data/portugal-latest.osm.pbf
#docker run -t -v $(pwd):/data osrm/osrm-backend osrm-partition /data/portugal-latest.osrm
#docker run -t -v $(pwd):/data osrm/osrm-backend osrm-customize /data/portugal-latest.osrm

docker run -t -i -p 5000:5000 -v $(pwd):/data osrm/osrm-backend osrm-routed --algorithm mld /data/portugal-latest.osrm