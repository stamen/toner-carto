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

.env:
	touch $@

%: %.mml
	cp $< project.mml

xml: toner.xml toner-base.xml toner-background.xml toner-lines.xml toner-buildings.xml toner-labels.xml toner-hybrid.xml

land: data/osmdata/land-polygons-complete-3857.zip data/osmdata/simplified-land-polygons-complete-3857.zip
	cd shp/ && unzip -o ../data/osmdata/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp
	cd shp/ && unzip -o ../data/osmdata/simplified-land-polygons-complete-3857.zip
	cd shp/ && shapeindex simplified-land-polygons-complete-3857/simplified_land_polygons.shp

# Missing, due to unpredictable filenames in the zip:
#   shp/ne/50m/cultural/ne_50m_admin_1_states_provinces_lines-merc.zip
#   shp/ne/110m/cultural/ne_110m_admin_1_states_provinces_lines-merc.zip
natural-earth: shp/ne/10m/cultural/ne_10m_admin_0_countries_lakes-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_0_map_units-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_0_boundary_lines_land-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_0_boundary_lines_map_units-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_0_boundary_lines_disputed_areas-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_1_states_provinces_lakes-merc.zip \
	           shp/ne/10m/cultural/ne_10m_admin_1_states_provinces_lines-merc.zip \
	           shp/ne/10m/cultural/ne_10m_roads-merc.zip \
	           shp/ne/10m/cultural/ne_10m_populated_places-merc.zip \
	           shp/ne/10m/physical/ne_10m_coastline-merc.zip \
	           shp/ne/10m/physical/ne_10m_lakes-merc.zip \
	           shp/ne/10m/physical/ne_10m_geography_marine_polys-merc.zip \
	           shp/ne/10m/cultural/ne_10m_airports-merc.zip \
	           shp/ne/50m/cultural/ne_50m_admin_0_countries_lakes-merc.zip \
	           shp/ne/50m/cultural/ne_50m_admin_0_boundary_lines_land-merc.zip \
	           shp/ne/50m/cultural/ne_50m_admin_1_states_provinces_lakes-merc.zip \
	           shp/ne/50m/physical/ne_50m_coastline-merc.zip \
	           shp/ne/50m/physical/ne_50m_lakes-merc.zip \
	           shp/ne/50m/physical/ne_50m_geography_marine_polys-merc.zip \
	           shp/ne/110m/cultural/ne_110m_admin_0_boundary_lines_land-merc.zip \
	           shp/ne/110m/cultural/ne_110m_admin_0_countries_lakes-merc.zip \
	           shp/ne/110m/physical/ne_110m_coastline-merc.zip \
	           shp/ne/110m/physical/ne_110m_land-merc.zip \
	           shp/ne/110m/physical/ne_110m_lakes-merc.zip \
	           shp/ne/110m/physical/ne_110m_geography_marine_polys-merc.zip

imposm_%:
	@psql -l | grep -w $@ | wc -l | grep 1 > /dev/null

belize: data/extract/central-america/belize-latest.osm.pbf imposm_belize
	$(call import,$@,$<)

ca: data/extract/north-america/us/california-latest.osm.pbf imposm_ca
	$(call import,$@,$<)

ma: data/extract/north-america/us/massachusetts-latest.osm.pbf imposm_ma
	$(call import,$@,$<)

wa: data/extract/north-america/us/washington-latest.osm.pbf imposm_wa
	$(call import,$@,$<)

ny: data/extract/north-america/us/new-york-latest.osm.pbf imposm_ny
	$(call import,$@,$<)

bc: data/extract/north-america/ca/british-columbia-latest.osm.pbf imposm_bc
	$(call import,$@,$<)

sf: data/metro/san-francisco.osm.pbf imposm_sf
	$(call import,$@,$<)

seattle: data/metro/seattle.osm.pbf imposm_seattle
	$(call import,$@,$<)

sf_bay_area: data/metro/sf-bay-area.osm.pbf imposm_sf_bay_area
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

toner.mml: toner.yml .env map.mss labels.mss
	cat toner.yml | (set -a && source .env && interp) > $@

