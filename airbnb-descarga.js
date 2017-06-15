#!/usr/bin/env node

var page = require('webpage').create(),
    fs = require('fs');

page.settings.userAgent = 'LavinKeAgent';
var url_file = "idsminitest.csv";
var data_dir = "data";

var urls = fs.read(url_file);
var ids = urls.match(/(\d+)/g);
console.log(ids);
var regex = /script type="application.json" data-hypernova-key="spaspabundlejs" data-hypernova-id="\S+"><!--(.+)-->/;
ids.forEach( function( id ) {
    var url = ("https://airbnb.com/rooms/"+id);
    console.log(url);
    page.open(url,
	      function(status) {
		  if ( status == 'success' ) {
		      var body = page.content;
		      console.log(body);
		      var match = regex.exec(body);
		      console.log(match);
		      var json_chunk = match[1];
		      if (json_chunk) {
			  var airbnb_data = JSON.parse(json_chunk);
			  airbnb_data["airbnb_id"] = id;
			  fs.write(data_dir+"/airbnb-"+id+".json", JSON.stringify(airbnb_data). "w");
		      } else {
			  console.log( "Listado "+ id + " falla");
		      }
		      phantom.exit();

		  } else {
		      console.log( "Listado "+ id + " no se puede descargar");
		  }
	      });
});

