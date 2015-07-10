meanApp.controller 'HouseController', ($scope, Global, HouseService, $log, $routeParams, $location) ->
  $scope.global = Global
  $scope.find = () ->
    $log.debug "get house list"
    $scope.houses = HouseService.query()
  
  $scope.findOne = () ->
    house = HouseService.get {id: $routeParams.houseId}
    $scope.house = house

  $scope.update = () ->
    $log.debug "save house id = #{$scope.house.id}"
    $scope.house.$save ( () ->
      $location.path "houses",
      (errorResponse) ->
        $log.debug errorResponse.data.message
    )
