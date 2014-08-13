"use strict";

var util = require("util");

var async = require("async"),
    request = require("request"),
    merc = new (require("sphericalmercator"))();

var STAMEN = [-122.41934,37.7648797];

var endpoint = process.argv[2];
var config = require("./tessera.json");

var tests = [];
Object.keys(config).forEach(function(prefix) {
  for (var i=0; i <= 20; i++) { tests.push({"zoom":i, "prefix":prefix}); }
});

console.log("Endpoint: " + endpoint);
console.log("Tests: " + tests.length);

var funs = tests.map(function(test) {
  var px = merc.px(STAMEN,test.zoom),
      tile = {
        x: Math.floor(px[0] / 256),
        y: Math.floor(px[1] / 256),
        z: test.zoom
      },
      uri = util.format("%s%s/%d/%d/%d.png", endpoint, test.prefix, tile.z, tile.x, tile.y);

  return [uri, function(callback) {
    return request(uri, function (error, response, body) {
      if (response.statusCode !== 200) {
        console.log(uri + " is " + response.statusCode);
      }

      return callback(null, response.statusCode, body);
    });
  }];
}).reduce(function(obj, v) {
  obj[v[0]] = v[1];

  return obj;
}, {});

async.parallel(funs, function(err, results) {
  console.log("2xx: " + Object.keys(results).filter(function(k) { return results[k][0]  >= 200 && results[k][0] < 300 }).length);
  console.log("3xx: " + Object.keys(results).filter(function(k) { return results[k][0]  >= 300 && results[k][0] < 400 }).length);
  console.log("4xx: " + Object.keys(results).filter(function(k) { return results[k][0]  >= 400 && results[k][0] < 500 }).length);
  console.log("5xx: " + Object.keys(results).filter(function(k) { return results[k][0]  >= 500 }).length);
});
