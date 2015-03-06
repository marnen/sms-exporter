angular.module('smsExporter').controller 'backupsController', ['$scope', ($scope) ->
  fs = require 'fs'

  $scope.getCurrentBackup = ->
    if process.env.NW_ENV == 'cucumber'
      home = fs.readFileSync("#{process.env.PWD}/tmp/.test_home", {encoding: 'utf8'}).trim()
    else
      process.env.HOME

    fs.readdir "#{home}/Library/Application Support/MobileSync/Backup", (_, files) ->
      $scope.currentBackup = files[0]
      $scope.$digest()
]