toner-background.mml: toner-background.yml .env map.mss labels.mss
	cat toner-background.yml | (set -a && source .env && interp) > $@

toner-buildings.mml: toner-buildings.yml .env map.mss labels.mss toner-buildings.mss
	cat toner-buildings.yml | (set -a && source .env && interp) > $@

toner-hybrid.mml: toner-hybrid.yml .env map.mss labels.mss toner-lines.mss
	cat toner-hybrid.yml | (set -a && source .env && interp) > $@

toner-lines.mml: toner-lines.yml .env map.mss labels.mss toner-lines.mss
	cat toner-lines.yml | (set -a && source .env && interp) > $@

toner-labels.mml: toner-labels.yml .env map.mss labels.mss toner-labels.mss
	cat toner-labels.yml | (set -a && source .env && interp) > $@

%.mml: %.yml .env
	cat $< | (set -a && source .env && interp) > $@

%.xml: %.mml
	carto -l $< > $@

define NE_ZIP
.PRECIOUS: data/ne/$(1)/$(2)/%.zip

data/ne/$(1)/$(2)/%.zip:
	mkdir -p $$(dir $$@)
	curl -sfL http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/$(1)/$(2)/$$(@:data/ne/$(1)/$(2)/%=%) -o $$@
	touch $$@

.PRECIOUS: data/ne/$(1)/$(2)/%.shp

data/ne/$(1)/$(2)/%.dbf data/ne/$(1)/$(2)/%.prj data/ne/$(1)/$(2)/%.shp data/ne/$(1)/$(2)/%.shx data/ne/$(1)/$(2)/%.README.html data/ne/$(1)/$(2)/%.VERSION.txt: data/ne/$(1)/$(2)/%.zip
# data/ne/$(1)/$(2)/%.shp: data/ne/$(1)/$(2)/%.zip
	unzip -o $$< -d $$(dir $$<)
	touch $$@

.PRECIOUS: shp/ne/$(1)/$(2)/%.shp

shp/ne/$(1)/$(2)/%.dbf shp/ne/$(1)/$(2)/%.prj shp/ne/$(1)/$(2)/%.shp shp/ne/$(1)/$(2)/%.shx: data/ne/$(1)/$(2)/%.shp
	mkdir -p $$(dir $$@)
	ogr2ogr --config OGR_ENABLE_PARTIAL_REPROJECTION TRUE \
			--config SHAPE_ENCODING WINDOWS-1252 \
			-t_srs EPSG:3857 \
			-lco ENCODING=UTF-8 \
			-clipsrc -180 -85.05112878 180 85.05112878 \
			-segmentize 1 \
			-skipfailures $$@ $$<

.PRECIOUS: shp/ne/$(1)/$(2)/%.index

shp/ne/$(1)/$(2)/%.index: shp/ne/$(1)/$(2)/%.shp
	shapeindex $$<

.PRECIOUS: shp/ne/$(1)/$(2)/%.zip

shp/ne/$(1)/$(2)/%-merc.zip: shp/ne/$(1)/$(2)/%.index
	zip -j $$@ $$(<:index=*)

db/ne/$(1)/$(2)/%: data/ne/$(1)/$(2)/%.shp
	ogr2ogr --config PG_USE_COPY YES \
		    --config OGR_ENABLE_PARTIAL_REPROJECTION TRUE \
			--config SHAPE_ENCODING WINDOWS-1252 \
			-nlt PROMOTE_TO_MULTI \
			-t_srs EPSG:3857 \
			-lco ENCODING=UTF-8 \
			-lco GEOMETRY_NAME=geom \
			-lco POSTGIS_VERSION=2.0 \
			-clipsrc -180 -85.05112878 180 85.05112878 \
			-segmentize 1 \
			-skipfailures \
			-f PGDump /vsistdout/ \
			$$< | psql -q
endef

scales=10m 50m 110m
themes=cultural physical raster

$(foreach a,$(scales),$(foreach b,$(themes),$(eval $(call NE_ZIP,$(a),$(b)))))
