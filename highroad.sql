DROP VIEW IF EXISTS highroad_z15plus;
DROP VIEW IF EXISTS highroad_z14;
DROP VIEW IF EXISTS highroad_z13;
DROP VIEW IF EXISTS highroad_z12;
DROP VIEW IF EXISTS highroad_z11;
DROP VIEW IF EXISTS highroad_z10;

CREATE VIEW highroad_z10 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,
         'no'::VARCHAR AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,
         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk', 'primary') THEN 1
               WHEN highway IN ('secondary', 'tertiary') THEN 2
               ELSE 99 END) AS priority,
          0 as explicit_layer
      FROM osm_planet_osm_line_z10
      ORDER BY priority DESC);

CREATE VIEW highroad_z11 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,
         'no'::VARCHAR AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,
         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk', 'primary') THEN 1
               WHEN highway IN ('secondary', 'tertiary') THEN 2
               ELSE 99 END) AS priority,
          0 as explicit_layer
      FROM osm_planet_osm_line_z11
      ORDER BY priority DESC);

CREATE VIEW highroad_z12 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'secondary', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,
         (CASE WHEN highway IN ('motorway_link') THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,
         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk', 'secondary', 'primary') THEN 1
               WHEN highway IN ('tertiary', 'residential', 'unclassified', 'road') THEN 2
               WHEN highway LIKE '%%_link' THEN 3
               ELSE 99 END) AS priority,
          0 as explicit_layer
      FROM osm_planet_osm_line_z12
      ORDER BY priority DESC);

CREATE VIEW highroad_z13 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,
         (CASE WHEN highway IN ('motorway_link', 'secondary_link','tertiary_link') THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,
         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('motorway_link') THEN 1
               WHEN highway IN ('trunk', 'primary', 'secondary', 'tertiary') THEN 2
               WHEN highway IN ('trunk_link', 'primary_link', 'secondary_link') THEN 3
               WHEN highway IN ('residential', 'unclassified', 'road') THEN 4
               ELSE 99 END) AS priority,
          0 as explicit_layer
      FROM osm_planet_osm_line_z13
      ORDER BY priority DESC);

CREATE VIEW highroad_z14 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
               WHEN highway IN ('residential', 'unclassified', 'road', 'minor') THEN 'minor_road'
               WHEN railway IN ('rail') THEN 'rail'
               ELSE 'unknown' END) AS kind,
         (CASE WHEN highway IN ('motorway_link','trunk_link','primary_link','secondary_link','tertiary_link') THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         -- highways still need to be layered on top of everything else at z14
         (CASE WHEN highway IN ('motorway', 'motorway_link', 'trunk', 'trunk_link') THEN 0
               ELSE 99 END) AS grouping,

         -- explicit layer is the physical layering of under- and overpasses
               z_order AS explicit_layer,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk') THEN 1
               WHEN highway IN ('primary') THEN 2
               WHEN highway IN ('secondary') THEN 3
               WHEN highway IN ('tertiary') THEN 4
               WHEN highway IN ('motorway_link','trunk_link','primary_link','secondary_link','tertiary_link') THEN 5
               WHEN highway IN ('residential', 'unclassified', 'road', 'minor') THEN 6
               WHEN railway IN ('rail') THEN 7
               ELSE 99 END) AS priority
      FROM osm_planet_osm_line_z14
      ORDER BY grouping DESC, explicit_layer ASC, priority DESC);

CREATE VIEW highroad_z15plus AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
               WHEN highway IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway') THEN 'path'
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_guage', 'monorail') THEN 'rail'
               ELSE 'minor_road' END) AS kind,
         (CASE WHEN highway IN ('motorway_link','trunk_link','primary_link','secondary_link','tertiary_link') THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel = 1 THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge = 1 THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         -- explicit layer is the physical layering of under- and overpasses
               z_order AS explicit_layer,
         -- implied layer is guessed based on bridges and tunnels
         (CASE WHEN tunnel = 1 THEN -1
               WHEN bridge = 1 THEN 1
               ELSE 0
               END) AS implied_layer,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_guage', 'monorail') THEN .5
               WHEN highway IN ('trunk') THEN 1
               WHEN highway IN ('primary') THEN 2
               WHEN highway IN ('secondary') THEN 3
               WHEN highway IN ('tertiary') THEN 4
               WHEN highway IN ('motorway_link','trunk_link','primary_link','secondary_link','tertiary_link') THEN 5
               WHEN highway IN ('residential', 'unclassified', 'road') THEN 6
               WHEN highway IN ('unclassified', 'service', 'minor') THEN 7
               ELSE 99 END) AS priority
      FROM osm_roads
      WHERE highway IN ('motorway', 'motorway_link')
         OR highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link')
         OR highway IN ('residential', 'unclassified', 'road', 'unclassified', 'service', 'minor')
         OR highway IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway')
         OR railway IN ('rail', 'tram', 'light_rail', 'narrow_guage', 'monorail')
      ORDER BY explicit_layer ASC, implied_layer ASC, priority DESC);

CREATE OR REPLACE FUNCTION high_road(scaleDenominator numeric, bbox box3d)
  RETURNS TABLE(geometry geometry, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text, explicit_layer int) AS
$$
BEGIN
  -- TODO use concatenation for this
  CASE
    -- z10-
    WHEN scaleDenominator > 400000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z10 as tbl
      WHERE tbl.geometry && bbox;

    -- z11
    WHEN scaleDenominator <= 400000 AND scaleDenominator > 200000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z11 as tbl
      WHERE tbl.geometry && bbox;

    -- z12
    WHEN scaleDenominator <= 200000 AND scaleDenominator > 100000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z12 as tbl
      WHERE tbl.geometry && bbox;

    -- z13
    WHEN scaleDenominator <= 100000 AND scaleDenominator > 50000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z13 as tbl
      WHERE tbl.geometry && bbox;

    -- z14
    WHEN scaleDenominator <= 50000 AND scaleDenominator > 25000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z14 as tbl
      WHERE tbl.geometry && bbox;

    -- z15+
    WHEN scaleDenominator <= 25000 THEN
      RETURN QUERY SELECT tbl.geometry, tbl.highway::text, tbl.railway::text, tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text, tbl.explicit_layer::int
      FROM highroad_z15plus as tbl
      WHERE tbl.geometry && bbox;

    ELSE
      NULL;
   END CASE;
END
$$
LANGUAGE 'plpgsql';
