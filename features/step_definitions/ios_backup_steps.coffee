module.exports = ->
  @Given /^the following iOS backups exist:$/, (table, callback) ->
    fs = require 'fs'
    mkdirp = require 'mkdirp'

    backupFileName = '3d0d7e5fb2ce288813306e4d4636395e047a3d28'
    home = @testHome
    backupDir = "#{home.name}/Library/Application Support/MobileSync/Backup"
    mkdirp.sync backupDir

    for backup in table.hashes()
      dirname = "#{backupDir}/#{backup.name}"
      fs.mkdirSync dirname
      fs.writeFileSync "#{dirname}/#{backupFileName}", ''

    callback()
