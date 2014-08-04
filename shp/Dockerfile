FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common

RUN \
  apt-add-repository -y ppa:chris-lea/node.js && \
  apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable && \
  apt-get update && \
  apt-get install -y nodejs make mapnik-utils git unzip gdal-bin zip curl

RUN useradd -d /app -m ubuntu

USER ubuntu
ENV HOME /app
WORKDIR /app

COPY . /app/shp

