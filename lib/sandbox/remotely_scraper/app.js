//https://regexr.com/3ku0n

var casper = require('casper').create();
var x = require("casper").selectXPath;

var links = [];
var regex = /remote-jobs\/[\s\S][^"]*/g;
var page = '';

casper.start("https://weworkremotely.com/", function() {
  page = this.getHTML();
  // this.echo("current url is:" + this.getCurrentUrl());
  // console.log(page)
  links = page.match(regex);

  for(var i=0; i < links.length; i++){
    links[i]="https://weworkremotely.com/" + links[i];
	}
	console.log(links);

});

casper.run();