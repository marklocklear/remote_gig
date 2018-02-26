var casper = require('casper').create();
var x = require("casper").selectXPath;

//successfully fetches text
// casper.start("https://www.amazon.jobs/location/virtual-locations", function() {
//     this.echo(this.fetchText(".job"));
// });

// casper.start('https://www.amazon.jobs/location/virtual-locations');
var links = [];
var regex = /remote-usa\/[\s\S]*?\/?([^\/\s]+\/)?([^\/\s]+\/)?([^\/\s]+\/)/g;
var page = '';

casper.start("https://redhat.jobs/jobs/?location=Remote%2C+USA#", function() {
  page = this.getHTML();
  // this.echo("current url is:" + this.getCurrentUrl());
  // console.log(page)
  links = page.match(regex);

  for(var i=0; i < links.length; i++){
    links[i]="https://redhat.jobs/" + links[i];
	}
	console.log(links);

});

casper.run();