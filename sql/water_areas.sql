CREATE VIEW osm_water_areas AS
  SELECT
    osm_id,
    tags -> 'name' as name,
    COALESCE(tags -> 'natural', tags -> 'waterway', tags -> 'landuse') AS type,
    way_area AS area,
    way geometry
  FROM planet_osm_polygon
  WHERE tags -> 'natural' IN ('water', 'bay')
    OR tags -> 'waterway' IN ('riverbank')
    OR tags -> 'landuse' IN ('reservoir');

CREATE VIEW osm_water_areas_z13 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 13) AS geometry,
    geometry as geometry_orig
  FROM osm_water_areas;

CREATE VIEW osm_water_areas_z10 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 10) AS geometry,
    geometry as geometry_orig
  FROM osm_water_areas;
