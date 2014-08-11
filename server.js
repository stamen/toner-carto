"use strict";

// increase the libuv threadpool size to 1.5x the number of logical CPUs.
process.env.UV_THREADPOOL_SIZE = process.env.UV_THREADPOOL_SIZE || Math.ceil(Math.max(4, require('os').cpus().length * 1.5));

var path = require("path");
var raven = require("raven");

var tessera = require("tessera"),
    express = require("express"),
    cors = require("cors"),
    responseTime = require("response-time"),
    tilelive = require("tilelive-cache")(require("tilelive"), {
      size: process.env.CACHE_SIZE,
      sources: process.env.SOURCE_CACHE_SIZE
    });

var app = express();

require("tessera/modules")(tilelive, {});

var config = require("./tessera.json");
Object.keys(config).forEach(function(prefix) {
  if (config[prefix].timing !== false) {
    app.use(prefix, responseTime());
  }

  if (config[prefix].cors !== false) {
    app.use(prefix, cors());
  }

  app.use(raven.middleware.express(process.env.SENTRY_DSN));
  app.use(prefix, express.static(path.join(__dirname, "node_modules/tessera/public")));
  app.use(prefix, express.static(path.join(__dirname, "node_modules/tessera/bower_components")));
  app.use(prefix, tessera(tilelive, config[prefix]));
});

app.listen(process.env.PORT || 8080, function() {
  console.log("Listening at http://%s:%d/", this.address().address, this.address().port);
});
