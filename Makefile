SHELL := /bin/bash
PATH := $(PATH):node_modules/.bin

define EXPAND_EXPORTS
export $(word 1, $(subst =, , $(1))) := $(word 2, $(subst =, , $(1)))
endef

# load .env
$(foreach a,$(shell cat .env 2> /dev/null),$(eval $(call EXPAND_EXPORTS,$(a))))
# expand PG* environment vars
$(foreach a,$(shell set -a && source .env 2> /dev/null; node_modules/.bin/pgexplode),$(eval $(call EXPAND_EXPORTS,$(a))))

define create_relation
@psql -c "\d $(subst db/,,$@)" > /dev/null 2>&1 || \
	psql -v ON_ERROR_STOP=1 -qX1f sql/$(subst db/,,$@).sql
endef

define create_extension
@psql -c "\dx $(subst db/,,$@)" | grep $(subst db/,,$@) > /dev/null 2>&1 || \
	psql -v ON_ERROR_STOP=1 -qX1c "CREATE EXTENSION $(subst db/,,$@)"
endef

define register_function_target
.PHONY: db/functions/$(strip $(1))

db/functions/$(strip $(1)): db
	@psql -c "\df $(1)" | grep -i $(1) > /dev/null 2>&1 || \
		psql -v ON_ERROR_STOP=1 -qX1f sql/functions/$(1).sql
endef

# Import PBF ($2) as $1
define import
.PHONY: db/osm-$(strip $(word 1, $(subst :, ,$(1)))) db/$(strip $(word 1, $(subst :, ,$(1))))

db/$(strip $(word 1, $(subst :, ,$(1)))): db/osm-$(strip $(word 1, $(subst :, ,$(1)))) db/shared

db/osm-$(strip $(word 1, $(subst :, ,$(1)))): db/postgis db/hstore $(strip $(word 2, $(subst :, ,$(1))))
	@psql -c "\d osm_roads" > /dev/null 2>&1 || \
	imposm3 import \
		--cachedir cache \
		-mapping=imposm3_mapping.json \
		-read $(strip $(word 2, $(subst :, ,$(1)))) \
		-connection="$${DATABASE_URL}" \
		-write \
		-deployproduction \
		-overwritecache
endef

mml: toner

install:
	npm install
	@test -e ${HOME}/Documents/MapBox/project || \
		test -e ${HOME}/Documents/MapBox/project/toner || \
		ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner

clean:
	@rm -f *.mml *.xml

.env:
	@echo DATABASE_URL=postgres:///toner > #@

%: %.mml
	@cp $< project.mml

xml: $(subst yml,xml,$(wildcard *.yml))

.PHONY: DATABASE_URL

DATABASE_URL:
	@test "${$@}" || (echo "$@ is undefined" && false)

.PHONY: db

db: DATABASE_URL
	@psql -c "SELECT 1" > /dev/null 2>&1 || \
	createdb

.PHONY: db/postgis

db/postgis: db
	$(call create_extension)

.PHONY: db/hstore

db/hstore: db
	$(call create_extension)

.PHONY: db/shared

db/shared: db/postgres db/shapefiles

.PHONY: db/postgres

db/postgres: db/functions/highroad

.PHONY: db/shapefiles

db/shapefiles: shp/osmdata/land-polygons-complete-3857.zip \
		   shp/natural_earth/ne_50m_land-merc.zip \
		   shp/natural_earth/ne_50m_admin_0_countries_lakes-merc.zip \
		   shp/natural_earth/ne_10m_admin_0_countries_lakes-merc.zip \
		   shp/natural_earth/ne_10m_admin_0_boundary_lines_map_units-merc.zip \
		   shp/natural_earth/ne_50m_admin_1_states_provinces_lines-merc.zip \
		   shp/natural_earth/ne_10m_geography_marine_polys-merc.zip \
		   shp/natural_earth/ne_50m_geography_marine_polys-merc.zip \
		   shp/natural_earth/ne_110m_geography_marine_polys-merc.zip \
		   shp/natural_earth/ne_10m_airports-merc.zip \
		   shp/natural_earth/ne_10m_roads-merc.zip \
		   shp/natural_earth/ne_10m_lakes-merc.zip \
		   shp/natural_earth/ne_50m_lakes-merc.zip \
		   shp/natural_earth/ne_10m_admin_0_boundary_lines_land-merc.zip \
		   shp/natural_earth/ne_50m_admin_0_boundary_lines_land-merc.zip \
		   shp/natural_earth/ne_10m_admin_1_states_provinces_lines-merc.zip

