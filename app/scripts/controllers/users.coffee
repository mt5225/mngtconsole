meanApp.controller 'UserController', ['$scope', 'Global', ($scope, Global) ->

  $scope.global = Global
  $scope.message = "in user page"
]