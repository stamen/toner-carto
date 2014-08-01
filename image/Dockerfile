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
ADD deploy_key /app/.ssh/id_rsa
RUN ssh-keyscan github.com >> /app/.ssh/known_hosts
RUN chown -R ubuntu:ubuntu /app/.ssh/

USER ubuntu
ENV HOME /app
WORKDIR /app

RUN git clone git@github.com:stamen/toner-carto.git

WORKDIR /app/toner-carto

RUN make land
RUN ./download_natural_earth_data.sh

RUN git pull

RUN npm install

RUN make xml

ENV PORT 8080
EXPOSE 8080

CMD ["npm", "start"]
