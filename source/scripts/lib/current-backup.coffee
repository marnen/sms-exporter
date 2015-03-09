fs = require 'fs'

exports.path = ->
  if process.env.NW_ENV == 'cucumber'
    home = fs.readFileSync "#{process.env.PWD}/tmp/.test_home"
  else
    home = process.env.HOME

  backupDir = "#{home}/Library/Application Support/MobileSync/Backup"

  files = fs.readdirSync backupDir # TODO: can we make this asynchronous?
  [backupDir, files[0]].join '/'