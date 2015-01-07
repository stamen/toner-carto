# Deploying / Running

Stamen uses a combination of [CircleCI](https://circleci.com) and
[Quay](https://quay.io/) to build and host [Docker](http://docker.com) images.

There are 2 images:

* [stamen/toner](https://quay.io/repository/stamen/toner)
* [stamen/toner-data](https://quay.io/repository/stamen/toner-data)

Images are only built from tagged commits.

`stamen/toner` is built directly by Quay using the root
[`Dockerfile`](https://github.com/stamen/toner-carto/blob/master/Dockerfile)
and contains both styles and the necessary software to serve tiles. It requires
a data volume (`toner-data`) and `DATABASE_URL` provided in the environment. If
`SENTRY_DSN` is provided, errors will be logged to
[Sentry](https://getsentry.com/).

`stamen/toner-data` is the corresponding [data
volume](https://docs.docker.com/userguide/dockervolumes/). Because it requires
bootstrapping of downloaded data (convenient for development when stored in
`data/`), it is built by CircleCI and published to Quay using
[`shp/Dockerfile`](https://github.com/stamen/toner-carto/blob/master/shp/Dockerfile)
and
[`circle.yml`](https://github.com/stamen/toner-carto/blob/master/circle.yml).

To start rendering tiles, bootstrap a PostgreSQL database with an OSM extract
(or full planet, if you're ambitious) by running `make db/sf` and run the
following commands:

```bash
export DATABASE_URL=<network-accessible Postgres URL>

# create the data volume
docker run --name data quay.io/stamen/toner-data:v0.1.0

# start the renderer, mapping :8080 in the container to :80 on the host
docker run \
  -p 80:8080 \
  --volumes-from data \
  -e DATABASE_URL=$DATABASE_URL \
  --rm \
  --name toner \
  quay.io/stamen/toner:v1.1.0
```

(Check the image links above for current version information.)

Alternately, here's a systemd unit compatible with
[CoreOS](https://coreos.com/):

```cfg
[Unit]
Description=Toner
After=docker.service
Requires=docker.service

[Service]
User=core
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker kill toner
ExecStartPre=-/usr/bin/docker kill data
ExecStartPre=-/usr/bin/docker rm toner
ExecStartPre=-/usr/bin/docker rm -v data
ExecStartPre=-/usr/bin/docker pull quay.io/stamen/toner-data:v0.1.0
ExecStartPre=-/usr/bin/docker pull quay.io/stamen/toner:v1.1.0
ExecStartPre=/usr/bin/docker run --name data quay.io/stamen/toner-data:v0.1.0
ExecStart=/usr/bin/docker run -p 80:8080 --volumes-from data -e DATABASE_URL=<redacted> --rm --name toner quay.io/stamen/toner:v1.1.0
ExecStop=/usr/bin/docker kill toner
ExecStop=/usr/bin/docker kill data
```

## Building Locally

```bash
# build the data volume
make db/shapefiles # bootstrap data
docker build --rm -t toner-data shp/

# build the renderer
docker build --rm -t toner .
```

Once built, you can run as above, substituting `toner-data` and `toner` for
`quay.io/stamen/...`.
