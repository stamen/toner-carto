set -e

# sudo mkdir /var/clone
# sudo ln -s /vagrant/ /var/clone/toner-carto

echo "DATABASE_URL: $DATABASE_URL"
sudo rm -f /etc/nginx/sites-enabled/default
sudo service nginx restart
sudo cp tessera.nginx /etc/nginx/sites-available/
sudo cp tessera.conf /etc/init/
pushd ..
cat project.yml | node jsonify.js $DATABASE_URL
millstone project.mml > project_milled.mml
carto project_milled.mml > project.xml
sudo service tessera status
