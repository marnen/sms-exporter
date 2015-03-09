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
    context 'only one backup', ->
      it 'returns the full path to the one backup', ->
        dirName = chance.hash()
        backupPath = "#{backupDir}/#{dirName}"
        fs.mkdirSync backupPath

        expect(currentBackup.path()).to.equal backupPath