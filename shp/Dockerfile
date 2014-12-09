FROM busybox

COPY . /app/shp
RUN chown -R 1000:1000 /app

# Define mountable directories
VOLUME ["/app/shp"]

CMD ["true"]
