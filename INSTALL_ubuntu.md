# Installation on Ubuntu

Courtesy of [@smathermather](https://github.com/smathermather).

## Git started

```bash
sudo apt-get install git zip
```

## Install TileMill

### Install node

```bash
sudo apt-get -y install python-software-properties
sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs
```

### Install tilemill

```bash
git clone https://github.com/mapbox/tilemill
cd tilemill
npm install
npm start ## exit for now with control-c
cd ..
```

## Install Imposm

```bash
wget http://imposm.org/static/rel/imposm3-0.1dev-20140811-3f3c12e-linux-x86-64.tar.gz
tar xvf imposm3-0.1dev-20140811-3f3c12e-linux-x86-64.tar.gz
mv imposm3-0.1dev-20140811-3f3c12e-linux-x86-64 imposm3
rm imposm3-0.1dev-20140811-3f3c12e-linux-x86-64.tar.gz
echo 'PATH=$PATH:/root/imposm3' >> ~/.bashrc
source ~/.bashrc
```

## Add mapnik and gdal-utility dependencies

```bash
sudo apt-get -y install mapnik-utils gdal-bin
```

## Install PostGIS and friends

### Dependencies

```bash
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
```

```bash
sudo apt-get install -y autoconf build-essential cmake docbook-mathml \
  docbook-xsl libboost-dev libboost-filesystem-dev libboost-timer-dev \
  libcgal-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev \
  libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev \
  libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev \
  postgresql-server-dev-9.3 xsltproc git build-essential wget
```

### Install Postgres

```bash
sudo apt-get install -y postgresql
sudo apt-get install -y postgresql-contrib-9.3
```

### Install PostGIS

```bash
wget http://download.osgeo.org/postgis/source/postgis-2.1.3.tar.gz
tar -xzf postgis-2.1.3.tar.gz
cd postgis-2.1.3 && ./configure --with-sfcgal=/usr/local/bin/sfcgal-config
make -j2 && sudo make install
cd ..
```

### Create new user

```bash
sudo su - postgres
/etc/init.d/postgresql start
psql --command "CREATE USER gisuser WITH SUPERUSER PASSWORD 'vagrant';"
exit
```

## Finally! Let's get our toner on

```bash
git clone https://github.com/stamen/toner-carto.git
cd toner-carto
npm install && make install
echo 'DATABASE_URL=postgres://vagrant:vagrant@localhost/toner' > .env
make db && make db/postgis
make .env db/OH
```

### Start tilemill

```bash
cd ../tilemill/
npm start
```
