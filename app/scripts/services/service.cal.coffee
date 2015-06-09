meanApp = angular.module('meanApp')
meanApp.service 'OrderService', ($resource) ->
    console.log "Order Service"
    return $resource '/api/orders/:orderId', { orderId: '@orderId'}


