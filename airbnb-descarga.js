#!/usr/bin/env node

var http = require('http'),
    fs = require('fs');

var url_file = process.argv[2]?process.argv[2]:"idsminitest.csv";
var data_dir = process.argv[3]?process.argv[3]:".";
if (!fs.existsSync(data_dir)){
    fs.mkdirSync(data_dir);
}
var urls = fs.readFileSync(url_file, "utf8");
var ids = urls.match(/(\d+)/g);

ids.forEach( function( id ) {
    var file_name = data_dir+"/airbnb-"+id+".json";
    var response = http.get("http://airbnb.com/rooms/"+id, function(response){
        //de https://davidwalsh.name/nodejs-http-request
        var body = '';
        response.on('data', function(d) {
            body += d;
        });
        response.on('end', function() {

            var json_chunk = body.match(/script type="application.json" data-hypernova-key="p3indexbundlejs" data-hypernova-id="\S+"><!--(.+)-->/);
            if (json_chunk) {
                var airbnb_data = JSON.parse(json_chunk);
                airbnb_data["airbnb_id"] = id;
                fs.writeFileSync(file_name, JSON.stringify(airbnb_data));
            } else {
                console.log( "Listado "+ id + " no está disponible")
            }
            
        });
    })
    console.log(file_name);
})