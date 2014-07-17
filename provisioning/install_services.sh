#!/bin/bash

set -e

# sudo mkdir /var/clone
# sudo ln -s /vagrant/ /var/clone/toner-carto

echo "DATABASE_URL: $DATABASE_URL"
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp /home/ubuntu/toner-carto/tessera.nginx /etc/nginx/sites-available/
sudo ln -f -s /etc/nginx/sites-available/tessera.nginx /etc/nginx/sites-enabled/tessera.conf
sudo cp /home/ubuntu/toner-carto/tessera.conf /etc/init/
pushd ..
PATH=~/node_modules/.bin:$PATH
cd /home/ubuntu/toner-carto && make xml
