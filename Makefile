# use PGDATABASE PGHOST etc.
SHELL := /bin/bash
PATH := $(PATH):node_modules/.bin

# Import PBF ($2) as $1
define import
dropdb --if-exists imposm_$1
createdb imposm_$1
psql -d imposm_$1 -c "create extension postgis"
imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read $2 -connection="postgis://localhost/imposm_$1" -write -deployproduction -overwritecache -optimize
psql -d imposm_$1 -f highroad.sql
echo DATABASE_URL=postgres:///imposm_$1 > .env
endef

mml: toner

install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner
	npm install && npm rebuild
	echo DATABASE_URL=postgres:///osm > .env

baseami:
	packer build -var-file=secrets.json packer-base.json

ami:
	packer build -var-file=secrets.json packer.json

clean:
	rm -f *.mml *.xml

%: %.mml
	# delete project.mml to signal TM1 that it's changed
	rm -f project.mml
	ln -s $< project.mml

xml: toner.xml toner-base.xml toner-background.xml toner-lines.xml toner-buildings.xml toner-labels.xml toner-hybrid.xml

land: data/osmdata/land-polygons-complete-3857.zip data/osmdata/simplified-land-polygons-complete-3857.zip
	cd shp/ && unzip -o ../data/osmdata/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp
	cd shp/ && unzip -o ../data/osmdata/simplified-land-polygons-complete-3857.zip
	cd shp/ && shapeindex simplified-land-polygons-complete-3857/simplified_land_polygons.shp

belize: data/extract/central-america/belize-latest.osm.pbf
	$(call import,$@,$<)

ca: data/extract/north-america/us/california-latest.osm.pbf
	$(call import,$@,$<)

ma:	data/extract/north-america/us/massachusetts-latest.osm.pbf
	$(call import,$@,$<)

sf: data/metro/san-francisco.osm.pbf
	$(call import,$@,$<)

seattle: data/metro/seattle.osm.pbf
	$(call import,$@,$<)

sf_bay_area: data/metro/sf-bay-area.osm.pbf
	$(call import,$@,$<)

data/extract/%:
	mkdir -p $$(dirname $@)
	curl -sL http://download.geofabrik.de/$(@:data/extract/%=%) -o $@
	echo done

data/metro/%:
	mkdir -p data/metro
	curl -sL https://s3.amazonaws.com/metro-extracts.mapzen.com/$(@:data/metro/%=%) -o $@

data/osmdata/%:
	mkdir -p data/osmdata
	curl -sL http://data.openstreetmapdata.com/$(@:data/osmdata/%=%) -o $@

%.mml: %.yml .env
	cat $< | (set -a && source .env && interp) > $@

%.xml: %.mml
	carto -l $< > $@
