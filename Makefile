# use PGDATABASE PGHOST etc.

mml: project.mml

install:
	mkdir -p ${HOME}/Documents/MapBox/project
	ln -sf "`pwd`" ${HOME}/Documents/MapBox/project/toner-background
	npm install && npm rebuild
	echo DATABASE_URL=postgres:///osm > .env

clean:
	rm project.mml

project.mml: project.yml
	cat project.yml | (source .env && node jsonify.js $$DATABASE_URL)

sql:
	psql -f sql/generalize.sql
	psql -f sql/green_areas.sql
	psql -f sql/brown_areas.sql
	psql -f sql/water_areas.sql
	psql -f sql/roads.sql
	psql -f sql/buildings.sql

data/land-polygons-split-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/land-polygons-split-3857.zip -o data/land-polygons-split-3857.zip

land: data/land-polygons-split-3857.zip
	cd shp/ && unzip -o ../data/land-polygons-split-3857.zip
	cd shp/ && shapeindex land-polygons-split-3857/land_polygons.shp
