# use PGDATABASE PGHOST etc.
SHELL := /bin/bash

mml: toner

install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner
	npm install && npm rebuild
	echo DATABASE_URL=postgres:///osm > .env

clean:
	rm *.mml *.xml

toner: toner.mml
	cp $@.mml project.mml

toner-background: toner-background.mml
	cp $@.mml project.mml

toner-lines: toner-lines.mml
	cp $@.mml project.mml

toner-labels: toner-labels.mml
	cp $@.mml project.mml

toner-hybrid: toner-hybrid.mml
	cp $@.mml project.mml

xml: toner.xml toner-background.xml toner-lines.xml toner-labels.xml toner-hybrid.xml

data/land-polygons-complete-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/land-polygons-complete-3857.zip -o data/land-polygons-complete-3857.zip

land: data/land-polygons-complete-3857.zip 
	cd shp/ && unzip -o ../data/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp

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

toner.mml: toner.yml
	cat $< | (set -a && source .env && interp) > $@

toner-background.mml: toner-background.yml
	cat $< | (set -a && source .env && interp) > $@

toner-lines.mml: toner-lines.yml
	cat $< | (set -a && source .env && interp) > $@

toner-labels.mml: toner-labels.yml
	cat $< | (set -a && source .env && interp) > $@

toner-hybrid.mml: toner-hybrid.yml
	cat $< | (set -a && source .env && interp) > $@

toner.xml: toner.mml
	carto -l $< > $@

toner-background.xml: toner-background.mml
	carto -l $< > $@

toner-lines.xml: toner-lines.mml
	carto -l $< > $@

toner-labels.xml: toner-labels.mml
	carto -l $< > $@

toner-hybrid.xml: toner-hybrid.mml
	carto -l $< > $@
