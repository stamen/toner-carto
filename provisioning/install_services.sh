#!/bin/bash

set -e

# sudo mkdir /var/clone
# sudo ln -s /vagrant/ /var/clone/toner-carto

cd /home/ubuntu && npm install tilelive-cache cors express response-time
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp /home/ubuntu/toner-carto/tessera.nginx /etc/nginx/sites-available/
sudo ln -f -s /etc/nginx/sites-available/tessera.nginx /etc/nginx/sites-enabled/tessera.conf
cat /home/ubuntu/toner-carto/tessera.conf | SENTRY_DSN=$SENTRY_DSN envsubst > /home/ubuntu/toner-carto/tessera-env.conf
sudo cp /home/ubuntu/toner-carto/tessera-env.conf /etc/init/tessera.conf
pushd ..
PATH=/home/ubuntu/toner-carto/node_modules/.bin:$PATH
cd /home/ubuntu/toner-carto && make xml
