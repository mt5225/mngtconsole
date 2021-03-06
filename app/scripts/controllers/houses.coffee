meanApp.controller 'HouseController', ($scope, Global, HouseService, $log, $routeParams, $location) ->
  if Global.authenticated isnt true
    $location.path "login" 
    return
    
  $scope.global = Global
  $scope.find = () ->
    $log.debug "get house list"
    sortArray = HouseService.query()
    sortArray.sort (a, b) ->
      switch a.display_id > b.display_id
        when true then 1
        when false then -1
    $scope.houses = sortArray
  
  $scope.findOne = () ->
    HouseService.get {id: $routeParams.houseId}
    .$promise.then((payload) ->
      $scope.house = payload
      $scope.housepic = payload.house_pic_list.join ','
      $scope.ownerpic = payload.owner_pic_list.join ','
      $scope.facpic = payload.facility_pic_list.join ','
    )

  $scope.close = () ->
    $location.path "houses"

  $scope.update = () ->
    $log.debug "save house id = #{$scope.house.id} #{$scope.housepic}"
    #split string to array
    housePicArray = []
    if $scope.housepic?
      housePicArray = $scope.housepic.split ','
      $log.debug  housePicArray
    $scope.house.house_pic_list = housePicArray

    ownerPicArray = []
    if $scope.ownerpic?
      ownerPicArray = $scope.ownerpic.split ','
      $log.debug ownerPicArray
    $scope.house.owner_pic_list = ownerPicArray

    facPicArray = []
    if $scope.facpic?
      facPicArray = $scope.facpic.split ','
      $log.debug facPicArray
    $scope.house.facility_pic_list = facPicArray  

    $scope.house.$save ( () ->
      $location.path "houses",
      (errorResponse) ->
        $log.debug errorResponse.data.message
    )
