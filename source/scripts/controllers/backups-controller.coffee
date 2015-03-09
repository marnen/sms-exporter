angular.module('smsExporter').controller 'backupsController', ['$scope', 'lib', ($scope, lib) ->
  fs = require 'fs'
  currentBackup = require "#{lib}/current-backup"

  $scope.getCurrentBackup = ->
    $scope.currentBackup = currentBackup.path()
]