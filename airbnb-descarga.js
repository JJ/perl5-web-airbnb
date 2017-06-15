#!/usr/bin/env node

var https = require('https'),
    fs = require('fs');

var url_file = process.argv[2]?process.argv[2]:"idsminitest.csv";
var data_dir = process.argv[3]?process.argv[3]:".";
if (!fs.existsSync(data_dir)){
    fs.mkdirSync(data_dir);
}
var urls = fs.readFileSync(url_file, "utf8");
var ids = urls.match(/(\d+)/g);

var regex = /script type="application.json" data-hypernova-key="p3indexbundlejs" data-hypernova-id="\S+"><!--(.+)-->/;
ids.forEach( function( id ) {
    var response = https.get("https://airbnb.com/rooms/"+id, function(response){
        //de https://davidwalsh.name/nodejs-http-request
        var body = '';
        response.on('data', function(d) {
            body += d;
        });
        response.on('end', function() {
            console.log(body);
            var match = regex.exec(body);
            console.log(match);
            var json_chunk = match[1];
            if (json_chunk) {
                var airbnb_data = JSON.parse(json_chunk);
                airbnb_data["airbnb_id"] = id;
                fs.writeFileSync(data_dir+"/airbnb-"+id+".json", JSON.stringify(airbnb_data));
            } else {
                console.log( "Listado "+ id + " no está disponible")
            }
            
        });
    })
    
})