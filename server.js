var path = require("path");

process.env.paths__contentPath = path.join(__dirname, "content");

var ghost = require("ghost");