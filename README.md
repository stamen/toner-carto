
CREATE OR REPLACE FUNCTION generalize(geom geometry, zoom int) RETURNS geometry
AS $$
BEGIN
  -- generalize to 1/4 pixel (assuming 256x256 tiles)
  RETURN ST_Simplify(geom, 20037508.34 * 2 / 2^(9 + zoom));
END
$$ LANGUAGE plpgsql IMMUTABLE;
