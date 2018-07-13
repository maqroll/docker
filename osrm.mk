.PHONY: all clean startServer

all: galicia-norte-portugal.osrm.mldgr galicia-norte-portugal.osrm.cell_metrics galicia-norte-portugal.osrm.cells \
	galicia-norte-portugal.osrm.partition galicia-norte-portugal.osrm.tls galicia-norte-portugal.osrm.tld \
	galicia-norte-portugal.osrm.ramIndex galicia-norte-portugal.osrm.properties \
	galicia-norte-portugal.osrm.names galicia-norte-portugal.osrm.icd galicia-norte-portugal.osrm.fileIndex \
	galicia-norte-portugal.osrm.edges galicia-norte-portugal.osrm.nbg_nodes galicia-norte-portugal.osrm.geometry \
	galicia-norte-portugal.osrm.turn_duration_penalties galicia-norte-portugal.osrm.turn_weight_penalties \
	galicia-norte-portugal.osrm.ebg_nodes \
	spain-latest.osm.pbf portugal-latest.osm.pbf

spain-latest.osm.pbf:
	curl -O http://download.geofabrik.de/europe/spain-latest.osm.pbf

portugal-latest.osm.pbf:
	curl -O http://download.geofabrik.de/europe/portugal-latest.osm.pbf
		
# Move to osmosis because couldn't get files splitted and merged with osmconvert to work with osrm-extract
# osmosis is slower than osmconvert
galicia.osm.pbf: spain-latest.osm.pbf
	docker run --rm  -it --volume ${PWD}:/osm-data yagajs/osmosis osmosis --read-pbf file=/osm-data/spain-latest.osm.pbf --bounding-box top=43.9 left=-9.7 bottom=41.5 right=-5.9 completeWays=yes completeRelations=yes clipIncompleteEntities=true --wb /osm-data/galicia.osm.pbf

norte-portugal.osm.pbf: portugal-latest.osm.pbf	
	docker run --rm  -it --volume ${PWD}:/osm-data yagajs/osmosis osmosis --read-pbf file=/osm-data/portugal-latest.osm.pbf --bounding-box top=42.3 left=-9.4 bottom=39.53 right=-6.01 completeWays=yes completeRelations=yes clipIncompleteEntities=true --wb /osm-data/norte-portugal.osm.pbf

galicia-norte-portugal.osm.pbf: galicia.osm.pbf norte-portugal.osm.pbf
	docker run --rm  -it --volume ${PWD}:/osm-data yagajs/osmosis osmosis --rb /osm-data/galicia.osm.pbf --rb /osm-data/norte-portugal.osm.pbf --merge --wb /osm-data/galicia-norte-portugal.osm.pbf

%.osrm \
%.osrm.cnbg %.osrm.cnbg_to_ebg %.osrm.ebg %.osrm.ebg_nodes %.osrm.edges \
%.osrm.enw %.osrm.fileIndex %.osrm.geometry %.osrm.icd %.osrm.maneuver_overrides \
%.osrm.names %.osrm.nbg_nodes %.osrm.properties %.osrm.ramIndex %.osrm.restrictions \
%.osrm.tld %.osrm.tls %.osrm.turn_duration_penalties %.osrm.turn_penalties_index %.osrm.turn_weight_penalties: %.osm.pbf
	docker run -t -v ${PWD}:/data osrm/osrm-backend osrm-extract -p /opt/car.lua /data/$^

%.osrm.cells %.osrm.partition: %.osrm.cnbg_to_ebg %.osrm.ebg_nodes
	docker run -t -v ${PWD}:/data osrm/osrm-backend osrm-partition /data/$*.osrm

%.osrm.mldgr %.osrm.cell_metrics: %.osrm.edges %.osrm.nbg_nodes %.osrm.geometry %.osrm.turn_duration_penalties %.osrm.turn_duration_penalties %.osrm.ebg_nodes %.osrm.cells %.osrm.partition
	docker run -t -v ${PWD}:/data osrm/osrm-backend osrm-customize /data/$*.osrm	

clean:
	rm -f galicia.osm.pbf norte-portugal.osm.pbf galicia-norte-portugal.osm.pbf galicia-norte-portugal.osrm galicia-norte-portugal.osrm.*ls 

startServer: all
	docker run -t -i -p 5000:5000 -v ${PWD}:/data osrm/osrm-backend osrm-routed --algorithm mld /data/galicia-norte-portugal.osrm