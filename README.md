# Toner

"Toner" is the name of Stamen's black and white map tiles. It was originally
designed for the Dotspotting project by Geraldine Sarmiento, although many
others have been involved since.

The original Toner was developed as part of Stamen's [Citytracking](https://github.com/Citytracking) initiative, funded by the [Knight Foundation](http://www.knightfoundation.org/). The old repository can be found [here](https://github.com/citytracking/toner), for historical interest. 

![Toner screenshot](https://github.com/stamen/toner-carto/raw/master/toner_world.png?raw=true)

## Developing

* Install TileMill 1 from HEAD (this has the latest Mapnik): [github.com/mapbox/tilemill](https://github.com/mapbox/tilemill)
* Install Imposm 3: [github.com/omniscale/imposm3](https://github.com/omniscale/imposm3)
* Clone this repo
* Run `make install`, this will symlink the project into your TM1 project directory
* run `make land` to get OSM-derived land polygons 
* run `sh download_natural_earth_data.sh` to get Natural Earth data
* Download an OSM pbf extract and do an import. You should use the make task `ca` as an example.
* Start TileMill with `npm start` from the tilemill repo
