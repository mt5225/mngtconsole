meanApp.controller 'HouseController', ['$scope', 'Global', 'HouseService', ($scope, Global, HouseService) ->

  $scope.global = Global
  $scope.find = () ->
    $scope.houses = HouseService.query()
]