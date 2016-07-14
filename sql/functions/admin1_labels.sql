-- credit: Paul Ramsey's answer to http://gis.stackexchange.com/questions/162162/postgis-query-to-retrieve-the-largest-polygon-for-multi-polygons-by-grouping-on

DROP TABLE IF EXISTS ne_10m_admin_1_states_provinces_labels;

CREATE TABLE ne_10m_admin_1_states_provinces_labels AS (
  WITH geoms AS (
    SELECT name, admin, scalerank, (ST_Dump(geom)).geom AS geometry
    FROM ne_10m_admin_1_states_provinces_scale_rank
  )
  SELECT DISTINCT ON (name) name, admin, scalerank, ST_PointOnSurface(geometry) AS geometry
  FROM geoms
  ORDER BY name ASC, ST_Area(geometry) DESC
);
