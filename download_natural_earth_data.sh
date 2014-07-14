#!/bin/sh -ex

# SET THE FOLLOWING environment variables with the same vars. In bash,
#OGR_ENABLE_PARTIAL_REPROJECTION=TRUE
#SHAPE_ENCODING=WINDOWS-1252
#export SHAPE_ENCODING
#export OGR_ENABLE_PARTIAL_REPROJECTION

DIR=`mktemp -d stuffXXXXXX`
#for z in shps/tmp/*.*; do rm $z; done

# 10m Natuarl Earth themes
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip -o $DIR/ne_10m_admin_0_countries_lakes.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_map_units.zip -o $DIR/ne_10m_admin_0_map_units.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_land.zip -o $DIR/ne_10m_admin_0_boundary_lines_land.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_map_units.zip -o $DIR/ne_10m_admin_0_boundary_lines_map_units.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_boundary_lines_disputed_areas.zip -o $DIR/ne_10m_admin_0_boundary_lines_disputed_areas.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_lakes.zip -o $DIR/ne_10m_admin_1_states_provinces_lakes_shp.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_lines.zip -o $DIR/ne_10m_admin_1_states_provinces_lines.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_roads.zip -o $DIR/ne_10m_roads.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip -o $DIR/ne_10m_populated_places.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip -o $DIR/ne_10m_urban_areas.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_ocean.zip -o $DIR/ne_10m_ocean.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip -o $DIR/ne_10m_coastline.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip -o $DIR/ne_10m_lakes.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines_scale_rank.zip -o $DIR/ne_10m_rivers_lake_centerlines_scale_rank.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_geography_marine_polys.zip -o $DIR/ne_10m_geography_marine_polys.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_airports.zip -o $DIR/ne_10m_airports.zip

# 50m Natuarl Earth themes
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries_lakes.zip -o $DIR/ne_50m_admin_0_countries_lakes.zip
#not yet used?
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip -o $DIR/ne_50m_admin_0_boundary_lines_land.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip -o $DIR/ne_50m_admin_1_states_provinces_lakes_shp.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lines.zip -o $DIR/ne_50m_admin_1_states_provinces_lines.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_urban_areas.zip -o $DIR/ne_50m_urban_areas.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_ocean.zip -o $DIR/ne_50m_ocean.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_coastline.zip -o $DIR/ne_50m_coastline.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_lakes.zip -o $DIR/ne_50m_lakes.zip
#curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_rivers_lake_centerlines_scale_rank.zip -o $DIR/ne_50m_rivers_lake_centerlines_scale_rank.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_geography_marine_polys.zip -o $DIR/ne_50m_geography_marine_polys.zip

# 110m Natuarl Earth themes
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_boundary_lines_land.zip -o $DIR/ne_110m_admin_0_boundary_lines_land.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries_lakes.zip -o $DIR/ne_110m_admin_0_countries_lakes.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_boundary_lines_land.zip -o $DIR/ne_50m_admin_0_boundary_lines_land.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_1_states_provinces_lines.zip -o $DIR/ne_110m_admin_1_states_provinces_lines.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip -o $DIR/ne_110m_coastline.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip -o $DIR/ne_110m_land.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_lakes.zip -o $DIR/ne_110m_lakes.zip
curl -L http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_geography_marine_polys.zip -o $DIR/ne_110m_geography_marine_polys.zip


for z in $DIR/*.zip; do unzip $z -d $DIR/; done
for z in $DIR/*.zip; do rm $z; done

# Spherical mercator extent and projection,
# http://proj.maptools.org/faq.html#sphere_as_wgs84
#
EXTENT="-180 -85.05112878 180 85.05112878"
P900913="+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"

# Use http://trac.osgeo.org/gdal/wiki/ConfigOptions#OGR_ENABLE_PARTIAL_REPROJECTION
# and clip source to include only data within spherical mercator world square.
# Encoding conversion will *only work* as of GDAL 1.9.x.
#

for z in $DIR/*.shp; do 
    base="${z%.shp}"; 
    ogr2ogr -f "ESRI Shapefile" -overwrite -s_srs "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs" --config OGR_ENABLE_PARTIAL_REPROJECTION TRUE --config SHAPE_ENCODING WINDOWS-1252 -t_srs "$P900913" -lco ENCODING=UTF-8 -clipsrc $EXTENT -segmentize 1 -skipfailures "${base}-merc.shp" "${base}.shp"; 
    shapeindex "${base}-merc"; 
    ogrinfo -so "${base}-merc.shp" "${base}-merc" | tail -n +4 > info.txt; 
    zip -j "${base}-merc.zip" "${base}-merc.dbf" "${base}-merc.index" "${base}-merc.prj" "${base}-merc.prj" "${base}-merc.shp" "${base}-merc.shx" "${base}-merc.VERSION.txt" "${base}-merc.README.html" info.txt; 
    done

mkdir -p shp/natural_earth
mv $DIR/*-merc.zip shp/natural_earth/

rm -rf $DIR
