CREATE VIEW osm_green_areas AS
  SELECT
    osm_id,
    tags -> 'name' as name,
    COALESCE(tags -> 'leisure', tags -> 'landuse', tags -> 'amenity') AS type,
    way_area AS area,
    way geometry
  FROM planet_osm_polygon
  WHERE tags -> 'leisure' IN ('park', 'water_park', 'marina', 'nature_reserve', 'playground', 'garden', 'common', 'sports_centre', 'golf_course', 'stadium', 'track', 'pitch')
    OR tags -> 'amenity' IN ('graveyard')
    OR tags -> 'landuse' IN ('cemetery', 'recreation_ground', 'forest', 'wood');

CREATE VIEW osm_green_areas_z13 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 13) AS geometry,
    geometry as geometry_orig
  FROM osm_green_areas;

CREATE VIEW osm_green_areas_z10 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 10) AS geometry,
    geometry as geometry_orig
  FROM osm_green_areas;
