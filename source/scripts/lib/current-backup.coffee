fs = require 'fs'

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

exports.path = ->
  if process.env.NW_ENV == 'cucumber'
    home = fs.readFileSync "#{process.env.PWD}/tmp/.test_home"
  else
    home = process.env.HOME

  backupDir = "#{home}/Library/Application Support/MobileSync/Backup"

  # TODO: can we make this asynchronous?
  backups = fs.readdirSync(backupDir).map (filename) -> [backupDir, filename].join '/'
  sortByMtime(backups)[0]