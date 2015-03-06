module.exports = ->
  chai = require 'chai'
  chai.use require 'chai-as-promised'
  @World::expect = chai.expect

  fs = require 'fs'
  mkdirp = require 'mkdirp'
  tmpPath = "#{process.env.PWD}/tmp"
  testHomePath = "#{tmpPath}/.test_home"

  @Before (callback) ->
    tmp = require 'tmp'
    tmp.setGracefulCleanup()
    @testHome = tmp.dirSync prefix: 'test_home_'
    mkdirp.sync tmpPath
    fs.writeFileSync testHomePath, @testHome.name

    browser.resetUrl = 'file://'
    browser.driver.get(browser.baseUrl + 'index.html').then callback

  @After (callback) ->
    fs.unlinkSync testHomePath

    callback()
