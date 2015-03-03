module.exports = ->
  chai = require 'chai'
  chai.use require 'chai-as-promised'
  @World::expect = chai.expect