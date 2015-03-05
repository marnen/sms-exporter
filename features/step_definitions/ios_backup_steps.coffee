module.exports = ->
  @Given /^the following iOS backups exist:$/, (table, callback) ->
    backupFileName = '3d0d7e5fb2ce288813306e4d4636395e047a3d28'
    home = process.env.HOME
    backupDir = "#{home}/Library/Application Support/MobileSync/Backup"

    @fs.dir backupDir
    for backup in table.hashes()
      @fs.file "#{backupDir}/#{backup}/#{backupFileName}"

    callback()
