var casper = require('casper').create();

casper.start('https://www.amazon.jobs/location/virtual-locations');

casper.then(function() {
    console.log(this.getCurrentUrl());
});

casper.then(function() {
    // Click on 1st result link
    this.click("#//div[@id='main-content']/div[6]/div/div/div[2]/content/div/div/div[2]/div[3]/div/div/div/button[7]");
    //*[@id="main-content"]/div[6]/div/div/div[2]/content/div/div/div[2]/div[3]/div[1]/div/div/button[7]
});

casper.then(function() {
    console.log('clicked ok, new location is ' + this.getCurrentUrl());
});

casper.run();
