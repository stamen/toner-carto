FROM bdon/naturalearth:0.0.4

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential

USER ubuntu
ENV HOME /app
WORKDIR /app

COPY merged_labels /app/merged_labels
COPY fonts /app/fonts
COPY package.json /app/package.json
RUN npm install
COPY icons /app/icons
COPY images /app/images

COPY labels.mss /app/
COPY map.mss /app/
COPY toner-buildings.mss /app/
COPY toner-labels.mss /app/
COPY toner-lines.mss /app/
COPY toner-lite.mss /app/

COPY toner-background.yml /app/
COPY toner-base.yml /app/
COPY toner-buildings.yml /app/
COPY toner-hybrid.yml /app/
COPY toner-labels.yml /app/
COPY toner-lines.yml /app/
COPY toner-lite.yml /app/
COPY toner.yml /app/
COPY server.js /app/
COPY tessera.json /app/
COPY Makefile /app/Makefile

RUN make xml

ENV PORT 8080
EXPOSE 8080

CMD ["npm", "start"]
