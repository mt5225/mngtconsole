meanApp.controller 'OrderController', ($scope, Global, OrderService, $location, $log, $routeParams) ->

  $scope.global = Global
  $scope.orderByField = 'createDay'
  $scope.reverseSort = false
  $scope.itemsByPage = 10

  $scope.find = () ->
    OrderService.query()
    .$promise.then ((payload) ->   
      openid = $routeParams['openid']
      $log.debug "openid = #{openid}"
      if openid?
        record = []
        for item in payload
          $log.debug item.wechatOpenID
          record.push item if item.wechatOpenID is openid
        $scope.orders = record
      else
        $scope.orders = payload
      $scope.displayedCollection = [].concat($scope.orders)
    )

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
