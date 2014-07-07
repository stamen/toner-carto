set -e

# sudo mkdir /var/clone
# sudo ln -s /vagrant/ /var/clone/toner-carto

echo "DATABASE_URL: $DATABASE_URL"
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp tessera.nginx /etc/nginx/sites-available/
sudo ln -f -s /etc/nginx/sites-available/tessera.nginx /etc/nginx/sites-enabled/tessera.conf
sudo cp tessera.conf /etc/init/
pushd ..
cat project.yml | node jsonify.js $DATABASE_URL
~/node_modules/.bin/millstone project.mml > project_milled.mml
~/node_modules/.bin/carto project_milled.mml > project.xml
sudo service tessera restart
sudo service nginx restart
