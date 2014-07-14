# use PGDATABASE PGHOST etc.
SHELL := /bin/bash
PATH := $(PATH):node_modules/.bin

mml: toner

install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner
	npm install && npm rebuild
	echo DATABASE_URL=postgres:///osm > .env

clean:
	rm -f *.mml *.xml

toner: toner.mml
	# delete project.mml to signal TM1 that it's changed
	rm -f project.mml
	ln -s $@.mml project.mml

toner-base: toner-base.mml
	rm -f project.mml
	ln -s $@.mml project.mml

toner-background: toner-background.mml
	rm -f project.mml
	ln -s $@.mml project.mml

toner-lines: toner-lines.mml
	rm -f project.mml
	ln -s $@.mml project.mml

toner-buildings: toner-buildings.mml
	rm -f project.mml
	ln -s $@.mml project.mml

toner-labels: toner-labels.mml
	rm -f project.mml
	ln -s $@.mml project.mml

toner-hybrid: toner-hybrid.mml
	rm -f project.mml
	ln -s $@.mml project.mml

xml: toner.xml toner-base.xml toner-background.xml toner-lines.xml toner-buildings.xml toner-labels.xml toner-hybrid.xml

data/land-polygons-complete-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/land-polygons-complete-3857.zip -o $@

data/simplified-land-polygons-complete-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip -o $@

land: data/land-polygons-complete-3857.zip data/simplified-land-polygons-complete-3857.zip
	cd shp/ && unzip -o ../data/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp
	cd shp/ && unzip -o ../data/simplified-land-polygons-complete-3857.zip
	cd shp/ && shapeindex simplified-land-polygons-complete-3857/simplified_land_polygons.shp

ca:
	dropdb ca
	createdb ca
	psql ca -c "create extension postgis"
	~/workspace/imposm/bin/imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read /Volumes/Work/osm/california-latest.osm.pbf -connection="postgis://localhost/ca" -write -deployproduction -overwritecache -optimize
	psql ca -f highroad.sql

ma:	data/massachusetts.osm.pbf
	dropdb --if-exists imposm_ma
	createdb imposm_ma
	psql -d imposm_ma -c "create extension postgis"
	imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read $< -connection="postgis://localhost/imposm_ma" -write -deployproduction -overwritecache -optimize
	psql -d imposm_ma -f highroad.sql
	echo DATABASE_URL=postgres:///imposm_ma > .env

sf: data/san-francisco.osm.pbf
	dropdb --if-exists imposm_sf
	createdb imposm_sf
	psql -d imposm_sf -c "create extension postgis"
	imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read $< -connection="postgis://localhost/imposm_sf" -write -deployproduction -overwritecache -optimize
	psql -d imposm_sf -f highroad.sql
	echo DATABASE_URL=postgres:///imposm_sf > .env

seattle: data/seattle.osm.pbf
	dropdb --if-exists imposm_seattle
	createdb imposm_seattle
	psql -d imposm_seattle -c "create extension postgis"
	imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read $< -connection="postgis://localhost/imposm_seattle" -write -deployproduction -overwritecache -optimize
	psql -d imposm_seattle -f highroad.sql
	echo DATABASE_URL=postgres:///imposm_seattle > .env

sf-bay-area: data/sf-bay-area.osm.pbf
	dropdb --if-exists imposm_sf_bay_area
	createdb imposm_sf_bay_area
	psql -d imposm_sf_bay_area -c "create extension postgis"
	imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read $< -connection="postgis://localhost/imposm_sf_bay_area" -write -deployproduction -overwritecache -optimize
	psql -d imposm_sf_bay_area -f highroad.sql
	echo DATABASE_URL=postgres:///imposm_sf_bay_area > .env

data/massachusetts.osm.pbf:
	mkdir -p data
	curl -sL http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -o $@

data/san-francisco.osm.pbf:
	mkdir -p data
	curl -sL https://s3.amazonaws.com/metro-extracts.mapzen.com/san-francisco.osm.pbf -o $@

data/seattle.osm.pbf:
	mkdir -p data
	curl -sL https://s3.amazonaws.com/metro-extracts.mapzen.com/seattle.osm.pbf -o $@

data/sf-bay-area.osm.pbf:
	mkdir -p data
	curl -sL https://s3.amazonaws.com/metro-extracts.mapzen.com/sf-bay-area.osm.pbf -o $@

toner.mml: toner.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-base.mml: toner-base.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-background.mml: toner-background.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-lines.mml: toner-lines.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-buildings.mml: toner-buildings.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-labels.mml: toner-labels.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner-hybrid.mml: toner-hybrid.yml .env
	cat $< | (set -a && source .env && interp) > $@

toner.xml: toner.mml
	carto -l $< > $@

toner-base.xml: toner-base.mml
	carto -l $< > $@

toner-background.xml: toner-background.mml
	carto -l $< > $@

toner-lines.xml: toner-lines.mml
	carto -l $< > $@

toner-buildings.xml: toner-buildings.mml
	carto -l $< > $@

toner-labels.xml: toner-labels.mml
	carto -l $< > $@

toner-hybrid.xml: toner-hybrid.mml
	carto -l $< > $@
