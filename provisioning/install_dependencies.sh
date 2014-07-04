set -e

sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs make mapnik-utils nginx git
sudo npm install -g tessera carto millstone
