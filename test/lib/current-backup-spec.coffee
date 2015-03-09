chai = require('chai')
expect = chai.expect
rekuire = require 'rekuire'

describe 'currentBackup', ->
  currentBackup = rekuire 'current-backup'
  mockFs = require 'mock-fs'
  backupDir = "#{process.env.HOME}/Library/Application Support/MobileSync/Backup"
  fs = require 'fs'
  Chance = require 'chance'
  chance = new Chance

  beforeEach ->
    fsConfig = {}
    fsConfig[backupDir] = {}
    mockFs fsConfig

  afterEach ->
    mockFs.restore()

  describe '.path', ->
    smsDb = '3d0d7e5fb2ce288813306e4d4636395e047a3d28' # fixed name of SMS DB file

    createSmsDbIn = (path) =>
      fs.writeFileSync "#{path}/#{smsDb}", ''

    context 'only one backup', ->
      it 'returns the full path to the one backup', ->
        dirname = chance.hash()
        backupPath = "#{backupDir}/#{dirname}"
        fs.mkdirSync backupPath
        createSmsDbIn backupPath

        expect(currentBackup.path()).to.equal backupPath

    context 'backup folders without SMS DB file', ->
      it 'ignores them', ->
        dirname = chance.hash()
        backupPath = "#{backupDir}/#{dirname}"
        fs.mkdirSync backupPath
        createSmsDbIn backupPath

        emptyFolder = chance.hash()
        fs.mkdirSync "#{backupDir}/#{emptyFolder}"

        expect(currentBackup.path()).to.equal backupPath

    context 'multiple backups', ->
      it 'returns the full path to the backup with the latest mtime', ->
        backups = {}
        backups[chance.hash()] = new Date '1980-01-01'
        latestName = chance.hash()
        backups[latestName] = new Date '2015-03-01'
        backups[chance.hash()] = new Date '2014-01-01'

        for own backup, mtime of backups
          backupPath = "#{backupDir}/#{backup}"
          fs.mkdirSync backupPath
          createSmsDbIn backupPath
          atime = fs.statSync(backupPath).atime
          fs.utimesSync backupPath, atime, mtime

        expect(currentBackup.path()).to.equal "#{backupDir}/#{latestName}"