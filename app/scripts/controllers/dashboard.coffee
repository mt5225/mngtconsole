meanApp.controller 'DashboardController', ($scope, Global, OrderService, HouseService, $location, $log) ->
  Date::addDays = (days) ->
    dat = new Date(@valueOf())
    dat.setDate dat.getDate() + days
    dat

  formatDayStr = (dayObj) ->
    tmp = new Date(dayObj)
    dd = tmp.getDate()
    mm = tmp.getMonth() + 1
    yyyy = tmp.getFullYear()
    dd = '0' + dd if dd < 10
    mm = '0' + mm if mm < 10  
    tmp = yyyy + '-' + mm + '-' + dd

  #get day array
  nextWeekArray = (hop) ->
    weekArray = []
    today = new Date
    curr = new Date(today.getFullYear(), today.getMonth(), today.getDate() + parseInt(hop) * 7)
    $log.debug hop
    $log.debug curr
    #First day is the day of the month - the day of the week
    first = curr.getDate() - curr.getDay() 
    #get first day of this month
    firstDayOfMonth = new Date(curr.getFullYear(), curr.getMonth(), 1)
    for i in [0..6]
      weekArray.push formatDayStr(firstDayOfMonth.addDays(first + i))
    $log.debug weekArray
    weekArray

  $scope.getWeekName = (dayStr) ->
    day = new Date(dayStr)
    ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][day.getDay()]

  $scope.find = (hop) ->
    $log.debug "get order records"
    $scope.orders = OrderService.query()
    $scope.houses = HouseService.query()
    $scope.days = nextWeekArray(hop)

  #todo filter order with right status
  $scope.getOrder = (dayStr, housename) ->
    for order in $scope.orders
      if order.houseName == housename && dayStr >= order.checkInDay && dayStr < order.checkOutDay
        return order.wechatNickName + ' ' + order.orderId

