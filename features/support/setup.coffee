module.exports = ->
  chai = require 'chai'
  chai.use require 'chai-as-promised'
  @World::expect = chai.expect

  @Before (callback) ->
    FakeFS = require 'fake-fs'
    @fs = new FakeFS

    browser.resetUrl = 'file://'
    browser.driver.get(browser.baseUrl + 'index.html').then callback