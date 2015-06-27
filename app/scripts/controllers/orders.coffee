meanApp.controller 'OrderController', ($scope, Global, OrderService, $location, $log, $routeParams) ->

  $scope.global = Global
  $scope.find = () ->
    $scope.orders = OrderService.query()

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
