module.exports = ->
  @Before (callback) ->
    @selectorFor = (area) ->
      switch area
        when 'the current backup name'
          '#current_backup'
        else
          throw "Selector for '#{area}' is not defined. Add a mapping in #{__filename}."

    callback()