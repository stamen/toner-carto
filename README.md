## Developing

* Install TileMill 1 from HEAD (this has the latest Mapnik): [github.com/mapbox/tilemill](https://github.com/mapbox/tilemill)
* Install Imposm 3: [github.com/omniscale/imposm3](https://github.com/omniscale/imposm3)
* Clone this repo
* Run `make install`, this will symlink the project into your TM1 project directory
* run `make land` to get OSM-derived land polygons 
* run `sh download_natural_earth_data.sh` to get Natural Earth data
* Download an OSM pbf extract and do an import. You should use the make task `ca` as an example.
* Start TileMill with `npm start` from the tilemill repo
