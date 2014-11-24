FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y build-essential curl git software-properties-common unzip zip && \
  apt-add-repository -y ppa:chris-lea/node.js && \
  apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable && \
  apt-get update && \
  apt-get install -y nodejs mapnik-utils gdal-bin && \
  apt-get clean

RUN useradd -d /app -m ubuntu

USER ubuntu
ENV HOME /app
WORKDIR /app

COPY . /app
RUN \
  npm install && \
  rm -rf .node-gyp/ && \
  rm -rf .npm/

# Define mountable directories
VOLUME ["/app/shp"]
ENV PORT 8080
EXPOSE 8080

CMD ["npm", "start"]
