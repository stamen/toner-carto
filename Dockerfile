FROM 66fc87917728

ENV DEBIAN_FRONTEND noninteractive

USER ubuntu
ENV HOME /app
WORKDIR /app

COPY package.json /app/package.json
RUN npm install
COPY merged_labels /app/merged_labels
COPY Makefile /app/Makefile
COPY fonts /app/fonts
COPY icons /app/icons
COPY images /app/images
COPY labels.mss /app/
COPY map.mss /app/
COPY toner-buildings.mss /app/
COPY toner-labels.mss /app/
COPY toner-lines.mss /app/

COPY toner-background.yml /app/
COPY toner-base.yml /app/
COPY toner-buildings.yml /app/
COPY toner-hybrid.yml /app/
COPY toner-labels.yml /app/
COPY toner-lines.yml /app/
COPY toner.yml /app/
COPY server.js /app/
COPY tessera.json /app/

USER root
RUN chown -R ubuntu:ubuntu /app/shp
USER ubuntu
RUN make xml

ENV PORT 8080
EXPOSE 8080

CMD ["npm", "start"]
