# Deploying / Running

## Locally

Create a `.env` file containing at least `DATABASE_URL` pointing to
a PostgreSQL instance with imported data in it.

```bash
npm install
npm start
```

## Build Docker Images

```bash
# build
docker build --rm -t mojodna/toner:<version> .

# test
docker run -e "DATABASE_URL=postgres://.../..." -p 80:8080 <image id>

# tag
docker tag <image id> mojodna/toner:latest

# push
docker push mojodna/toner:latest
```

## Docker with a Data Volume

The advantage of a data volume is that it allows Natural Earth shapefiles to
live in a separate contain that doesn't update regularly, reducing the size of
the application container (and the number of intermediate layers).

```bash
# start the data volume
docker run --name data -v /app/shp bdon/naturalearth:0.0.4

# start the Toner container
docker run --volumes-from data --env-file=env -p 80:8080 -d mojodna/toner:latest
```

`env` must contain at least `DATABASE_URL`.