# TODO places target that lists registered places
PLACES=BC:data/extract/north-america/ca/british-columbia-latest.osm.pbf \
	   CA:data/extract/north-america/us/california-latest.osm.pbf \
	   belize:data/extract/central-america/belize-latest.osm.pbf \
	   cle:data/metro/cleveland_ohio.osm.pbf \
	   MA:data/extract/north-america/us/massachusetts-latest.osm.pbf \
	   NY:data/extract/north-america/us/new-york-latest.osm.pbf \
	   OH:data/extract/north-america/us/ohio-latest.osm.pbf
	   sf:data/metro/san-francisco.osm.pbf \
	   sfbay:data/metro/sf-bay-area.osm.pbf \
	   seattle:data/metro/seattle_washington.osm.pbf \
	   WA:data/extract/north-america/us/washington-latest.osm.pbf 

$(foreach place,$(PLACES),$(eval $(call import,$(place))))

$(foreach fn,$(shell ls sql/functions/ 2> /dev/null | sed 's/\..*//'),$(eval $(call register_function_target,$(fn))))

.SECONDARY: data/extract/%

data/extract/%:
	@mkdir -p $$(dirname $@)
	@curl -sLf http://download.geofabrik.de/$(@:data/extract/%=%) -o $@

.SECONDARY: data/metro/%

data/metro/%:
	@mkdir -p $$(dirname $@)
	@curl -sLf https://s3.amazonaws.com/metro-extracts.mapzen.com/$(@:data/metro/%=%) -o $@

.SECONDARY: data/osmdata/land_polygons.zip

# so the zip matches the shapefile name
data/osmdata/land_polygons.zip:
	@mkdir -p $$(dirname $@)
	@curl -sLf http://data.openstreetmapdata.com/land-polygons-complete-3857.zip -o $@

.PRECIOUS: %.mml

%.mml: %.yml map.mss labels.mss %.mss
	@cat $< | interp > tmp.mml && mv tmp.mml $@

.PRECIOUS: %.xml

%.xml: %.mml
	@echo
	@echo Building $@
	@echo
	@carto -l $< > $@ || (rm -f $@; false)

define natural_earth
db/$(strip $(word 1, $(subst :, ,$(1)))): $(strip $(word 2, $(subst :, ,$(1)))) db/postgis
	@psql -c "\d $$(subst db/,,$$@)" > /dev/null 2>&1 || \
	ogr2ogr --config OGR_ENABLE_PARTIAL_REPROJECTION TRUE \
			--config SHAPE_ENCODING WINDOWS-1252 \
			--config PG_USE_COPY YES \
			-nln $$(subst db/,,$$@) \
			-t_srs EPSG:3857 \
			-lco ENCODING=UTF-8 \
			-nlt PROMOTE_TO_MULTI \
			-lco POSTGIS_VERSION=2.0 \
			-lco GEOMETRY_NAME=geom \
			-lco SRID=3857 \
			-lco PRECISION=NO \
			-clipsrc -180 -85.05112878 180 85.05112878 \
			-segmentize 1 \
			-skipfailures \
			-f PGDump /vsistdout/ \
			/vsizip/$$</$(strip $(word 3, $(subst :, ,$(1)))) | psql -q

shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.shp \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.dbf \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.prj \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.shx: $(strip $(word 2, $(subst :, ,$(1))))
	@mkdir -p $$$$(dirname $$@)
	@ogr2ogr --config OGR_ENABLE_PARTIAL_REPROJECTION TRUE \
			--config SHAPE_ENCODING WINDOWS-1252 \
			-t_srs EPSG:3857 \
			-lco ENCODING=UTF-8 \
			-clipsrc -180 -85.05112878 180 85.05112878 \
			-segmentize 1 \
			-skipfailures $$@ /vsizip/$$</$(strip $(word 3, $(subst :, ,$(1))))

shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.index: shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.shp
	@shapeindex $$<

.SECONDARY: shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.zip

shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.zip: shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.shp \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.dbf \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.prj \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.shx \
	shp/natural_earth/$(strip $(word 1, $(subst :, ,$(1))))-merc.index
	@zip -j $$@ $$^
endef

# <name>:<source file>:[shapefile]
NATURAL_EARTH=ne_50m_land:data/ne/50m/physical/ne_50m_land.zip \
	ne_50m_admin_0_countries_lakes:data/ne/50m/cultural/ne_50m_admin_0_countries_lakes.zip \
	ne_10m_admin_0_countries_lakes:data/ne/10m/cultural/ne_10m_admin_0_countries_lakes.zip \
	ne_10m_admin_0_boundary_lines_map_units:data/ne/10m/cultural/ne_10m_admin_0_boundary_lines_map_units.zip \
	ne_50m_admin_1_states_provinces_lines:data/ne/50m/cultural/ne_50m_admin_1_states_provinces_lines.zip \
	ne_10m_geography_marine_polys:data/ne/10m/physical/ne_10m_geography_marine_polys.zip \
	ne_50m_geography_marine_polys:data/ne/50m/physical/ne_50m_geography_marine_polys.zip \
	ne_110m_geography_marine_polys:data/ne/110m/physical/ne_110m_geography_marine_polys.zip \
	ne_10m_airports:data/ne/10m/cultural/ne_10m_airports.zip \
	ne_10m_roads:data/ne/10m/cultural/ne_10m_roads.zip \
	ne_10m_lakes:data/ne/10m/physical/ne_10m_lakes.zip \
	ne_50m_lakes:data/ne/50m/physical/ne_50m_lakes.zip \
	ne_10m_admin_0_boundary_lines_land:data/ne/10m/cultural/ne_10m_admin_0_boundary_lines_land.zip \
	ne_50m_admin_0_boundary_lines_land:data/ne/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip \
	ne_10m_admin_1_states_provinces_lines:data/ne/10m/cultural/ne_10m_admin_1_states_provinces_lines.zip:ne_10m_admin_1_states_provinces_lines.shp

$(foreach shape,$(NATURAL_EARTH),$(eval $(call natural_earth,$(shape))))

shp/osmdata/%.shp \
shp/osmdata/%.dbf \
shp/osmdata/%.prj \
shp/osmdata/%.shx: data/osmdata/%.zip
	@mkdir -p $$(dirname $@)
	@unzip -j $< -d $$(dirname $@)

shp/osmdata/land_polygons.index: shp/osmdata/land_polygons.shp
	@shapeindex $<

.SECONDARY: data/osmdata/land-polygons-complete-3857.zip

shp/osmdata/land-polygons-complete-3857.zip: shp/osmdata/land_polygons.shp \
	shp/osmdata/land_polygons.dbf \
	shp/osmdata/land_polygons.prj \
	shp/osmdata/land_polygons.shx \
	shp/osmdata/land_polygons.index
	@zip -j $@ $^

define natural_earth_sources
.SECONDARY: data/ne/$(1)/$(2)/%.zip

data/ne/$(1)/$(2)/%.zip:
	@mkdir -p $$(dir $$@)
	@curl -sfL http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/$(1)/$(2)/$$(@:data/ne/$(1)/$(2)/%=%) -o $$@
endef

scales=10m 50m 110m
themes=cultural physical raster

$(foreach a,$(scales),$(foreach b,$(themes),$(eval $(call natural_earth_sources,$(a),$(b)))))
