"use strict";

var async = require("async");
var request = require("request");
var sphericalmercator = require("sphericalmercator");
var merc = new sphericalmercator({ size: 256 });
var STAMEN = [-122.41934,37.7648797];

var config = require("./tessera.json");

var tests = [];
Object.keys(config).forEach(function(prefix) {
  for (var i=0; i <= 19; i++) { tests.push({"zoom":i, "prefix":prefix}); }
});

console.log("Tests: " + tests.length);

var funs = [];
tests.forEach(function(test) {
  funs.push(function(callback) { 
    var px = merc.px(STAMEN,test.zoom);
    var tile = {"x":Math.floor(px[0]/256), "y":Math.floor(px[1]/256), "z":test.zoom};
    var url = 'http://staging.tile.stamen.com' + test.prefix  + '/' + tile.z + '/' + tile.x + '/' + tile.y + '.png';
    request(url, function (error, response, body) {
      if(response.statusCode == 200) {
        callback(null, response.statusCode);
      } else {
        console.log(url + " is " + response.statusCode);
        callback(null, response.statusCode);
      }
    });
  });
});

async.parallel(funs,
function(err, results){
    console.log("2xx: " + results.filter(function(e) { return e >= 200 && e < 300 }).length);
    console.log("3xx: " + results.filter(function(e) { return e >= 300 && e < 400 }).length);
    console.log("4xx: " + results.filter(function(e) { return e >= 400 && e < 500 }).length);
    console.log("5xx: " + results.filter(function(e) { return e >= 500 }).length);
});

