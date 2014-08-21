## Developing

* Install TileMill 1 from HEAD (this has the latest Mapnik): [github.com/mapbox/tilemill](https://github.com/mapbox/tilemill)
* Install Imposm 3: [github.com/omniscale/imposm3](https://github.com/omniscale/imposm3)
* Clone this repo
* Run `make install`, this will symlink the project into your TM1 project directory
* run `make land` to get OSM-derived land polygons 
* run `sh download_natural_earth_data.sh` to get Natural Earth data
* Download an OSM pbf extract and do an import. You should use the make task `ca` as an example.
* Start TileMill with `npm start` from the tilemill repo

## Deploying

### Locally

```bash
npm install
npm start
```

### EC2

```bash
export AWS_ACCESS_KEY=...
export AWS_SECRET_KEY=...

make baseami
BASEAMI=... make ami

ec2-run-instances <AMI> -t m1.small -z us-east-1d -k <keypair> -p EC2_Instance
```

### Docker

```bash
# (locally)
docker build --rm -t mojodna/toner:<version> .
docker run -e "DATABASE_URL=postgres://.../..." -p 80:8080 <image id>
docker tag <image id> mojodna/toner:latest
docker push mojodna/toner:latest

# (on a new EC2 instance using Stamen's Docker AMI)
sudo docker pull mojodna/toner:latest
sudo docker ps
sudo docker stop <container>
sudo docker run --env-file=env -p 80:8080 -d mojodna/toner:latest
```

## Useful SQL snippets

    CREATE OR REPLACE FUNCTION generalize(geom geometry, zoom int) RETURNS geometry
    AS $$
    BEGIN
      -- generalize to 1/4 pixel (assuming 256x256 tiles)
      RETURN ST_Simplify(geom, 20037508.34 * 2 / 2^(9 + zoom));
    END
    $$ LANGUAGE plpgsql IMMUTABLE;
    
-----
    
    SELECT 'GRANT SELECT ON ' || quote_ident(schemaname) || '.' || quote_ident(viewname) || ' TO render;'
    FROM pg_views
    WHERE schemaname = 'public';
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO render;
