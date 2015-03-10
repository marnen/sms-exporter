fs = require 'fs'

smsDb = '3d0d7e5fb2ce288813306e4d4636395e047a3d28' # fixed name of SMS DB file, thanks to Apple


sortByMtime = (filenames) ->
  mtimes = {}
  filenames.sort (a, b) ->
    # TODO: can we make this asynchronous?
    mtimeA = mtimes[a] ||= fs.statSync(a).mtime
    mtimeB = mtimes[b] ||= fs.statSync(b).mtime

    if mtimeA < mtimeB
      1
    else if mtimeA == mtimeB
      0
    else if mtimeA > mtimeB
      -1

module.exports =
  path: ->
    if process.env.NW_ENV == 'cucumber'
      home = fs.readFileSync "#{process.env.PWD}/tmp/.test_home"
    else
      home = process.env.HOME
    backupDir = "#{home}/Library/Application Support/MobileSync/Backup"

    # TODO: can we make this asynchronous?
    backups = fs.readdirSync(backupDir).map (backup) -> [backupDir, backup].join '/'
    backups = backups.filter (backup) ->
      fs.readdirSync(backup).indexOf(smsDb) != -1
    sortByMtime(backups)[0]