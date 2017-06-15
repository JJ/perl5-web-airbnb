#!/usr/bin/env node

var http = require('http'),
    fs = require('fs');

var url_file = process.argv[2]?process.argv[2]:"miniurls.csv";
var data_dir = process.argv[3]?process.argv[3]:"data";

var urls = fs.readFileSync(url_file);
var ids = urls.match(/(\d+)/);