# Toner

"Toner" is the name of Stamen's black and white map tiles. It was originally
designed for the Dotspotting project by Geraldine Sarmiento, although many
others have been involved since.

The original Toner was developed as part of Stamen's
[Citytracking](https://github.com/Citytracking) initiative, funded by the
[Knight Foundation](http://www.knightfoundation.org/). The old repository can
be found [here](https://github.com/citytracking/toner), for historical
interest.

![Toner screenshot](https://github.com/stamen/toner-carto/raw/master/toner_world.png?raw=true)

## Developing

### Prerequisites

* PostgreSQL
* PostGIS
* Node.js
* GDAL
* TileMill 1@`master` (this includes the latest Mapnik): [github.com/mapbox/tilemill](https://github.com/mapbox/tilemill)
* [Imposm 3](https://github.com/omniscale/imposm3), which includes dependencies
  of its own: `go`, `leveldb`, and `protobuf`.

On OS X, installation with [Homebrew](http://brew.sh/) looks like this:

```bash
brew install postgis gdal node go leveldb protobuf

# follow instructions to start postgresql

mkdir -p /tmp/imposm
cd /tmp/imposm
export GOPATH=`pwd`
git clone https://github.com/omniscale/imposm3 src/imposm3
go get imposm3
go install imposm3

# bin/imposm3 is your new binary; either add $GOPATH/bin to your PATH or copy
# it to /usr/local/bin (or similar)
```

### Toner Itself

* Clone this repo
* Run `make link` to sym-link the project into your TileMill project directory
* Run `make db/shared` to fetch and transform Natural Earth and OSM coastline data
* Run `make db/ca` (or similar; see
  [`PLACES`](https://github.com/stamen/toner-carto/blob/master/Makefile#L168-L178)
  in the `Makefile` for a list of registered extracts and expand it as
  desired).
* Run `make` to generate the `project.mml` file. (Alternatively, make
  `toner-background`, `toner-buildings`, `toner-hybrid`, `toner-lines`,
  `toner-labels`, or `toner-lite` to work on the variant styles)
* Start TileMill by running `npm start` from the TileMill repo
* Open http://localhost:20009/#/project/toner

`make db/<place>` will write to the database specified in `.env` (with
a default value of `postgres:///toner`). If you experience trouble connecting,
try adding credentials, e.g. `postgres://user:password@localhost/toner` (it
will use `$USER` with no password otherwise).  Barring that, check your
`pg_hba.conf` to ensure that access is configured correctly.

(We primarily develop on OS X where PostgreSQL from Homebrew works out of the
box.)

**NOTE**: Changes to project settings (i.e. not stylesheets) in TileMill will
not persist the changes. To make changes, edit the relevant `.yml` file and
re-run `make [variant]` to re-generate the `project.mml` that TileMill reads.

## Deployment

See [`DEPLOY.md`](https://github.com/stamen/toner-carto/blob/master/DEPLOY.md)
for instructions.

## FAQ

> What's the deal with the `Makefile`? Why is it so complicated?

Magic, mostly. It probably can (and should) be simplified! Consider this
another, in-progress "make for data" approach (which actually uses `make`).

The goal here is to provide an idempotent process for bootstrapping the project
that uses as few additional dependencies as possible.  `make` is the age-old
solution to this problem, although it takes a more file-focused approach. Put
another way, it attempts to efficiently encapsulate otherwise complicated and
error-prone operations.

The `Makefile` here attempts to replicate `make`'s behavior relative to
rebuilding files with database tables. In other words, if a Postgres relation
already exists, it will be left as-is. If it doesn't exist (has been dropped or
hasn't been created), it will be created on-demand.

> Why do I have to install `pgexplode`?

`libpq` (which underlies PostgreSQL's command-line tools) supports a number of
[environment
variables](http://www.postgresql.org/docs/9.4/static/libpq-envars.html) which
can be used to avoid repetition (and avoid errors). However, each component of
the connection information is separate, and is more easily and concisely
encoded in a URI (i.e. `DATABASE_URL`). `pgexplode` is aware of `libpq`'s
environment variables and will expand `DATABASE_URL`s components (which is
simpler than managing multiple values and constructing a URL for `imposm3` and
other tools).
