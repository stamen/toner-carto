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
         'no'::text AS is_link,
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
      ORDER BY z_order ASC, priority DESC);

CREATE VIEW highroad_z11 AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,
         'no'::text AS is_link,
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
      ORDER BY z_order ASC, priority DESC);

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
      ORDER BY z_order ASC, priority DESC);

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
      ORDER BY z_order ASC, priority DESC);

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
      ORDER BY z_order ASC, priority DESC);

CREATE VIEW highroad_z15plus AS
(SELECT geometry,
         highway,
         railway,
         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
               WHEN highway IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway') THEN 'path'
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN 'rail'
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
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN .5
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
         OR railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail')
      ORDER BY explicit_layer ASC, implied_layer ASC, priority DESC);

CREATE OR REPLACE FUNCTION zoom(scaleDenominator numeric) RETURNS int AS $$
BEGIN
  CASE
    WHEN scaleDenominator > 1000000000 THEN RETURN 0;
    WHEN scaleDenominator <= 1000000000 AND scaleDenominator > 500000000 THEN RETURN 1;
    WHEN scaleDenominator <= 500000000 AND scaleDenominator > 200000000 THEN RETURN 2;
    WHEN scaleDenominator <= 200000000 AND scaleDenominator > 100000000 THEN RETURN 3;
    WHEN scaleDenominator <= 100000000 AND scaleDenominator > 50000000 THEN RETURN 3;
    WHEN scaleDenominator <= 50000000 AND scaleDenominator > 25000000 THEN RETURN 4;
    WHEN scaleDenominator <= 25000000 AND scaleDenominator > 12500000 THEN RETURN 5;
    WHEN scaleDenominator <= 12500000 AND scaleDenominator > 6500000 THEN RETURN 6;
    WHEN scaleDenominator <= 6500000 AND scaleDenominator > 3000000 THEN RETURN 7;
    WHEN scaleDenominator <= 3000000 AND scaleDenominator > 1500000 THEN RETURN 8;
    WHEN scaleDenominator <= 1500000 AND scaleDenominator > 750000 THEN RETURN 9;
    WHEN scaleDenominator <= 750000 AND scaleDenominator > 400000 THEN RETURN 10;
    WHEN scaleDenominator <= 400000 AND scaleDenominator > 200000 THEN RETURN 11;
    WHEN scaleDenominator <= 200000 AND scaleDenominator > 100000 THEN RETURN 12;
    WHEN scaleDenominator <= 100000 AND scaleDenominator > 50000 THEN RETURN 13;
    WHEN scaleDenominator <= 50000 AND scaleDenominator > 25000 THEN RETURN 14;
    WHEN scaleDenominator <= 25000 AND scaleDenominator > 12500 THEN RETURN 15;
    WHEN scaleDenominator <= 12500 AND scaleDenominator > 5000 THEN RETURN 16;
    WHEN scaleDenominator <= 5000 AND scaleDenominator > 2500 THEN RETURN 17;
    WHEN scaleDenominator <= 2500 AND scaleDenominator > 1500 THEN RETURN 18;
    WHEN scaleDenominator <= 1500 AND scaleDenominator > 750 THEN RETURN 19;
    WHEN scaleDenominator <= 750 AND scaleDenominator > 500 THEN RETURN 20;
    WHEN scaleDenominator <= 500 AND scaleDenominator > 250 THEN RETURN 21;
    WHEN scaleDenominator <= 250 AND scaleDenominator > 100 THEN RETURN 22;
    WHEN scaleDenominator <= 100 THEN RETURN 23;
  END CASE;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION high_road(scaleDenominator numeric, bbox box3d)
  RETURNS TABLE(geometry geometry, highway character varying, railway character varying, kind text, is_link text, is_tunnel text, is_bridge text, explicit_layer integer) AS
$$
DECLARE
  conditions TEXT;
BEGIN
  -- TODO use zoom()
  CASE
    WHEN zoom(scaleDenominator) = 13 THEN
      conditions := 'is_bridge=''no''';

    WHEN zoom(scaleDenominator) >= 14 THEN
      conditions := 'is_bridge=''no'' AND is_tunnel=''no''';

    ELSE
      conditions := 'true';
  END CASE;

  RETURN QUERY SELECT * FROM high_road(scaleDenominator, bbox, conditions);
END
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION high_road(scaleDenominator numeric, bbox box3d, conditions text)
  RETURNS TABLE(geometry geometry, highway character varying, railway character varying, kind text, is_link text, is_tunnel text, is_bridge text, explicit_layer integer) AS
$$
DECLARE
  tablename TEXT;
BEGIN
  CASE
    WHEN zoom(scaleDenominator) <= 10 THEN
      tablename := 'highroad_z10';

    WHEN zoom(scaleDenominator) = 11 THEN
      tablename := 'highroad_z11';

    WHEN zoom(scaleDenominator) = 12 THEN
      tablename := 'highroad_z12';

    WHEN zoom(scaleDenominator) = 13 THEN
      tablename := 'highroad_z13';

    WHEN zoom(scaleDenominator) = 14 THEN
      tablename := 'highroad_z14';

    WHEN zoom(scaleDenominator) >= 15 THEN
      tablename := 'highroad_z15plus';

    ELSE
      RAISE EXCEPTION 'Unsupported zoom level: %', scaleDenominator;
  END CASE;

  RETURN QUERY EXECUTE format(
    'SELECT geometry, highway, railway, kind, is_link, is_tunnel, is_bridge, explicit_layer
     FROM %I
     WHERE geometry && $1
      AND %s', tablename, conditions
  ) USING bbox;
END
$$
LANGUAGE 'plpgsql';
