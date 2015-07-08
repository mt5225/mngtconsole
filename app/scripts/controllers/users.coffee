meanApp.controller 'UserController', ($scope, Global, UserService, $log, $routeParams, $location) ->
  $scope.global = Global

  $scope.fruits = ['家居','教育','健康','美食','环艺','音乐','文学','视觉','科技','定制','宗教']
  
  $scope.find = () ->
    $scope.users = UserService.query()

  $scope.findOne = () ->
    $log.debug "user openid = #{$routeParams.openid}"
    UserService.get({openid: $routeParams.openid})
    .$promise.then ((payload) ->
      $scope.user = payload
      $scope.subscribe_time = new Date (parseInt($scope.user.subscribe_time)*1000)
      $log.debug payload.fav
      $scope.selection = $scope.user.fav
    )
   
  $scope.update = () ->
    $log.debug $scope.selection
    $scope.user.fav = $scope.selection
    $scope.user.$save ( () ->
      $location.path "users",
      (errorResponse) ->
        $log.debug errorResponse.data.message
    )

  $scope.toggleSelection = (fruitName) ->
    idx = $scope.selection.indexOf(fruitName)
    if idx > -1
      $scope.selection.splice idx, 1
    else
      $scope.selection.push fruitName
    return