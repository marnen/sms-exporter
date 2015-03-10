angular.module('smsExporter', []).config ['$provide', ($provide) ->
  $provide.value 'lib', process.env.PWD + '/build/scripts/lib'
]
