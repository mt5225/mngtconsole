meanApp.controller 'OrderController', ($scope, Global, OrderService, $location, $log, $routeParams) ->

  $scope.global = Global
  $scope.orderByField = 'createDay'
  $scope.reverseSort = false
  $scope.itemsByPage = 10

  $scope.find = () ->
    $scope.orders = OrderService.query()
    $scope.displayedCollection = [].concat($scope.orders);

  $scope.findOne = () ->
    $log.debug "order id = #{$routeParams.orderId}"
    order = OrderService.get {orderId: $routeParams.orderId}
    $scope.order = order

  $scope.update = () ->
    $scope.order.$save ( () ->
      $location.path "orders",
      (errorResponse) ->
        $log.debug errorResponse.data.message
    )
