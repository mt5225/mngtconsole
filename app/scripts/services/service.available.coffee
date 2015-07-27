meanApp = angular.module('meanApp')
meanApp.service 'AvailableService', ($http, $log, API_ENDPOINT) ->
  console.log "Available Service"
  return {
    checkAvailable: (order) ->
      $log.debug "check availability for #{order.name}"
      re = /\//g
      order.checkInDay = order.checkInDay.replace re, '-'
      order.checkOutDay = order.checkOutDay.replace re, '-'
      $http(
        method: 'POST'
        url: "#{API_ENDPOINT}/api/orders/availability"
        headers: {'Content-Type': 'application/json'}
        data: JSON.stringify(order)
        dataType: 'json'
      ).success((data) ->
        return data
      ).error (data) ->
        $log.error "[house service] fail to get availability record from #{API_ENDPOINT}"
        $log.error data

    saveOrder: (order) ->
      $log.debug "save order to backend #{JSON.stringify(order)}"
      $http(
        method: 'POST'
        url: "#{API_ENDPOINT}/api/orders"
        headers: {'Content-Type': 'application/json'}
        data: JSON.stringify(order)
        dataType: 'json'
      ).success((data) ->
        $log.info "[order service] order saved to backend success !"
      ).error (data) ->
        $log.error "[order service] failed to save order"
        $log.debug data

    cancelOrder: (order) ->
      $log.debug "cancel order #{order.orderId}"
      $http(
        method: 'POST'
        url: "#{API_ENDPOINT}/api/orders/#{order.orderId}"
        headers: {'Content-Type': 'application/json'}
        data: JSON.stringify({ status: '订单取消'})
        dataType: 'json'
      ).success((data) ->
        $log.info "[order service] order cancel success  !"
      ).error (data) ->
        $log.error "[order service] failed to cancel order"
        $log.debug data
  }