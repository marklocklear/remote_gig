var casper = require('casper').create();
var x = require("casper").selectXPath;

//successfully fetches text
// casper.start("https://www.amazon.jobs/location/virtual-locations", function() {
//     this.echo(this.fetchText(".job"));
// });

// casper.start('https://www.amazon.jobs/location/virtual-locations');
var links = [];
var regex = /en\/jobs\/[\s\S]*?\//g; //begins with /en/jobs then any number of characters, then look for /
var page = '';

casper.start("https://www.amazon.jobs/location/virtual-locations", function() {
  // while class btn btn-primary circle right then...
  page = this.getHTML();
  this.echo("current url is:" + this.getCurrentUrl());
  links = page.match(regex);

  for(var i=0; i < links.length; i++){
    links[i]="https://www.amazon.jobs/" + links[i];
	}
	console.log(links);

});

casper.then(function() {
  // Click on 1st result link
	this.evaluate(function() {
  	document.querySelector('button.btn btn-primary circle right').click();
  });
});

casper.run();