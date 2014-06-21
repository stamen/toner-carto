CREATE VIEW osm_buildings AS
  SELECT
    osm_id,
    tags -> 'name' as name,
    tags -> 'building' AS type,
    way_area AS area,
    way geometry
  FROM planet_osm_polygon
  WHERE tags ? 'building';

CREATE VIEW osm_buildings_z13 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 13) AS geometry,
    geometry as geometry_orig
  FROM osm_buildings;
