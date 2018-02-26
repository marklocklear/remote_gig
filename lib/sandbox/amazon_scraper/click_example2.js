var casper = require('casper').create();

casper.start('http://google.fr/');

casper.then(function() {
    console.log(this.getCurrentUrl());
});

casper.thenEvaluate(function(term) {
    document.querySelector('input[name="q"]').setAttribute('value', term);
    document.querySelector('form[name="f"]').submit();
}, 'CasperJS');

casper.then(function() {
    // Click on 1st result link
    this.click('h3.r a');
});

casper.then(function() {
    console.log('clicked ok, new location is ' + this.getCurrentUrl());
});

casper.then(function() {
    // Click on 1st result link
		this.evaluate(function() {
    	document.querySelector('#link-documentation-full').click();
    });
});

casper.then(function() {
    console.log('clicked ok, new location is ' + this.getCurrentUrl());
});

casper.run();

