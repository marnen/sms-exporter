module.exports = ->
  @Given /^I pause$/, (callback) ->
    browser.pause()
    callback()