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

#TODO : determine if this is significantly slower than using split land polygons.
data/land-polygons-complete-3857.zip:
	mkdir -p data
	curl -sL http://data.openstreetmapdata.com/land-polygons-complete-3857.zip -o data/land-polygons-complete-3857.zip

land: data/land-polygons-complete-3857.zip 
	cd shp/ && unzip -o ../data/land-polygons-complete-3857.zip
	cd shp/ && shapeindex land-polygons-complete-3857/land_polygons.shp

sql:
	psql -f highroad.sql

sfo:
	dropdb sfo2
	createdb sfo2
	psql sfo2 -c "create extension postgis"
	~/workspace/imposm/bin/imposm3 import --cachedir cache -mapping=imposm3_mapping.json -read /Volumes/Work/osm/sf-bay-area.osm.pbf -connection="postgis://localhost/sfo2" -write -deployproduction -overwritecache -optimize

merged_labels_z4.shp:
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp shp/city_labels/africa-labels-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp -append shp/city_labels/asia-labels-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp -append shp/city_labels/australia-new-zealand-labels-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp -append shp/city_labels/europe-labels-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp -append shp/city_labels/north-america-labels-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_labels_z4.shp -append shp/city_labels/south-america-labels-z4.shp
	shapeindex merged_labels_z4.shp

merged_points_z4.shp:
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp shp/city_labels/africa-points-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp -append shp/city_labels/asia-points-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp -append shp/city_labels/australia-new-zealand-points-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp -append shp/city_labels/europe-points-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp -append shp/city_labels/north-america-points-z4.shp
	ogr2ogr -t_srs "EPSG:3857" -s_srs "EPSG:4326" merged_points_z4.shp -append shp/city_labels/south-america-points-z4.shp
	shapeindex merged_points_z4.shp
