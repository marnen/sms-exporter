module.exports = ->
  expect = @World::expect

  @When /^I click "([^"]*)"$/, (text, callback) ->
    browser.findElement(`by`.xpath "//button[contains(text(), '#{text}')]").click().then callback

  @Then /^I should see "([^"]*)" within (.+)$/, (text, area, callback) ->
    expect(browser.findElement(`by`.css @selectorFor area).getText()).to.eventually.contain(text).and.notify callback
