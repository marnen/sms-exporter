angular.module('smsExporter').controller 'myController', ['$scope', ($scope) ->
  $scope.getCurrentBackup = ->
    $scope.currentBackup = '1234567890'
]