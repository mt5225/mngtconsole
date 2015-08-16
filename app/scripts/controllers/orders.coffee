meanApp.controller 'OrderController', ($scope, Global, OrderService, HouseService, $location, $log, $routeParams, paramService, uuidService, dateService, AvailableService, $window, API_ENDPOINT, APP_URL, MessageService) ->
  if Global.authenticated isnt true
    $location.path "login" 
    return
  $scope.global = Global
  $scope.orderByField = 'createDay'
  $scope.reverseSort = false
  $scope.itemsByPage = 10
  houses = HouseService.query()
  $scope.orderStatus = {}

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
      $log.debug "order #{$scope.order.orderId} status is #{$scope.order.status}"
      if $scope.order.status is "预订成功" #send notification to user and manager
        msgBookSuccess $scope.order 
        AvailableService.setOrderSuccess $scope.order
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
    $('#modal1').closeModal()
    paramService.set $scope.order
    $scope.order.$save ( () ->
      AvailableService.cancelOrder $scope.order
      msgOrderCancel $scope.order
      .then((payload) ->
        $log.debug payload.data
        $location.path "orders"
      )
    )

  $scope.closeDialog = () ->
    $('#modal1').closeModal()

  $scope.all = () ->
    $scope.search = ""
    $("#orderSearch")[0].focus()

  $scope.notPay = () ->
    $scope.search = "已提交" 
    $("#orderSearch")[0].focus()
    
   
  #notify user order cancel
  msgOrderCancel = (orderDetails) ->
    return if !$scope.order.wechatOpenID
    msg = {}
    msg.touser = $scope.order.wechatOpenID
    msg.template_name = "order_cancel"
    msg.url = "#{APP_URL}/#/myorder?openid=#{msg.touser}"
    msg.data = 
      first: value: "漫生活管家已经将您的#{orderDetails.houseName}订单取消"
      HotelName: value: "#{orderDetails.houseName}"
      CheckInDate: value: "#{orderDetails.checkInDay}"
      CheckOutDate: value: "#{orderDetails.checkOutDay}"
      remark: value: "编号为#{orderDetails.orderId} 的订单已成功取消, 点击本消息可查看订单历史，感谢您关注漫生活"
    #add some color
    for item of msg.data
      msg.data[item].color = "#01579b"
    $log.debug msg
    MessageService.send msg

  #notify user order cancel
  msgBookSuccess = (orderDetails) ->
    $log.debug "notify user order is success"
    tribeName = 'N/A'
    for house in houses
      tribeName = house.tribe if orderDetails.houseId is house.id
    msg = {}
    msg.touser = $scope.order.wechatOpenID
    msg.template_name = "order_success"
    msg.url = "#{APP_URL}/static/map.html?tribe=#{tribeName}"
    msg.data = 
      first: value: "漫生活管家已经将您的#{orderDetails.houseName}订单设定为预订成功, 订单号 #{orderDetails.orderId}"
      hotelName: value: "#{tribeName}"
      roomName: value: "#{orderDetails.houseName}"
      date: value: "#{orderDetails.checkInDay}"
      remark: value: "点击本消息查看驾车路线，漫生活管家联系电话0571-64668358, #{orderDetails.houseName}欢迎您"
    #add some color
    for item of msg.data
      msg.data[item].color = "#01579b"
    $log.debug msg
    MessageService.send msg
        

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