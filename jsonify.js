"use strict";

var fs = require("fs"),
    url = require("url");
var yaml = require("js-yaml");

process.stdin.resume();

var chunks = [];

process.stdin.on("data", function(chunk) {
  chunks.push(chunk);
});

process.stdin.on("end", function() {
  var body = Buffer.concat(chunks).toString("utf8");

  // pull the database URL from the environment or the command line
  var creds = url.parse(process.env.DATABASE_URL || process.argv[2]);
  var auth = (creds.auth || "").split(":", 2);

  // update the YAML representation before macro expansion
  body = body.replace("{{dbname}}", creds.path.slice(1))
      .replace("{{dbhost}}", creds.hostname)
      .replace("{{dbuser}}", auth[0])
      .replace("{{dbpassword}}", auth[1] || "")
      .replace("{{dbport}}", creds.port || "");

  // load YAML (and expand macros)
  var cfg = yaml.safeLoad(body);

  // output JSON
  fs.writeFileSync("project.mml", JSON.stringify(cfg, null, "  "), "utf8");
});
