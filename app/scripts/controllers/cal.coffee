meanApp.controller 'CalController', ['$scope', 'Global', 'HouseService', '$window', ($scope, Global,HouseService, $window) ->

  $scope.global = Global

  $scope.find = () ->
    $scope.houses = HouseService.query()

  $scope.changeValue = (option) ->
    console.log '/#/cal?houseId=' + option['id'] + '&name=' + option['name']
    $window.location.href = '/#/cal?houseId=' + option['id'] + '&name=' + option['name']
]