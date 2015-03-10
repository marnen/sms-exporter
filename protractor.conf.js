'use strict';

exports.config = {
  chromeDriver: './support/chromedriver', // relative path to node-webkit's chromedriver
  directConnect: true, // starting Selenium server isn't required in our case
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      binary: require('./node_modules/nw/lib/findpath')()
    }
  },
  baseUrl: 'file://' + process.env.PWD + '/build/',
  rootElement: 'html', // specify a correct element where you bootstrap your AngularJS app, 'body' by default

  onPrepare: function() {

      // By default, Protractor use data:text/html,<html></html> as resetUrl, but
      // location.replace (see http://git.io/tvdSIQ) from the data: to the file: protocol is not allowed
      // (we'll get ‘not allowed local resource’ error), so we replace resetUrl with one
      // with the file: protocol (this particular one will open system's root folder)
      browser.resetUrl = 'file://';

      // This isn't required and used to avoid ‘Cannot extract package’ error showed
      // before Protractor have redirected node-webkit to resetUrl.
      browser.driver.get('file://');
  }
};