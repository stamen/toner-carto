set -e

sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install -y nodejs make mapnik-utils nginx git unzip gdal-bin zip
cd ~/
npm install -g tilelive-mapnik tessera carto millstone js-yaml
