"use strict";

// increase the libuv threadpool size to 1.5x the number of logical CPUs.
process.env.UV_THREADPOOL_SIZE = process.env.UV_THREADPOOL_SIZE || Math.ceil(Math.max(4, require('os').cpus().length * 1.5));

require('memwatch').on("leak", console.log);

var path = require("path");
var raven = require("raven");

var onHeaders = require('on-headers');

var tessera = require("tessera"),
    express = require("express"),
    cors = require("cors"),
    tilelive = require("tilelive-cache")(require("tilelive"), {
      size: process.env.CACHE_SIZE,
      sources: process.env.SOURCE_CACHE_SIZE
    });

var app = express().disable("x-powered-by");

require("tessera/modules")(tilelive, {});


var loggingThreshold = +(process.env.LOG_MS || 5000);
var slowLogger = function(req, res, next) {
  var startAt = process.hrtime();

  onHeaders(res, function () {
    if (this.getHeader('X-Response-Time')) {
      return;
    }

    var diff = process.hrtime(startAt);
    var ms = diff[0] * 1e3 + diff[1] * 1e-6;

    if (ms > loggingThreshold) {
      console.log("SLOW REQUEST ", req.originalUrl, " ", ms, " ms");
    }
    this.setHeader('X-Response-Time', ms.toFixed(3) + 'ms');
  });

  next();
};

var config = require("./tessera.json");
Object.keys(config).forEach(function(prefix) {
  if (config[prefix].timing !== false) {
    app.use(prefix, slowLogger);
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
