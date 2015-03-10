module.exports = ->
  @Given /^the following iOS backups exist:$/, (table, callback) ->
    fs = require 'fs'
    mkdirp = require 'mkdirp'

    smsDb = '3d0d7e5fb2ce288813306e4d4636395e047a3d28'
    home = @testHome
    backupDir = "#{home.name}/Library/Application Support/MobileSync/Backup"
    mkdirp.sync backupDir

    for backup in table.hashes()
      dirname = "#{backupDir}/#{backup.name}"
      fs.mkdirSync dirname

      if !backup.SMS or backup.SMS == 'true'
        fs.writeFileSync "#{dirname}/#{smsDb}", ''

      if backup.modified
        atime = fs.statSync(dirname).atime
        fs.utimesSync dirname, atime, new Date backup.modified

    callback()
