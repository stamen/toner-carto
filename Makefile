# use PGDATABASE PGHOST etc.

mml: project.mml

install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner
	npm install && npm rebuild
	echo DATABASE_URL=postgres:///osm > .env

clean:
	rm project.mml

project.mml: project.yml
	cat project.yml | (source .env && node jsonify.js $$DATABASE_URL)

data/land-polygons-complete-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/land-polygons-complete-3857.zip -o data/land-polygons-complete-3857.zip

land: data/land-polygons-complete-3857.zip 
	cd shp/ && unzip -o ../data/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp

xml: project.mml
	millstone project.mml > project_milled.mml
	carto project_milled.mml > project.xml

ca:
	dropdb ca
	createdb ca
	psql ca -c "create extension postgis"
	~/workspace/imposm/bin/imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read /Volumes/Work/osm/california-latest.osm.pbf -connection="postgis://localhost/ca" -write -deployproduction -overwritecache -optimize
	psql ca -f highroad.sql

seattle:
	dropdb --if-exists imposm_seattle
	createdb imposm_seattle
	psql -d imposm_seattle -c "create extension postgis"
	imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read seattle.osm.pbf -connection="postgis://localhost/imposm_seattle" -write -deployproduction -overwritecache -optimize
	psql -d imposm_seattle -f highroad.sql
