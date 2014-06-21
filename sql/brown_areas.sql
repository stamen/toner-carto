CREATE VIEW osm_brown_areas AS
  SELECT
    osm_id,
    tags -> 'name' as name,
    COALESCE(tags -> 'landuse', tags -> 'natural', tags -> 'tsunami', tags -> 'tsunami:damage') AS type, -- TODO tsunami, tsunami:damage
    way_area AS area,
    way geometry
  FROM planet_osm_polygon
  WHERE tags -> 'landuse' IN ('brownfield')
    OR tags -> 'natural' IN ('mud', 'wetland')
    OR tags -> 'tsunami' IN ('yes', 'collapsed', 'flood', 'damage')
    OR tags -> 'tsunami:damage' IN ('yes', 'standing_structure', 'destroyed', 'flooded', 'flood', 'scoured', 'collapsed_building', 'debris', 'sea_wall_breach', 'moved', 'debris_field');

CREATE VIEW osm_brown_areas_z13 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 13) AS geometry,
    geometry as geometry_orig
  FROM osm_brown_areas;

CREATE VIEW osm_brown_areas_z10 AS
  SELECT osm_id,
    name,
    type,
    area,
    generalize(geometry, 10) AS geometry,
    geometry as geometry_orig
  FROM osm_brown_areas;
