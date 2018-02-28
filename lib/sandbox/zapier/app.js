//casperjs
var casper = require('casper').create();
var x = require("casper").selectXPath;

casper.start("https://zapier.com/about/", function() {
  page = this.getHTML(x('//*[@id="app"]/div[2]/div/div/div/ul'));
	console.log(page);
});

casper.run();