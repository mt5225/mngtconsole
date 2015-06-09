meanApp.controller 'CalController', ['$scope', 'Global', ($scope, Global) ->

  $scope.global = Global
  $scope.message = "in cal backend page"
]