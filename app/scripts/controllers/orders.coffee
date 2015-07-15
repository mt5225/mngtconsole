meanApp.controller 'OrderController', ($scope, Global, OrderService, HouseService, $location, $log, $routeParams, paramService, uuidService, dateService, AvailableService, $window) ->

  $scope.global = Global
  $scope.orderByField = 'createDay'
  $scope.reverseSort = false
  $scope.itemsByPage = 10
  houses = HouseService.query()

  $scope.find = () ->
    OrderService.query()
    .$promise.then ((payload) ->   
      openid = $routeParams['openid']  #fetch orders by user openid
      $log.debug "check if request come from user menu: openid = #{openid}"
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
    OrderService.get {orderId: $routeParams.orderId}
    .$promise.then ((payload) ->
      $scope.order = payload
      $scope.orderStatus = payload.status
      $scope.totalPrice = payload.totalPrice
    )
    
  $scope.update = () ->
    $scope.order.$save ( () ->
      paramService.set $scope.order
      $location.path "orders",
      (errorResponse) ->
        $log.debug errorResponse.data.message
    )

  $scope.create = () ->
    order = $.extend({}, $scope.order)
    if not order.checkInDay? or not order.checkOutDay? or not order.houseId? or not order.totalPrice?
      $window.alert "请完整填写订单信息"
      return 
    
    order.checkInDay = dateService.formatDate order.checkInDay
    order.checkOutDay = dateService.formatDate order.checkOutDay

    if order.checkInDay >= order.checkOutDay
      $window.alert "退房日期需在入住日期之后"
      return    
    for item in houses
      if $scope.order.houseId is item.id
        order.houseName  = item.name
        break
    order.createDay = dateService.getTodayTime()
    $log.debug order
    AvailableService.checkAvailable order
    .then ((payload) ->
      $log.debug payload.data
      if payload.data.available is "true"
        AvailableService.saveOrder order
        .then ((payload) ->
          $log.debug "order create success, redirect to order list"
          paramService.set order
          $location.path "orders"
        )
      else
        $window.alert "营地已经被预订"
    )
    
  $scope.cancelOrder = () ->
    $scope.order.$save ( () ->
      AvailableService.cancelOrder $scope.order
      .then((payload) ->
        $log.debug payload.data
        paramService.set payload.data
        $location.path "orders"
      )
    )
    
  $scope.close = () ->
    $location.path "orders"

  #setting some dummy fields for create order by admin
  $scope.initCreate = () ->
    $log.debug "init new order"
    order = {}
    order.orderId = uuidService.generateUUID()
    order.wechatNickName = "漫生活管家"
    order.wechatOpenID = "N/A"
    $scope.houses = houses
    $scope.order = order

  $scope.highlight = (order) ->
    currentOrder = paramService.get()
    if currentOrder?
      return currentOrder.orderId is order.orderId
    else
      return false